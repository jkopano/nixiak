{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "vivify";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "jannis-baum";
    repo = "Vivify";
    rev = "v${version}";
    hash = "sha256-2lxf21T9y4GMFlk0+qbaJJ/twRffYEBoBXZXe/NRDQk=";
  };

  meta = {
    description = "Live Markdown viewer";
    homepage = "https://github.com/jannis-baum/Vivify";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "vivify";
    platforms = lib.platforms.all;
  };
}
