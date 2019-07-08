class Secpy < Formula
  desc "Command Line Interface for SecuritySpy (IP Camera NVR)"
  homepage "https://github.com/davidnewhall/secspy"
  url "https://github.com/davidnewhall/secspy/archive/v0.0.1.tar.gz"
  sha256 "3d4d632baa2a6a23c1ed9ea66f6b3e948fec691591b1b30186031075f415df30"
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
      system "make", "install", "VERSION=#{version}", "PREFIX=#{prefix}", "ETC=#{etc}"
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
