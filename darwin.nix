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

  installPhase = ''
    mkdir -p $out/Applications

    pkg_dir=""
    for d in proXSign*.pkg; do
      if [ -d "$d" ]; then
        pkg_dir="$d"
        break
      fi
    done

    if [ -z "$pkg_dir" ]; then
      echo "Could not find proXSign package directory"
      exit 1
    fi

    cd "$pkg_dir"

    if [ -f Payload ]; then
      cat Payload | gzip -dc | cpio -i 2>/dev/null || true
    fi

    app=$(find . -name "*.app" -maxdepth 1 -type d | head -1)
    if [ -n "$app" ]; then
      cp -R "$app" $out/Applications/
    else
      echo "Could not find .app bundle"
      exit 1
    fi
  '';

  meta = {
    description = "SETCCE proXSign - digital signing component for Slovenian national infrastructure";
    homepage = "https://www.setcce.si/products/proxsign";
    platforms = [
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    mainProgram = "proXSign";
  };
}
