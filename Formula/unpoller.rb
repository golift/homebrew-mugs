# typed: false
# frozen_string_literal: true

# This file was generated by GoReleaser. DO NOT EDIT.
class Unpoller < Formula
  desc "Polls a UniFi controller, exports metrics to InfluxDB, Prometheus and Datadog"
  homepage "https://unpoller.com/"
  version "2.14.1"
  license "MIT"

  on_macos do
    url "https://github.com/unpoller/unpoller/releases/download/v2.14.1/unpoller_2.14.1_darwin_all.tar.gz"
    sha256 "bd46de0bed6d4c300ab00852f0a21e357721abb163eaf7610fb7820a5127db87"

    def install
      bin.install "unpoller"
      etc.mkdir "unpoller"
      etc.install "examples/up.conf" => "unpoller/up.conf.example"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      if Hardware::CPU.is_64_bit?
        url "https://github.com/unpoller/unpoller/releases/download/v2.14.1/unpoller_2.14.1_linux_amd64.tar.gz"
        sha256 "6845d0aa6b3d5ea7682ec8e00fd14fe02d5f455e9fb5c601216b263612e17231"

        def install
          bin.install "unpoller"
          etc.mkdir "unpoller"
          etc.install "examples/up.conf" => "unpoller/up.conf.example"
        end
      end
    end
    if Hardware::CPU.arm?
      if !Hardware::CPU.is_64_bit?
        url "https://github.com/unpoller/unpoller/releases/download/v2.14.1/unpoller_2.14.1_linux_armv6.tar.gz"
        sha256 "77f4aef0d5a9c59bbadcab69d4ff81167ca405ea46a08480d950b6e0c9c2cdca"

        def install
          bin.install "unpoller"
          etc.mkdir "unpoller"
          etc.install "examples/up.conf" => "unpoller/up.conf.example"
        end
      end
    end
    if Hardware::CPU.arm?
      if Hardware::CPU.is_64_bit?
        url "https://github.com/unpoller/unpoller/releases/download/v2.14.1/unpoller_2.14.1_linux_arm64.tar.gz"
        sha256 "dbdf3fc5947c0c9b22ff1077f544973398d8f3d4916d8655bd6fb2e65ae9bc18"

        def install
          bin.install "unpoller"
          etc.mkdir "unpoller"
          etc.install "examples/up.conf" => "unpoller/up.conf.example"
        end
      end
    end
  end

  conflicts_with "unifi-poller"

  def post_install
    etc.install "examples/up.conf" => "unpoller/up.conf"
  end

  def caveats
    <<~EOS
      Edit the config file at #{etc}/unpoller/up.conf then start unpoller with brew services start unpoller ~ log file: #{var}/log/unpoller.log The manual explains the config file options: man unpoller
    EOS
  end

  service do
    run [opt_bin/"unpoller", "--config", etc/"unpoller/up.conf"]
    keep_alive true
    log_path var/"log/unpoller.log"
    error_log_path var/"log/unpoller.log"
  end

  test do
    assert_match "unpoller v#{version}", shell_output("#{bin}/unpoller -v 2>&1", 2)
  end
end
