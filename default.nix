{
  pname,
  version,
  lib,
  stdenvNoCC,
  bited-utils,
  nerd ? false,
  release ? false,
}:

stdenvNoCC.mkDerivation {
  inherit pname version;
  src = ./.;

  buildPhase = ''
    runHook preBuild
    rm -rf out
    ${bited-utils.bited-build}/bin/bited-build src/${pname}.bdf out \
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
