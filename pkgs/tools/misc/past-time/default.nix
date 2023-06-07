{ lib
, buildPythonApplication
, click
, fetchFromGitHub
, freezegun
, pytestCheckHook
, tqdm
}:

buildPythonApplication rec {
  pname = "past-time";
  version = "0.2.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "fabaff";
    repo = pname;
    rev = "refs/tags/${version}";
    sha256 = "0yhc0630rmcx4ia9y6klpx002mavfmqf1s3jb2gz54jlccwqbfgl";
  };

  propagatedBuildInputs = [
    click
    tqdm
  ];

  nativeCheckInputs = [
    freezegun
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "past_time"
  ];

  meta = with lib; {
    description = "Tool to visualize the progress of the year based on the past days";
    homepage = "https://github.com/fabaff/past-time";
    changelog = "https://github.com/fabaff/past-time/releases/tag/${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
