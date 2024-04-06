{
  lib,
  stdenv,
  craneLib,
  darwin,
  iconv,
  pkg-config,
  openssl,
}: let
  mk = f: args: f (args // {
    src = craneLib.cleanCargoSource ./.;
    strictDeps = true;
    inherit stdenv;

    nativeBuildInputs = [
      pkg-config
    ];

    buildInputs = [
      openssl
    ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
      iconv
      darwin.apple_sdk.frameworks.Security
    ];
  });

  deps = mk craneLib.buildDepsOnly { };
in mk craneLib.buildPackage {
  cargoArtifacts = deps;

  passthru.clippy = mk craneLib.cargoClippy {
    cargoArtifacts = deps;
  };

  meta.mainProgram = "git-series";
}
