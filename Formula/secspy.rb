# Homebrew Formula Template. Built by Makefile: `make fomula`
class Secspy < Formula
  desc "Command Line Interface for SecuritySpy (IP Camera NVR)"
  homepage "https://github.com/davidnewhall/secspy"
  url "https://code.golift.io/secspy/tar.gz/v0.0.15"
  sha256 "95a0d9e49c8ee522691230b8f95e74777afd53994ded4b72f683207ddaf8a69f"
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
      system "make", "install", "VERSION=#{version}", "ITERATION=73", "PREFIX=#{prefix}", "ETC=#{etc}"
    end
  end

  test do
    assert_match "#{name} v#{version}", shell_output("#{bin}/#{name} -v 2>&1", 2)
  end
end
