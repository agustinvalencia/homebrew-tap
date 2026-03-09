class Mdvault < Formula
  desc "CLI tool for managing markdown vaults with structured notes and validation"
  homepage "https://github.com/agustinvalencia/mdvault"
  version "0.4.5"
  license "MIT"

  on_macos do
    on_intel do
      url "https://github.com/agustinvalencia/mdvault/releases/download/v0.4.5/mdv-0.4.5-x86_64-apple-darwin.tar.gz"
      sha256 "1c19d1a921274ac299f61df8444dd2b33f6c10434b06da93a3314ec4b82c45ff"
    end
    on_arm do
      url "https://github.com/agustinvalencia/mdvault/releases/download/v0.4.5/mdv-0.4.5-aarch64-apple-darwin.tar.gz"
      sha256 "eb7e79e4d2a5c91a2e56adfdb225b274b778f805b742693495dc38aede8b47d1"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/agustinvalencia/mdvault/releases/download/v0.4.5/mdv-0.4.5-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "d3e216b33a688e383e161f852afc322ca1fee74a675dc7e2a18b195a758316b9"
    end
    on_arm do
      url "https://github.com/agustinvalencia/mdvault/releases/download/v0.4.5/mdv-0.4.5-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "b76f56f8f8f654c85a3631446f0dea2fcece8018bf0d79af49a63d5d8f334caa"
    end
  end

  def install
    bin.install "mdv"
  end

  test do
    system "#{bin}/mdv", "--version"
  end
end
