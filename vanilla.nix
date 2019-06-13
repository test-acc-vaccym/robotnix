with (import <nixpkgs> {});
import ./default.nix rec {
  device = "marlin"; # Pixel XL
  rev = "android-9.0.0_r36";
  buildID = "PQ3A.190505.001.1";
  buildType = "user";
  manifest = "https://android.googlesource.com/platform/manifest"; # I get 100% cpu usage and no progress with this URL. Needs older curl version
  sha256 = "1fskk125zh0dy4f45z2fblik4sqjgc0w8amclw6a281kpyhji4zp";
  localManifests = [
    (writeTextFile { # TODO: Why can't I get rid of writeTextFile here?
      name = "grapheneos.xml";
      text = builtins.readFile ./roomservice/grapheneos.xml;
    })
    (writeTextFile {
      name = "fdroid.xml";
      text = (import ./roomservice/misc/fdroid.xml.nix {
        fdroidClientVersion = "1.5.1"; # FDROID_CLIENT_VERSION
        fdroidPrivExtVersion = "0.2.9"; # FDROID_PRIV_EXT_VERISON
      });
    })
  ];
  additionalProductPackages = [ "Updater" "F-DroidPrivilegedExtension" ];
  removedProductPackages = [ "webview" "Browser2" "Calendar2" "QuickSearchBox" ];
  #removedProductPackages = [ "Calendar2" "QuickSearchBox" ];
  vendorImg = fetchurl {
    url = "https://dl.google.com/dl/android/aosp/marlin-pq3a.190505.001-factory-5dac573c.zip";
    sha256 = "0cd3zhvw9z8jjhrx43i9lhr0v7qff63vzw4wis5ir2mrxly5gb2x";
  };
  msmKernelRev = "021e5400cb88fe15bc0c007e5847a0ec78c1831e";
  verityx509 = ./keys/verity.x509.pem; # Only needed for marlin/sailfish
  enableWireguard = true; # My version doesn't use the roomservice stuff
  monochromeApk = fetchurl {
    url = "https://github.com/andi34/prebuilts_chromium/raw/master/MonochromePublic.apk";
    sha256 = "175cw8z06lx52204affpb4a9kmjrkqb0byhky817mb85cg1dh3dz";
  };
  releaseUrl = "http://30.0.0.222/android";
}