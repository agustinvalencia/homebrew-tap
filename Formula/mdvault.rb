class Mdvault < Formula
  desc "CLI tool for managing markdown vaults with structured notes and validation"
  homepage "https://github.com/agustinvalencia/mdvault"
  version "0.1.2"
  license "MIT"

  on_macos do
    on_intel do
      url "https://github.com/agustinvalencia/mdvault/releases/download/v0.1.2/mdv-0.1.2-x86_64-apple-darwin.tar.gz"
      sha256 "6cbf72956b77e70c7922831d4aa5c59cc19adf29a5c366fe39afe94b656df340"
    end
    on_arm do
      url "https://github.com/agustinvalencia/mdvault/releases/download/v0.1.2/mdv-0.1.2-aarch64-apple-darwin.tar.gz"
      sha256 "927a94b8c9a241393b575e7e0cb371b529bc5bd6a1fb05daab59d621796e2536"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/agustinvalencia/mdvault/releases/download/v0.1.2/mdv-0.1.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "43af67b9c19014c07939a7a0206781c989ef6c3c3825d36f899c0a913882d0a4"
    end
    on_arm do
      url "https://github.com/agustinvalencia/mdvault/releases/download/v0.1.2/mdv-0.1.2-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "c6d02793d065eebbc05abce14d2bdd3b1aa7098a59e632d1459c3ab24b1633af"
    end
  end

  def install
    bin.install "mdv"
  end

  test do
    system "#{bin}/mdv", "--version"
  end
end
