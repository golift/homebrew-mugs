# Homebrew Formula Template. Built by Makefile: `make fomula`
1141# This is part of Application Builder.
1142# https://github.com/golift/application-builder
1143# This file is used when FORMULA is set to 'service'.
1144class UnifiPoller < Formula
1145  desc "Polls a UniFi controller and stores metrics in InfluxDB"
1146  homepage "https://github.com/davidnewhall/unifi-poller"
1147  url "https://golift.io/unifi-poller/archive/v1.5.2.tar.gz"
1148  sha256 "affcbb0f43f59c504df41a940733c32d3dd6e985ad7133c4b5d401eae371afe5"
1149  head "https://github.com/davidnewhall/unifi-poller"
1150
1151  depends_on "go" => :build
1152  depends_on "dep"
1153
1154  def install
1155    ENV["GOPATH"] = buildpath
1156
1157    bin_path = buildpath/"src/github.com/davidnewhall/unifi-poller"
1158    # Copy all files from their current location (GOPATH root)
1159    # to $GOPATH/src/github.com/davidnewhall/unifi-poller
1160
1161    cd bin_path do
1162      system "dep", "ensure", "--vendor-only"
1163      system "make", "install", "VERSION=#{version}", "ITERATION=372", "PREFIX=#{prefix}", "ETC=#{etc}"
1164      # If this fails, the user gets a nice big warning about write permissions on their
1165      # #{var}/log folder. The alternative could be letting the app silently fail
1166      # to start when it cannot write logs. This is better. Fix perms; reinstall.
1167      touch("#{var}/log/#{name}.log")
1168    end
1169  end
1170
1171  def caveats
1172    <<-EOS
1173  Edit the config file at #{etc}/#{name}/up.conf then start #{name} with
1174  brew services start #{name} ~ log file: #{var}/log/#{name}.log
1175  The manual explains the config file options: man #{name}
1176    EOS
1177  end
1178
1179  plist_options :startup => false
1180
1181  def plist
1182    <<-EOS
1183  <?xml version="1.0" encoding="UTF-8"?>
1184  <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
1185  <plist version="1.0">
1186     <dict>
1187         <key>Label</key>
1188         <string>#{plist_name}</string>
1189         <key>ProgramArguments</key>
1190         <array>
1191             <string>#{bin}/#{name}</string>
1192             <string>--config</string>
1193             <string>#{etc}/#{name}/up.conf</string>
1194         </array>
1195         <key>RunAtLoad</key>
1196         <true/>
1197         <key>KeepAlive</key>
1198         <true/>
1199         <key>StandardErrorPath</key>
1200         <string>#{var}/log/#{name}.log</string>
1201         <key>StandardOutPath</key>
1202         <string>#{var}/log/#{name}.log</string>
1203     </dict>
1204  </plist>
1205    EOS
1206  end
1207
1208  test do
1209    assert_match "#{name} v#{version}", shell_output("#{bin}/#{name} -v 2>&1", 2)
1210  end
1211end
