class Cuaderno < Formula
  desc "Markdown vault manager for the Research Logbook Method (CLI + MCP server)"
  homepage "https://github.com/agustinvalencia/cuaderno"
  version "0.20.1"
  license "MPL-2.0"

  on_macos do
    on_arm do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.20.1/cuaderno-0.20.1-aarch64-apple-darwin.tar.gz"
      sha256 "6b809fd3c1e66200d5a9a47e3d78a8b2ee1df0861376b5d11325e7d60f3d677f"
    end
    on_intel do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.20.1/cuaderno-0.20.1-x86_64-apple-darwin.tar.gz"
      sha256 "387f5ad7a475a1fb5b27f9e19f576ba08915216dc112226441d3e0a5b86b8a70"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.20.1/cuaderno-0.20.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "2e146741ef3da819b70fad3f324a1eec7326f2086c4d93cc106e72f20d7c43b7"
    end
    on_intel do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.20.1/cuaderno-0.20.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "47a5f83e84cb5c4d73dda1196be32610dbb879b26d2aa652874dc3f55134e210"
    end
  end

  def install
    # Each archive expands into a `cuaderno-<version>-<target>/`
    # directory containing both binaries plus LICENSE and README.
    # Install the binaries; document files live in the cellar
    # alongside but don't need explicit placement.
    bin.install "cdno", "cdno-mcp"

    # Generate and install shell completion scripts (bash, zsh, fish).
    # `cdno completions <shell>` emits clap_complete's dynamic-engine
    # registration shim, which hooks the binary back in on TAB for
    # vault-aware slug completion (--project, --portfolio,
    # --stewardship, --slug on project/question verbs). Without this
    # line the user would have to source the script by hand from
    # their rc file.
    generate_completions_from_executable(bin/"cdno", "completions")
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

    # Smoke the new completions surface: the zsh shim should be a
    # non-empty script with the compdef header. We don't try to
    # source it inside the brew test sandbox (no compinit machinery
    # available) — the upstream `crates/cdno-cli/tests/completions.rs`
    # suite covers the script content + runtime intercept end-to-end.
    assert_match "#compdef cdno", shell_output("#{bin}/cdno completions zsh")
  end
end
