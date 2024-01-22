# typed: false
# frozen_string_literal: true

# This file was generated by GoReleaser. DO NOT EDIT.
class Xt < Formula
  desc "eXtractor Tool - Recursively decompress archives"
  homepage "https://unpackerr.com/"
  version "0.0.1"
  license "MIT"

  on_macos do
    url "https://github.com/Unpackerr/xt/releases/download/v0.0.1/xt_0.0.1_darwin_all.tar.gz"
    sha256 "4370cc6e9b0d09a1f055a8dbc0f66474bdcddd531f38951b269e68c946b844ff"

    def install
      bin.install "xt"
    end
  end

  on_linux do
    if Hardware::CPU.arm? && !Hardware::CPU.is_64_bit?
      url "https://github.com/Unpackerr/xt/releases/download/v0.0.1/xt_0.0.1_linux_armv6.tar.gz"
      sha256 "748a838113c96d6f14952b07f06f088140e7ef430843ac40a3b1ef623582ce9d"

      def install
        bin.install "xt"
      end
    end
    if Hardware::CPU.intel?
      url "https://github.com/Unpackerr/xt/releases/download/v0.0.1/xt_0.0.1_linux_amd64.tar.gz"
      sha256 "f5f342172123fb14514adc9ea43ced456ec2d7451de1d3e2d798301d899d38b5"

      def install
        bin.install "xt"
      end
    end
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/Unpackerr/xt/releases/download/v0.0.1/xt_0.0.1_linux_arm64.tar.gz"
      sha256 "3d1745f7edf4ba220add3697100927dadbd80b94eb2f293db90b3974ce2cf272"

      def install
        bin.install "xt"
      end
    end
  end

  test do
    assert_match "xt v#{version}", shell_output("#{bin}/xt -v 2>&1", 2)
  end
end
