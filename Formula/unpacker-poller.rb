# Homebrew Formula Template. Built by Makefile: `make fomula`
class UnpackerPoller < Formula
  desc "Extracts Deluge downloads so Radarr or Sonarr may import them."
  homepage "https://github.com/davidnewhall/unpacker-poller"
  url "https://github.com/davidnewhall/unpacker-poller/archive/v0.3.0.tar.gz"
  sha256 "395408a3dc9c3db2b5c200b8722a13a60898c861633b99e6e250186adffd1370"
  head "https://github.com/davidnewhall/unpacker-poller"

  depends_on "go" => :build
  depends_on "dep"

  def install
    ENV["GOPATH"] = buildpath

    bin_path = buildpath/"src/github.com/davidnewhall/unpacker-poller"
    # Copy all files from their current location (GOPATH root)
    # to $GOPATH/src/github.com/davidnewhall/unpacker-poller
    bin_path.install Dir["*"]
    cd bin_path do
      system "dep", "ensure", "-vendor-only"
      system "make", "install", "VERSION=#{version}", "PREFIX=#{prefix}", "ETC=#{etc}"
      # If this fails, the user gets a nice big warning about write permissions on their
      # #{var}/log folder. The alternative could be letting the app silently fail
      # to start when it cannot write logs. This is better. Fix perms; reinstall.
      touch("#{var}/log/unpacker-poller.log")
    end
  end

  def caveats
    <<-EOS
  Thanks for trying this app!
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
             <string>#{bin}/unpacker-poller</string>
             <string>-c</string>
             <string>#{etc}/unpacker-poller/up.conf</string>
         </array>
         <key>RunAtLoad</key>
         <true/>
         <key>KeepAlive</key>
         <true/>
         <key>StandardErrorPath</key>
         <string>#{var}/log/unpacker-poller.log</string>
         <key>StandardOutPath</key>
         <string>#{var}/log/unpacker-poller.log</string>
     </dict>
  </plist>
    EOS
  end

  test do
    assert_match "unpacker-poller v#{version}", shell_output("#{bin}/unpacker-poller -v 2>&1", 2)
  end
end
