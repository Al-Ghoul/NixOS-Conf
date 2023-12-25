{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "deepfilter-ladspa";
  version = "0.5.6";

  src = fetchFromGitHub {
    owner = "Rikorose";
    repo = "DeepFilterNet";
    rev = "v${version}";
    hash = "sha256-5bYbfO1kmduNm9YV5niaaPvRIDRmPt4QOX7eKpK+sWY=";
  };

  cargoLock = {
    # lockfile from https://raw.githubusercontent.com/Rikorose/DeepFilterNet/v0.5.3/Cargo.lock
    lockFile = ./Cargo.lock;
    outputHashes = {
      "hdf5-0.8.1" = "sha256-qWF2mURVblSLPbt4oZSVxIxI/RO3ZNcZdwCdaOTACYs=";
    };
  };

  # libDF has ![feature(get_mut_unchecked)]
  RUSTC_BOOTSTRAP = 1;

  buildAndTestSubdir = "ladspa";

  postInstall = ''
    mkdir $out/lib/ladspa
    mv $out/lib/libdeep_filter_ladspa.so $out/lib/ladspa/libdeep_filter_ladspa.so
  '';

  meta = {
    description = "Noise supression using deep filtering (LADSPA plugin)";
    homepage = "https://github.com/Rikorose/DeepFilterNet";
    license = with lib.licenses; [ mit asl20 ];
    maintainers = with lib.maintainers; [ ralismark ];
    platforms = lib.platforms.all;
  };
}
