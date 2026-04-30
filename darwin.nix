{
  fetchurl,
  stdenvNoCC,
  xar,
  cpio,
  gzip,
}:

stdenvNoCC.mkDerivation rec {
  pname = "proxsign";
  version = "2.2.13.300";

  src = fetchurl {
    url = "https://public.setcce.si/proxsign/update/mac/SETCCE_proXSign_${version}.pkg";
    hash = "sha256-pbm4kdfQEZygC1z8DTKfnGVy8ZDrnx2kU91tz+4m5Ls=";
  };

  nativeBuildInputs = [
    xar
    cpio
    gzip
  ];

  unpackPhase = ''
    xar -xf $src
  '';

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    gzip -dc Payload | cpio -i

    appDir="$out/Applications/SETCCE proXSign.app"
    mkdir -p "$appDir"
    mv Contents "$appDir/"

    mkdir -p "$out/bin"
    cat > "$out/bin/proxsign" <<WRAPPER
    #!${stdenvNoCC.shell}
    exec "$appDir/Contents/MacOS/proxsign" "\$@"
    WRAPPER
    chmod +x "$out/bin/proxsign"

    runHook postInstall
  '';

  meta = {
    description = "SETCCE proXSign - digital signing component for Slovenian national infrastructure";
    homepage = "https://www.setcce.si/products/proxsign";
    platforms = [
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    mainProgram = "proxsign";
  };
}
