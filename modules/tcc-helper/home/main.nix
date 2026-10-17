{
  config,
  lib,
  pkgs,
  ...
}:
let
  helper = pkgs.runCommandCC "tcc-helper" { nativeBuildInputs = [ pkgs.swift ]; } ''
    swiftc -o $out ${src}
  '';
  src = pkgs.writeText "tcc-helper.swift" ''
    import Foundation
    let child = Process()
    child.executableURL = URL(fileURLWithPath: CommandLine.arguments[1])
    child.arguments = Array(CommandLine.arguments.dropFirst(2))
    try? child.run()
    child.waitUntilExit()
    exit(child.terminationStatus)
  '';
  cfg = config.self.tcc-helper;
  q = lib.escapeShellArg;

  appName = lib.removeSuffix ".app" (baseNameOf cfg.app);
  executableName = baseNameOf cfg.executable;
  plist = "${cfg.app}/Contents/Info.plist";

  info = pkgs.writeText "tcc-helper-Info.plist" ''
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0"><dict>
      <key>CFBundleIdentifier</key>
      <string>${cfg.bundleIdentifier}</string>
      <key>CFBundleName</key>
      <string>${appName}</string>
      <key>CFBundleDisplayName</key>
      <string>${appName}</string>
      <key>CFBundleExecutable</key>
      <string>${executableName}</string>
      <key>CFBundlePackageType</key>
      <string>APPL</string>
      <key>CFBundleShortVersionString</key>
      <string>1.0</string>
      <key>CFBundleVersion</key>
      <string>1</string>
      <key>LSUIElement</key>
      <true/>
      <key>LSMinimumSystemVersion</key>
      <string>13.0</string>
    </dict></plist>
  '';

  cert = "TCC Helper Signing";
in
lib.mkIf (pkgs.stdenv.hostPlatform.isDarwin && cfg.permissions != [ ]) {
  self.tcc = lib.genAttrs cfg.permissions (_: [ cfg.app ]);

  home.activation.checkSigningCert = lib.hm.dag.entryBefore [ "checkFilesChanged" ] ''
    if ! /usr/bin/security find-certificate -c ${q cert} &>/dev/null; then
      /usr/bin/open -b com.apple.CertificateAssistant
      echo "Missing signing certificate"
      echo " • Create a certificate for yourself"
      echo " • Name:" ${q cert}
      echo " • Certificate Type: Code Signing"
      echo " • Override defaults and set a long validity period"
      exit 1
    fi
  '';

  home.activation.createTCCHelper =
    lib.hm.dag.entryBetween [ "ensureTCCPermissions" ] [ "writeBoundary" ]
      ''
        if ! [ -e ${q cfg.app}/Contents/_CodeSignature ]; then
          mkdir -p ${q (builtins.dirOf cfg.executable)}
          install -m 755 ${helper} ${q cfg.executable}
          install -m 644 ${info} ${q plist}
          /usr/bin/codesign --force --options runtime --sign ${q cert} --identifier ${q cfg.bundleIdentifier} ${q cfg.app}
          /usr/bin/codesign -d -r- ${q cfg.app}
          /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -f ${q cfg.app}
        fi
      '';
}
