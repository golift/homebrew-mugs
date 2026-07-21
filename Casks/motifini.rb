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

  postflight do
    example = Dir["#{staged_path}/**/motifini.conf.example"].first
    odie "motifini.conf.example missing from cask archive" unless example

    conf_dir = HOMEBREW_PREFIX/"etc"
    conf_dir.mkpath
    FileUtils.cp example, conf_dir/"motifini.conf.example"
    FileUtils.cp example, conf_dir/"motifini.conf" unless (conf_dir/"motifini.conf").exist?
  end

  caveats <<~EOS
    Config: #{HOMEBREW_PREFIX}/etc/motifini.conf (example copied on install).
    Run: motifini --config=#{HOMEBREW_PREFIX}/etc/motifini.conf
    State/log paths in the example default to /opt/homebrew/var/... - adjust if brew --prefix differs.
  EOS
end
