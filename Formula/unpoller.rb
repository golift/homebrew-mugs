# typed: false
# frozen_string_literal: true

# This file was generated by GoReleaser. DO NOT EDIT.
class Unpoller < Formula
  desc "Polls a UniFi controller, exports metrics to InfluxDB, Prometheus and Datadog"
  homepage "https://unpoller.com/"
  version "2.13.1"
  license "MIT"

  on_macos do
    url "https://github.com/unpoller/unpoller/releases/download/v2.13.1/unpoller_2.13.1_darwin_all.tar.gz"
    sha256 "77eb57f62cb4c7593bd35f6571c1a1943e29dadfe8525b5a2362781e1b0af826"

    def install
      bin.install "unpoller"
      etc.mkdir "unpoller"
      etc.install "examples/up.conf" => "unpoller/up.conf.example"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      if Hardware::CPU.is_64_bit?
        url "https://github.com/unpoller/unpoller/releases/download/v2.13.1/unpoller_2.13.1_linux_amd64.tar.gz"
        sha256 "a87fe41ff7d49fd9fdc85aa047c2120d1507612030e77724c160a5064ed5bb54"

        def install
          bin.install "unpoller"
          etc.mkdir "unpoller"
          etc.install "examples/up.conf" => "unpoller/up.conf.example"
        end
      end
    end
    if Hardware::CPU.arm?
      if !Hardware::CPU.is_64_bit?
        url "https://github.com/unpoller/unpoller/releases/download/v2.13.1/unpoller_2.13.1_linux_armv6.tar.gz"
        sha256 "00b10a4f6a45fc027a1b0aa51faca5978c8f407dd7e1eb2e21565a00dfc53d48"

        def install
          bin.install "unpoller"
          etc.mkdir "unpoller"
          etc.install "examples/up.conf" => "unpoller/up.conf.example"
        end
      end
    end
    if Hardware::CPU.arm?
      if Hardware::CPU.is_64_bit?
        url "https://github.com/unpoller/unpoller/releases/download/v2.13.1/unpoller_2.13.1_linux_arm64.tar.gz"
        sha256 "3a4b14f1b5080fff6405ef318a8b1c49fa882b51a1b28729a24186daea703d3f"

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
