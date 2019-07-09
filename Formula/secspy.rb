# Homebrew Formula Template. Built by Makefile: `make fomula`
class Secspy < Formula
  desc "Command Line Interface for SecuritySpy (IP Camera NVR)"
  homepage "https://github.com/davidnewhall/secspy"
  url "https://github.com/davidnewhall/secspy/archive/v0.0.4.tar.gz"
  sha256 "e9c4130abf5d78b617ee6c5cce5462dd1805af0f950970334ab13e0d15ab2891"
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
      system "make", "install", "VERSION=#{version}", "ITERATION=47", "PREFIX=#{prefix}", "ETC=#{etc}"
    end
  end

  def caveats
    <<-EOS
    Good luck!
    EOS
  end

  test do
    assert_match "secspy v#{version}", shell_output("#{bin}/secspy -v 2>&1", 2)
  end
end
