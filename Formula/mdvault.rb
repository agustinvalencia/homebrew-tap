class Mdvault < Formula
  desc "CLI tool for managing markdown vaults with structured notes and validation"
  homepage "https://github.com/agustinvalencia/mdvault"
  version "0.4.4"
  license "MIT"

  on_macos do
    on_intel do
      url "https://github.com/agustinvalencia/mdvault/releases/download/v0.4.4/mdv-0.4.4-x86_64-apple-darwin.tar.gz"
      sha256 "609df443e455ebf01feab07f6eee855047737882ff660f015633bc039258221f"
    end
    on_arm do
      url "https://github.com/agustinvalencia/mdvault/releases/download/v0.4.4/mdv-0.4.4-aarch64-apple-darwin.tar.gz"
      sha256 "cf248fdf55e6f418642161705a2a87707e49c49ae1891669ac4ea546bc041fa8"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/agustinvalencia/mdvault/releases/download/v0.4.4/mdv-0.4.4-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "d1f883a347a0cfc7c1cf4d00011d3518c597b240089b3f3cb0ef3d55bd912f5e"
    end
    on_arm do
      url "https://github.com/agustinvalencia/mdvault/releases/download/v0.4.4/mdv-0.4.4-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "ee34f617de6e3b92f26d85452edb1a91895b04e21b6caad6fff9a7ecd93b8cba"
    end
  end

  def install
    bin.install "mdv"
  end

  test do
    system "#{bin}/mdv", "--version"
  end
end
