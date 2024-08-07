{ stdenv
, lib
, fetchurl
, fetchpatch
, pkg-config
, vala
, glib
, meson
, ninja
, libxslt
, gtk3
, enableBackend ? stdenv.isLinux
, webkitgtk_4_1
, json-glib
, librest_1_0
, libxml2
, libsecret
, gtk-doc
, gobject-introspection
, gettext
, icu
, glib-networking
, libsoup_3
, docbook-xsl-nons
, docbook_xml_dtd_412
, gnome
, gcr
, libkrb5
, gvfs
, dbus
, wrapGAppsHook
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-online-accounts";
  version = "3.48.0";

  outputs = [ "out" "dev" ] ++ lib.optionals enableBackend [ "man" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-online-accounts/${lib.versions.majorMinor finalAttrs.version}/gnome-online-accounts-${finalAttrs.version}.tar.xz";
    hash = "sha256-QYu5/P/b1yqYIFrTZRN2F/weNVGlTedPapjUXSZhdb8=";
  };

  patches = [
    # Fix crash with EWS and libxml2.12.
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gnome-online-accounts/-/commit/b9638e2418408be4906752297e700506766dcf20.patch";
      hash = "sha256-l9+qS9WF3RuG9NtQQzSjpFSLNJV4FkXxOsLKYbINqrQ=";
    })
  ];

  mesonFlags = [
    "-Dfedora=false" # not useful in NixOS or for NixOS users.
    "-Dgoabackend=${lib.boolToString enableBackend}"
    "-Dgtk_doc=${lib.boolToString enableBackend}"
    "-Dman=${lib.boolToString enableBackend}"
    "-Dmedia_server=true"
  ];

  nativeBuildInputs = [
    dbus # used for checks and pkg-config to install dbus service/s
    docbook_xml_dtd_412
    docbook-xsl-nons
    gettext
    gobject-introspection
    gtk-doc
    libxslt
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    gcr
    glib
    glib-networking
    gtk3
    gvfs # OwnCloud, Google Drive
    icu
    json-glib
    libkrb5
    librest_1_0
    libxml2
    libsecret
    libsoup_3
  ] ++ lib.optionals enableBackend [
    webkitgtk_4_1
  ];

  env.NIX_CFLAGS_COMPILE = "-I${glib.dev}/include/gio-unix-2.0";

  separateDebugInfo = true;

  passthru = {
    updateScript = gnome.updateScript {
      versionPolicy = "odd-unstable";
      packageName = "gnome-online-accounts";
    };
  };

  meta = with lib; {
    homepage = "https://wiki.gnome.org/Projects/GnomeOnlineAccounts";
    description = "Single sign-on framework for GNOME";
    platforms = platforms.unix;
    license = licenses.lgpl2Plus;
    maintainers = teams.gnome.members;
  };
})
