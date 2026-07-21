cask "motifini" do
  version "0.1.1"

  on_macos do
    sha256 "9d4948344d7294a067b72135766f650008675cbf0a10990a96770ba29f1fe5ef"
    url "https://github.com/davidnewhall/motifini/releases/download/v#{version}/motifini_#{version}_darwin_all.tar.gz"
    rename "motifini_#{version}_darwin_all/motifini", "motifini"
  end

  on_linux do
    on_intel do
      sha256 "01cb287c3f7db8270afa8e301be84d761e110c1172dad6c644708e32aad7b85a"
      url "https://github.com/davidnewhall/motifini/releases/download/v#{version}/motifini_#{version}_linux_amd64.tar.gz"
      rename "motifini_#{version}_linux_amd64/motifini", "motifini"
    end
    on_arm do
      sha256 "1dabeaa374a037598d644d8906b81cb235daee8ccd66941fc42453757a644a03"
      url "https://github.com/davidnewhall/motifini/releases/download/v#{version}/motifini_#{version}_linux_arm64.tar.gz"
      rename "motifini_#{version}_linux_arm64/motifini", "motifini"
    end
  end

  name "motifini"
  desc "SecuritySpy Telegram Bot - motion clips and camera alerts in Telegram"
  homepage "https://github.com/davidnewhall/motifini"

  livecheck do
    skip "Auto-generated on release."
  end

  binary "motifini"

  # Cask `service` installs ~/Library/Services (Automator), not LaunchAgents.
  # Install a LaunchAgent ourselves so the daemon can be started/stopped with launchctl.
  postflight do
    example = Dir["#{staged_path}/**/motifini.conf.example"].first
    odie "motifini.conf.example missing from cask archive" unless example

    conf_dir = HOMEBREW_PREFIX/"etc"
    conf_dir.mkpath
    FileUtils.cp example, conf_dir/"motifini.conf.example"
    FileUtils.cp example, conf_dir/"motifini.conf" unless (conf_dir/"motifini.conf").exist?

    (HOMEBREW_PREFIX/"var/log").mkpath

    label = "io.golift.motifini"
    agent = Pathname.new(Dir.home)/"Library/LaunchAgents/#{label}.plist"
    agent.dirname.mkpath

    binary = HOMEBREW_PREFIX/"bin/motifini"
    conf = conf_dir/"motifini.conf"
    log = HOMEBREW_PREFIX/"var/log/motifini.log"

    agent.write <<~XML
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{label}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{binary}</string>
          <string>--config</string>
          <string>#{conf}</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <true/>
        <key>WorkingDirectory</key>
        <string>#{HOMEBREW_PREFIX}</string>
        <key>StandardOutPath</key>
        <string>#{log}</string>
        <key>StandardErrorPath</key>
        <string>#{log}</string>
      </dict>
      </plist>
    XML

    # Do not bootstrap here — user should edit the config first.
  end

  uninstall_preflight do
    label = "io.golift.motifini"
    agent = Pathname.new(Dir.home)/"Library/LaunchAgents/#{label}.plist"
    system "/bin/launchctl", "bootout", "gui/#{Process.uid}", label
    agent.delete if agent.exist?
  end

  uninstall launchctl: "io.golift.motifini"

  caveats <<~EOS
    Config: #{HOMEBREW_PREFIX}/etc/motifini.conf (edit before starting).
    LaunchAgent installed (not started): ~/Library/LaunchAgents/io.golift.motifini.plist

    Start (loads at login, KeepAlive):
      launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/io.golift.motifini.plist
    Restart:
      launchctl kickstart -k gui/$(id -u)/io.golift.motifini
    Stop:
      launchctl bootout gui/$(id -u)/io.golift.motifini

    brew services does not manage casks — use launchctl above.
    State/log paths in the example default to /opt/homebrew/var/...; adjust if brew --prefix differs.
    Log file: #{HOMEBREW_PREFIX}/var/log/motifini.log
  EOS
end
