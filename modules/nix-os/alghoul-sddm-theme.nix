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
    rev = "2425544d7828fae3bb14f217e8b3b2698752c150";
    sha256 = "sha256-7ZBTayiha+zoZvvrMrX8Zc/Tr/d//6ITycAm+kpesug=";
  };
}

