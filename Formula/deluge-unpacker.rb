# macOS Homebrew Formula Template. Built by Makefile: `make fomula`
# This is part of Application Builder.
# https://github.com/golift/application-builder
class DelugeUnpacker < Formula
  desc "Extracts Deluge downloads so Radarr or Sonarr may import them."
  homepage "https://davidnewhall/deluge-unpacker/"
  url "https://golift.io/deluge-unpacker/archive/v0.6.1.tar.gz"
  sha256 "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"
  head "https://davidnewhall/deluge-unpacker/"

  depends_on "go" => :build

  def install
    bin_path = buildpath/"#{name}"
    # Copy all files from their current location to buildpath/#{name}
    bin_path.install Dir["*",".??*"]
    cd bin_path do
      system "make", "install", "VERSION=#{version}", "ITERATION=83", "PREFIX=#{prefix}", "ETC=#{etc}"
      # If this fails, the user gets a nice big warning about write permissions on their
      # #{var}/log folder. The alternative could be letting the app silently fail
      # to start when it cannot write logs. This is better. Fix perms; reinstall.
      touch("#{var}/log/#{name}.log")
    end
  end

  def caveats
    <<-EOS
  Edit the config file at #{etc}/#{name}/du.conf then start #{name} with
  brew services start #{name} ~ log file: #{var}/log/#{name}.log
  The manual explains the config file options: man #{name}
    EOS
  end

  plist_options :startup => false

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
             <string>#{bin}/#{name}</string>
             <string>--config</string>
             <string>#{etc}/#{name}/du.conf</string>
         </array>
         <key>RunAtLoad</key>
         <true/>
         <key>KeepAlive</key>
         <true/>
         <key>StandardErrorPath</key>
         <string>#{var}/log/#{name}.log</string>
         <key>StandardOutPath</key>
         <string>#{var}/log/#{name}.log</string>
     </dict>
  </plist>
    EOS
  end

  test do
    assert_match "#{name} v#{version}", shell_output("#{bin}/#{name} -v 2>&1", 2)
  end
end
