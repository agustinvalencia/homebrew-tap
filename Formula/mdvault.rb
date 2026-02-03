class Mdvault < Formula
  desc "CLI tool for managing markdown vaults with structured notes and validation"
  homepage "https://github.com/agustinvalencia/mdvault"
  version "0.3.0"
  license "MIT"

  on_macos do
    on_intel do
      url "https://github.com/agustinvalencia/mdvault/releases/download/v0.3.0/mdv-0.3.0-x86_64-apple-darwin.tar.gz"
      sha256 "dde3ca22838821776d95a412449a02b30c67dbc299ef88043a9504a0a580a28e"
    end
    on_arm do
      url "https://github.com/agustinvalencia/mdvault/releases/download/v0.3.0/mdv-0.3.0-aarch64-apple-darwin.tar.gz"
      sha256 "7614387c515b199992aed8c0ded11b44661baf9f7e5d6709ed35485e051393a0"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/agustinvalencia/mdvault/releases/download/v0.3.0/mdv-0.3.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "bcecbdd56b6c25bae99f7f33d5185cce40b2f40dfbe04fb780eb2a71e3144554"
    end
    on_arm do
      url "https://github.com/agustinvalencia/mdvault/releases/download/v0.3.0/mdv-0.3.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "cf42bad1d22c5a6f425ba057c685046387ab8f0b5ec56111cc9e08e512f70ab0"
    end
  end

  def install
    bin.install "mdv"
  end

  test do
    system "#{bin}/mdv", "--version"
  end
end
