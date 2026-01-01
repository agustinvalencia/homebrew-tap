class Mdvault < Formula
  desc "CLI tool for managing markdown vaults with structured notes and validation"
  homepage "https://github.com/agustinvalencia/mdvault"
  version "0.1.0"
  license "MIT"

  on_macos do
    on_intel do
      url "https://github.com/agustinvalencia/mdvault/releases/download/v0.1.0/mdv-0.1.0-x86_64-apple-darwin.tar.gz"
      sha256 "f1dae287e6c7189b5e3cf379e80f77a68ee6c6a6aa3f2db3209870c3239ef698"
    end
    on_arm do
      url "https://github.com/agustinvalencia/mdvault/releases/download/v0.1.0/mdv-0.1.0-aarch64-apple-darwin.tar.gz"
      sha256 "d10825178a835ce9f5d701d65f633202e3b4dc393ce2d81795e867c578ac0dc5"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/agustinvalencia/mdvault/releases/download/v0.1.0/mdv-0.1.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "68ea4366e292bf7b67b6e98050162715867f4feefc55282ec838283064e06485"
    end
    on_arm do
      url "https://github.com/agustinvalencia/mdvault/releases/download/v0.1.0/mdv-0.1.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "40492deca44c76795ec81a31f20ae33c7b07f6cd832ad19111dff206d2823f60"
    end
  end

  def install
    bin.install "mdv"
  end

  test do
    system "#{bin}/mdv", "--version"
  end
end
