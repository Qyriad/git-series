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

    __structuredAttrs = true;

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

  cargoArtifacts = mk craneLib.buildDepsOnly { };

in mk craneLib.buildPackage {
  inherit cargoArtifacts;

  passthru.clippy = mk craneLib.cargoClippy {
    inherit cargoArtifacts;
  };

  meta.mainProgram = "git-series";
}
