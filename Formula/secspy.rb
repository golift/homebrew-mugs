# Homebrew Formula Template. Built by Makefile: `make fomula`
class Secspy < Formula
  desc "Command Line Interface for SecuritySpy (IP Camera NVR)"
  homepage "https://github.com/davidnewhall/secspy"
  url "https://github.com/davidnewhall/secspy/archive/v0.0.8.tar.gz"
  sha256 "a12ad3e662f9d7ae924da912c89ca07e442179f0c881909f16ce1b76dce91501"
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
      system "make", "install", "VERSION=#{version}", "ITERATION=66", "PREFIX=#{prefix}", "ETC=#{etc}"
    end
  end

  test do
    assert_match "#{name} v#{version}", shell_output("#{bin}/#{name} -v 2>&1", 2)
  end
end
