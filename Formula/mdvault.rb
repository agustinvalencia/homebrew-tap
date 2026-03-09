class Mdvault < Formula
  desc "CLI tool for managing markdown vaults with structured notes and validation"
  homepage "https://github.com/agustinvalencia/mdvault"
  version "0.4.6"
  license "MIT"

  on_macos do
    on_intel do
      url "https://github.com/agustinvalencia/mdvault/releases/download/v0.4.6/mdv-0.4.6-x86_64-apple-darwin.tar.gz"
      sha256 "6e08d2542d0f35ab366d910664b57319ddd6c93a09dc39ce3912a7b6ae8c5eb3"
    end
    on_arm do
      url "https://github.com/agustinvalencia/mdvault/releases/download/v0.4.6/mdv-0.4.6-aarch64-apple-darwin.tar.gz"
      sha256 "39507fbb9a4d7d4c89fd7b94eca990e96dd7e7297ba4afa4042e9cb6567b36dc"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/agustinvalencia/mdvault/releases/download/v0.4.6/mdv-0.4.6-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "f706830a164c95d15552ba3b377efdf58d467974361acd747d3fec53f0cb4902"
    end
    on_arm do
      url "https://github.com/agustinvalencia/mdvault/releases/download/v0.4.6/mdv-0.4.6-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "a34f9c747b81348e05964eb92c22c965a8969dd437de27f0ee302eb6a0032fd5"
    end
  end

  def install
    bin.install "mdv"
  end

  test do
    system "#{bin}/mdv", "--version"
  end
end
