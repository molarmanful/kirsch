{
  pname,
  version,
  cfg ? "",
  nerd ? false,
  release ? false,

  bited-build,

  lib,
  stdenvNoCC,
  zip,
  ...
}:

stdenvNoCC.mkDerivation {
  inherit pname version;
  src = ./.;

  buildPhase = ''
    runHook preBuild
    rm -rf out
    ${bited-build}/bin/bited-build ${cfg} \
      ${lib.optionalString nerd "--nerd"}
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/fonts
    cp -r out/. $out/share/fonts
    ${lib.optionalString release ''
      ${zip}/bin/zip -r $out/share/fonts/ANAKRON_${version}.zip $out/share/fonts
    ''}
    runHook postInstall
  '';
}
