{ lib
, buildPythonPackage
, fetchFromGitLab
, pythonOlder
, pythonAtLeast
, argcomplete
, requests
, looseversion
, gnupg
}:

buildPythonPackage rec {
  pname = "sdkmanager";
  version = "0.6.6";
  format = "setuptools";

  disabled = pythonOlder "3.5";

  src = fetchFromGitLab {
    owner = "fdroid";
    repo = pname;
    rev = version;
    hash = "sha256-Vuht2gH9ivNG7PgG+XKtkdKoszkkoI91reQKg6D50xs=";
  };

  propagatedBuildInputs = [
    argcomplete
    requests
  ] ++ requests.optional-dependencies.socks
  ++ lib.optionals (pythonAtLeast "3.12") [
    looseversion
  ];

  postInstall = ''
    wrapProgram $out/bin/sdkmanager \
      --suffix PATH : ${lib.makeBinPath [ gnupg ]}
  '';

  # has no tests
  doCheck = false;

  pythonImportsCheck = [ "sdkmanager" ];

  meta = with lib; {
    homepage = "https://gitlab.com/fdroid/sdkmanager";
    description = "A drop-in replacement for sdkmanager from the Android SDK written in Python";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ linsui ];
  };
}
