{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
  bun,
  nodejs,
}:

rustPlatform.buildRustPackage rec {
  pname = "PostArchiverViewer";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "xiao-e-yun";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-LSKkByYMZHWYjSWefQG5XRg4gH3ejzOqiTH7DHHLDqI=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-Wl2dc8x6hf7IBs3JhlRNR6c0HjzCK8xHyGfH4pQ7Mkc=";

  RUSTC_BOOTSTRAP = 1;
  nativeBuildInputs = [
    pkg-config
    bun
    nodejs
  ];
  buildInputs = [
    openssl
  ];

  preBuild = ''
    export HOME=$(mktemp -d)
    cd frontend
    bun install --frozen-lockfile
    bun run build
    cd ..
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/post-archiver-viewer -h > /dev/null
  '';

  meta = with lib; {
    homepage = "https://github.com/xiao-e-yun/PostArchiverViewer";
    license = licenses.bsd3;
    maintainers = with maintainers; [ AyaseFile ];
    mainProgram = "post-archiver-viewer";
  };
}
