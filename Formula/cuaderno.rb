class Cuaderno < Formula
  desc "Markdown vault manager for the Research Logbook Method (CLI + MCP server)"
  homepage "https://github.com/agustinvalencia/cuaderno"
  version "0.1.0"
  license "MPL-2.0"

  on_macos do
    on_arm do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.1.0/cuaderno-0.1.0-aarch64-apple-darwin.tar.gz"
      sha256 "f806b7e7a51852f12a5ff51199fa34a169422b8972595b7a13eeeed40d23b2c9"
    end
    on_intel do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.1.0/cuaderno-0.1.0-x86_64-apple-darwin.tar.gz"
      sha256 "c24de4a9da9f6f7fb1b735d6afbc6474787a88b2ab726ffcdd75f5ef49c26250"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.1.0/cuaderno-0.1.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "32b146e9bdf4a73920d38a8030ab4f0e579758db4eb1952ecdfd5dc30fd5cbb6"
    end
    on_intel do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.1.0/cuaderno-0.1.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "628673103f5a11bfa39eeda3a6a4eab1a8f6ba4d7ce9de7bceb83ae2105fe807"
    end
  end

  def install
    # Each archive expands into a `cuaderno-<version>-<target>/`
    # directory containing both binaries plus LICENSE and README.
    # Install the binaries; document files live in the cellar
    # alongside but don't need explicit placement.
    bin.install "cdno", "cdno-mcp"
  end

  test do
    # cdno-mcp has no flag parser today (it reads env vars and
    # serves stdio unconditionally), so `--version` / `--help`
    # would try to open a vault and exit non-zero. The protocol
    # surface is already exercised by the upstream e2e_stdio
    # integration tests; here we only need a smoke that the bin
    # exists and the cdno CLI launches.
    system "#{bin}/cdno", "--version"
    assert_path_exists bin/"cdno-mcp"
    assert_predicate bin/"cdno-mcp", :executable?
  end
end
