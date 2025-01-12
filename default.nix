{
  pname ? "kirsch",
  version,
  bdf,
  nerd ? false,
  release ? false,

  lib,
  stdenvNoCC,
  bited-build,
  ...
}:

stdenvNoCC.mkDerivation {
  inherit pname version;
  src = ./.;

  buildPhase = ''
    runHook preBuild
    rm -rf out
    ${bited-build}/bin/bited-build ${bdf} out \
      ${lib.optionalString nerd "--nerd"} \
      ${lib.optionalString release "--release"}
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/fonts
    cp -r out/. $out/share/fonts
    runHook postInstall
  '';
}
