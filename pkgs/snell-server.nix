{
  lib,
  stdenv,
  fetchzip,
  buildFHSEnv,
}:

let
  pname = "snell-server";
  version = "5.0.0";

  platformMap = {
    "x86_64-linux" = "linux-amd64";
    "i686-linux" = "linux-i386";
    "aarch64-linux" = "linux-aarch64";
    "armv7l-linux" = "linux-armv7l";
  };

  system = stdenv.hostPlatform.system;

  platform = platformMap.${system} or (throw "Unsupported platform: ${system}");

  url = "https://dl.nssurge.com/snell/snell-server-v${version}-${platform}.zip";

  sha256s = {
    "x86_64-linux" = "";
    "i686-linux" = "";
    "aarch64-linux" = "sha256-imp36CgZGQeD4eWf+kPep55sM42lHQvwDobfVV9ija0=";
    "armv7l-linux" = "";
  };

  sha256 = sha256s.${system};

  src = fetchzip {
    inherit url sha256;
  };

in
buildFHSEnv {
  inherit pname version;

  runScript = "${src}/${pname}";

  meta = with lib; {
    description = "Snell is a lean encrypted proxy protocol developed by Surge team";
    homepage = "https://kb.nssurge.com/surge-knowledge-base/release-notes/snell";
    license = licenses.unfreeRedistributable;
    sourceProvenance = [ sourceTypes.binaryNativeCode ];
    platforms = builtins.attrNames platformMap;
    mainProgram = pname;
  };
}
