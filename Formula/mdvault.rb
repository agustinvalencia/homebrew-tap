class Mdvault < Formula
  desc "CLI tool for managing markdown vaults with structured notes and validation"
  homepage "https://github.com/agustinvalencia/mdvault"
  version "0.6.0"
  license "MIT"

  on_macos do
    on_intel do
      url "https://github.com/agustinvalencia/mdvault/releases/download/v0.6.0/mdv-0.6.0-x86_64-apple-darwin.tar.gz"
      sha256 "ed092a7d45cb4e348fa450e6394f95405c4d8a821727ab6b93ecc34d7dafb65f"
    end
    on_arm do
      url "https://github.com/agustinvalencia/mdvault/releases/download/v0.6.0/mdv-0.6.0-aarch64-apple-darwin.tar.gz"
      sha256 "0f501a8ea0000ac0ce2b2c1cb3bc9a2e01a211f25f99b33a69afeaecd7f0117d"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/agustinvalencia/mdvault/releases/download/v0.6.0/mdv-0.6.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "00d8a043d8b32476feb941cdfbcca6d1f935b6957444858ac7f0e2ddd5100ff5"
    end
    on_arm do
      url "https://github.com/agustinvalencia/mdvault/releases/download/v0.6.0/mdv-0.6.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "45050bcbdb9eb843e3be43bccd7c9ef3ef469b38f5ae4d92c8d74e0ca90b48cf"
    end
  end

  def install
    bin.install "mdv"
  end

  test do
    system "#{bin}/mdv", "--version"
  end
end
