# Homebrew Formula Template. Built by Makefile: `make fomula`
class UnifiPoller < Formula
  desc "Polls a UniFi controller and stores metrics in InfluxDB"
  homepage "https://github.com/davidnewhall/unifi-poller"
  url "https://github.com/davidnewhall/unifi-poller/archive/v1.4.1.tar.gz"
  sha256 "bdcb0415efbe05bc921b6f6c21f871b82b6e4dcb34be78937176082746093e71"
  head "https://github.com/davidnewhall/unifi-poller"

  depends_on "go" => :build
  depends_on "dep"

  def install
    ENV["GOPATH"] = buildpath

    bin_path = buildpath/"src/github.com/davidnewhall/unifi-poller"
    # Copy all files from their current location (GOPATH root)
    # to $GOPATH/src/github.com/davidnewhall/unifi-poller
    bin_path.install Dir["*"]
    cd bin_path do
      system "dep", "ensure", "-vendor-only"
      system "make", "install", "VERSION=#{version}", "PREFIX=#{prefix}", "ETC=#{etc}"
      # If this fails, the user gets a nice big warning about write permissions on their
      # #{var}/log folder. The alternative could be letting the app silently fail
      # to start when it cannot write logs. This is better. Fix perms; reinstall.
      touch("#{var}/log/unifi-poller.log")
    end
  end

  def caveats
    <<-EOS
  This application will not work until the config file has authentication
  information for a UniFi Controller and an Influx Database. Edit the config
  file at #{etc}/unifi-poller/up.conf then start the application with
  brew services start unifi-poller ~ log file: #{var}/log/unifi-poller.log
  The manual explains the config file options: man unifi-poller
    EOS
  end

  plist_options :startup => true

  def plist
    <<-EOS
  <?xml version="1.0" encoding="UTF-8"?>
  <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
  <plist version="1.0">
     <dict>
         <key>Label</key>
         <string>#{plist_name}</string>
         <key>ProgramArguments</key>
         <array>
             <string>#{bin}/unifi-poller</string>
             <string>-c</string>
             <string>#{etc}/unifi-poller/up.conf</string>
         </array>
         <key>RunAtLoad</key>
         <true/>
         <key>KeepAlive</key>
         <true/>
         <key>StandardErrorPath</key>
         <string>#{var}/log/unifi-poller.log</string>
         <key>StandardOutPath</key>
         <string>#{var}/log/unifi-poller.log</string>
     </dict>
  </plist>
    EOS
  end

  test do
    assert_match "unifi-poller v#{version}", shell_output("#{bin}/unifi-poller -v 2>&1", 2)
  end
end
