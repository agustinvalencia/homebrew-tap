class Mdvault < Formula
  desc "CLI tool for managing markdown vaults with structured notes and validation"
  homepage "https://github.com/agustinvalencia/mdvault"
  version "0.3.2"
  license "MIT"

  on_macos do
    on_intel do
      url "https://github.com/agustinvalencia/mdvault/releases/download/v0.3.2/mdv-0.3.2-x86_64-apple-darwin.tar.gz"
      sha256 "5fdde49cdf1ddb8fdfe1e5bec0efac08ae13ce6dbcecdbbd603a5a614a95acce"
    end
    on_arm do
      url "https://github.com/agustinvalencia/mdvault/releases/download/v0.3.2/mdv-0.3.2-aarch64-apple-darwin.tar.gz"
      sha256 "32e1fc85039e42e696cf2df9ff4db4321e0fd4275be73cbc6aca3c2d8a7387e3"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/agustinvalencia/mdvault/releases/download/v0.3.2/mdv-0.3.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "357d483abc8c83d1202d3f6d487220952a21335ab0445e668957a719f8499b77"
    end
    on_arm do
      url "https://github.com/agustinvalencia/mdvault/releases/download/v0.3.2/mdv-0.3.2-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "fe98a8dad7d28b0e889d200a9cab0f3f15bb3619b8d9dd0d4b4b1222056a581c"
    end
  end

  def install
    bin.install "mdv"
  end

  test do
    system "#{bin}/mdv", "--version"
  end
end
