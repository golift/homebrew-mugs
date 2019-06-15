# Homebrew Formula, still under development - June 2019
require "language/go"

class UnifiPoller < Formula
  version "1.3.1"
  sha256 ""
  url "https://github.com/davidnewhall/unifi-poller/archive/v#{version}.tar.gz"
  head "https://github.com/davidnewhall/unifi-poller"
  desc "This daemon polls a Unifi controller at a short interval and stores the collected measurements in an Influx Database."
  homepage "https://github.com/davidnewhall/unifi-poller"

  depends_on "go" => :build
  depends_on "dep"

  def install
    ENV["GOPATH"] = buildpath

    bin_path = buildpath/"src/github.com/davidnewhall/unifi-poller"
    # Copy all files from their current location (GOPATH root)
    # to $GOPATH/src/github.com/davidnewhall/unifi-poller
    bin_path.install Dir["*"]
    cd bin_path do
      system "dep", "ensure"
      system "make", "install", "VERSION=#{version}", "PREFIX=#{prefix}", "ETC=#{etc}"
      # If this fails, the user gets a nice big warning about write permissions on their
      # [/usr/local/]var/log folder. The alternative could be letting the app silently
      # fail to start when it cannot write logs. This is better. Fix perms; reinstall.
      system "mkdir", "-p", "#{var}/log/unifi-poller"
    end
  end
  def caveats
    s = <<-EOS
  This application will not work until the config file has authentication
  information for a Unifi Controller and an Influx Database. Edit the config
  file at #{etc}/unifi-poller/up.conf then start the application with
  brew services start unifi-poller ~ log file: #{var}/log/unifi-poller/log
  The manual explains the config file options: man unifi-poller
    EOS
  end

  def plist; <<-EOS
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
           <string>#{var}/log/unifi-poller/log</string>
           <key>StandardOutPath</key>
           <string>#{var}/log/unifi-poller/log</string>
       </dict>
   </plist>
   EOS
  end

  test do
    assert_match "unifi-poller v#{version}", shell_output("#{bin}/unifi-poller -v 2>&1", 2)
  end
end
