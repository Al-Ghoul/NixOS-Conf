{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation {
  name = "AlGhoul-SDDM-Theme";
  dontBuild = true;
  installPhase = ''
    mkdir -p $out/share/sddm/themes
    cp -aR $src $out/share/sddm/themes/AlGhoul-SDDM-Theme
  '';

  src = fetchFromGitHub {
    owner = "Al-Ghoul";
    repo = "AlGhoul-SDDM-Theme";
    rev = "daeea29";
    sha256 = "sha256-s5MRDVmTTpzGuw2Z3nsmjaxwsg9fJb6FfCoyM/sNQL8=";
  };
}

