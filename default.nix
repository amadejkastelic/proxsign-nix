{
  appimageTools,
  fetchurl,
  lib,
}:
appimageTools.wrapType2 rec {
  pname = "proxsign";
  version = "2.2.13.38";

  src = fetchurl {
    url = "https://public.setcce.si/proxsign/update/linux/SETCCE_proXSign-${version}-x86_64.AppImage";
    hash = "sha256-Ixe0XjErci2ID4YUx/zr4pf1XTi3M2n9E/IIh2DPYB8=";
  };

  extraPkgs = pkgs: [ pkgs.libudev-zero ];

  meta = {
    description = "SETCCE proXSign - digital signing component for Slovenian national infrastructure";
    homepage = "https://www.setcce.si/products/proxsign";
    license = lib.licenses.unfree;
    maintainers = [ ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "proxsign";
  };
}
