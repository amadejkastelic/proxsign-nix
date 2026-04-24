{
  appimageTools,
  fetchurl,
  makeDesktopItem,
}:
let
  pname = "proxsign";
  version = "2.2.13.38";

  src = fetchurl {
    url = "https://public.setcce.si/proxsign/update/linux/SETCCE_proXSign-${version}-x86_64.AppImage";
    hash = "sha256-Ixe0XjErci2ID4YUx/zr4pf1XTi3M2n9E/IIh2DPYB8=";
  };

  extracted = appimageTools.extract { inherit pname version src; };

  desktopItem = makeDesktopItem {
    name = "proxsign";
    exec = "proxsign";
    icon = "proXSign";
    desktopName = "SETCCE proXSign";
    genericName = "proXSign";
    comment = "SETCCE proXSign Component Suite for Linux";
    categories = [
      "System"
      "Security"
    ];
  };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraPkgs = pkgs: [ pkgs.libudev-zero ];

  extraInstallCommands = ''
    mkdir -p $out/share/applications $out/share/icons
    cp ${desktopItem}/share/applications/* $out/share/applications/
    ln -s ${extracted}/proXSign.svg $out/share/icons/proXSign.svg
  '';

  meta = {
    description = "SETCCE proXSign - digital signing component for Slovenian national infrastructure";
    homepage = "https://www.setcce.si/products/proxsign";
    platforms = [ "x86_64-linux" ];
    mainProgram = "proxsign";
  };
}
