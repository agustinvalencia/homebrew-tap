class Mdvault < Formula
  desc "CLI tool for managing markdown vaults with structured notes and validation"
  homepage "https://github.com/agustinvalencia/mdvault"
  version "0.1.1"
  license "MIT"

  on_macos do
    on_intel do
      url "https://github.com/agustinvalencia/mdvault/releases/download/v0.1.1/mdv-0.1.1-x86_64-apple-darwin.tar.gz"
      sha256 "2dd38b83d91c75ab62232cce3916c271a904747f45b291ceaa2700bfddf71bf4"
    end
    on_arm do
      url "https://github.com/agustinvalencia/mdvault/releases/download/v0.1.1/mdv-0.1.1-aarch64-apple-darwin.tar.gz"
      sha256 "bdd003bc9367defc5bd21d18a99856d281d524839538bfe61f1639c891311e59"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/agustinvalencia/mdvault/releases/download/v0.1.1/mdv-0.1.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "5633d3851828f75d1c8bca33006924a30be5630133fc362ce22cd598c125d6d4"
    end
    on_arm do
      url "https://github.com/agustinvalencia/mdvault/releases/download/v0.1.1/mdv-0.1.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "b3fb94c9a8ae874d1ca0632e631feef471aec7afb87e5463a35d5a0bec982f75"
    end
  end

  def install
    bin.install "mdv"
  end

  test do
    system "#{bin}/mdv", "--version"
  end
end
