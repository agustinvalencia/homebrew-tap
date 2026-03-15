class Mdvault < Formula
  desc "CLI tool for managing markdown vaults with structured notes and validation"
  homepage "https://github.com/agustinvalencia/mdvault"
  version "0.5.1"
  license "MIT"

  on_macos do
    on_intel do
      url "https://github.com/agustinvalencia/mdvault/releases/download/v0.5.1/mdv-0.5.1-x86_64-apple-darwin.tar.gz"
      sha256 "ceda381b6166e971ee364a376c7561da8777629f3116c1d437ec54729341c730"
    end
    on_arm do
      url "https://github.com/agustinvalencia/mdvault/releases/download/v0.5.1/mdv-0.5.1-aarch64-apple-darwin.tar.gz"
      sha256 "502d4961cf7cb78976e2b7487ee69991e1359945b5b2e775a9dd0b1509714580"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/agustinvalencia/mdvault/releases/download/v0.5.1/mdv-0.5.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "e46811d7263edaddd3c4a03d3d447f7913be72eb9f651fd61734881ce76e3642"
    end
    on_arm do
      url "https://github.com/agustinvalencia/mdvault/releases/download/v0.5.1/mdv-0.5.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "0858dc388be3602966ddc7b1d048c60615700e44107f755e9699b76d9e4e64fe"
    end
  end

  def install
    bin.install "mdv"
  end

  test do
    system "#{bin}/mdv", "--version"
  end
end
