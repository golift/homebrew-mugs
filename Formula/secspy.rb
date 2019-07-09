# Homebrew Formula Template. Built by Makefile: `make fomula`
class Secspy < Formula
  desc "Command Line Interface for SecuritySpy (IP Camera NVR)"
  homepage "https://github.com/davidnewhall/secspy"
  url "https://github.com/davidnewhall/secspy/archive/v0.0.2.tar.gz"
  sha256 "c62ca4dc7c21fef3d43b929f3ec6374d95cf0a0d17d99fe53cc63e8daa2d6aba"
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
      system "make", "install", "VERSION=#{version}", "ITERATION=44", "PREFIX=#{prefix}", "ETC=#{etc}"
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
