class Mdvault < Formula
  desc "CLI tool for managing markdown vaults with structured notes and validation"
  homepage "https://github.com/agustinvalencia/mdvault"
  version "0.2.5"
  license "MIT"

  on_macos do
    on_intel do
      url "https://github.com/agustinvalencia/mdvault/releases/download/v0.2.5/mdv-0.2.5-x86_64-apple-darwin.tar.gz"
      sha256 "623d85369627685c7fb53999e117398575a10e715a412dfe0f09e1d91a2d9a28"
    end
    on_arm do
      url "https://github.com/agustinvalencia/mdvault/releases/download/v0.2.5/mdv-0.2.5-aarch64-apple-darwin.tar.gz"
      sha256 "0361c00e2406b7d3bc0cb399cacb3b60e54c26c5d20513157ae69a37d6feb6d0"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/agustinvalencia/mdvault/releases/download/v0.2.5/mdv-0.2.5-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "104c31f09f897dc1ac2eb7a9fef9cbf0b811c93458d52bfc5791b82824fcab56"
    end
    on_arm do
      url "https://github.com/agustinvalencia/mdvault/releases/download/v0.2.5/mdv-0.2.5-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "1313935010d74d7adb2d3acb1624c9e1ef0fd28a976ffc6ea85adafcd01a9f54"
    end
  end

  def install
    bin.install "mdv"
  end

  test do
    system "#{bin}/mdv", "--version"
  end
end
