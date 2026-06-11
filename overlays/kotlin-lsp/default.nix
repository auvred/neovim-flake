final: {
  stdenv,
  stdenvNoCC,
  fetchzip,
  makeWrapper,
  jdk25,
  autoPatchelfHook,
  ...
}: {
  kotlin-lsp = stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "kotlin-lsp";
  version = "262.7569.0";

  src = fetchzip {
    url = "https://download-cdn.jetbrains.com/kotlin-lsp/${finalAttrs.version}/kotlin-server-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-u2IcSjMCAukvcDEZdvfyT6hWJJ+e5O49/SAWbqlXJyo=";
  };

  nativeBuildInputs = [
    makeWrapper
    autoPatchelfHook
  ];

  buildInputs = [
    jdk25
    stdenv.cc.cc.lib
  ];

  autoPatchelfIgnoreMissingDeps = [
    "libc.musl-x86_64.so.1"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/kotlin-lsp
    cp -r bin build.txt kotlin-lsp.sh lib license modules plugins product-info.json $out/share/kotlin-lsp
    ln -s ${jdk25}/lib/openjdk $out/share/kotlin-lsp/jbr

    makeWrapper $out/share/kotlin-lsp/bin/intellij-server $out/bin/kotlin-lsp

    runHook postInstall
  '';
});
}
