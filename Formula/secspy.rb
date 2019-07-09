# Homebrew Formula Template. Built by Makefile: `make fomula`
class Secspy < Formula
  desc "Command Line Interface for SecuritySpy (IP Camera NVR)"
  homepage "https://github.com/davidnewhall/secspy"
  url "https://github.com/davidnewhall/secspy/archive/v0.0.3.tar.gz"
  sha256 "fa561973c53daa5dd6e4ed0050c5efd2cdd38096c26dcce6e0130a4f9edcc1e1"
  head "https://github.com/davidnewhall/secspy"

  depends_on "go" => :build
  depends_on "dep"

  def install
    ENV["GOPATH"] = buildpath

    bin_path = buildpath/"src/github.com/davidnewhall/secspy"
    # Copy all files from their current location (GOPATH root)
    # to $GOPATH/src/github.com/davidnewhall/secspy
    bin_path.install Dir["*"]
    cd bin_path do
      system "dep", "ensure", "--vendor-only"
      system "make", "install", "VERSION=#{version}", "ITERATION=45", "PREFIX=#{prefix}", "ETC=#{etc}", "BINARY=#{name}"
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
