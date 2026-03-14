class Mdvault < Formula
  desc "CLI tool for managing markdown vaults with structured notes and validation"
  homepage "https://github.com/agustinvalencia/mdvault"
  version "0.5.0"
  license "MIT"

  on_macos do
    on_intel do
      url "https://github.com/agustinvalencia/mdvault/releases/download/v0.5.0/mdv-0.5.0-x86_64-apple-darwin.tar.gz"
      sha256 "830cbc7bd9dc0916a881efbbfdce0ee1206a4cbbd586bc3d7eb800c489990a17"
    end
    on_arm do
      url "https://github.com/agustinvalencia/mdvault/releases/download/v0.5.0/mdv-0.5.0-aarch64-apple-darwin.tar.gz"
      sha256 "d7bcbcc56709385e71e398493b985a450f7bddb833f49d85e4b77482cdd9a092"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/agustinvalencia/mdvault/releases/download/v0.5.0/mdv-0.5.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "afd008078c8e4ee8e12352e68b478bb938263b2ace4fa44da82b45ebffb935a7"
    end
    on_arm do
      url "https://github.com/agustinvalencia/mdvault/releases/download/v0.5.0/mdv-0.5.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "e55bddcc52314be1b4894d2becf1c97df7164665c2b109188cc69fcbbfe5c9d2"
    end
  end

  def install
    bin.install "mdv"
  end

  test do
    system "#{bin}/mdv", "--version"
  end
end
