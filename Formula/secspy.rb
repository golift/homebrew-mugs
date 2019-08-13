# Homebrew Formula Template. Built by Makefile: `make fomula`
# This is part of Application Builder.
# https://github.com/golift/application-builder
# This file is used when FORMULA is NOT set to 'service'.
class Secspy < Formula
  desc "Command Line Interface for SecuritySpy (IP Camera NVR)"
  homepage "https://github.com/davidnewhall/secspy"
  url "https://golift.io/secspy/archive/v0.0.21.tar.gz"
  sha256 "ff40a8a71f6f3952a8d6b8408b5464c0c71f31eaa8d708180aeaf39092bba44c"
  head "https://github.com/davidnewhall/secspy"

  depends_on "go" => :build
  depends_on "dep"

  def install
    ENV["GOPATH"] = buildpath

    bin_path = buildpath/"src/github.com/davidnewhall/secspy"
    # Copy all files from their current location (GOPATH root)
    # to $GOPATH/src/github.com/davidnewhall/secspy
    bin_path.install Dir["*",".??*"]
    cd bin_path do
      system "dep", "ensure", "--vendor-only"
      system "make", "install", "VERSION=#{version}", "ITERATION=81", "PREFIX=#{prefix}", "ETC=#{etc}"
    end
  end

  test do
    assert_match "#{name} v#{version}", shell_output("#{bin}/#{name} -v 2>&1", 2)
  end
end
