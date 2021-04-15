# Homebrew Formula Template. Built by Makefile: `make fomula`
# This is part of Application Builder.
# https://github.com/golift/application-builder
# This file is used when FORMULA is NOT set to 'service'.
class Secspy < Formula
  desc "Command Line Interface for SecuritySpy (IP Camera NVR)"
  homepage "{{URL}}"
  url "https://codeload.github.com//davidnewhall/secspy/tar.gz/v0.0.22"
  sha256 "fa2c3e297cb38c25e51895cd058be7d5e98b73941f47ddf9c7952add12925e45"
  head "{{URL}}"

  depends_on "go" => :build
  depends_on "upx" => :build

  def install
    bin_path = buildpath/"#{name}"
    # Copy all files from their current location to buildpath/#{name}
    bin_path.install Dir["*",".??*"]
    cd bin_path do
      system "make", "install", "VERSION=#{version}", "ITERATION=88", "PREFIX=#{prefix}", "ETC=#{etc}"
    end
  end

  test do
    assert_match "#{name} v#{version}", shell_output("#{bin}/#{name} -v 2>&1", 2)
  end
end
