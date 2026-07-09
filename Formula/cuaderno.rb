class Cuaderno < Formula
  desc "Markdown vault manager for the Research Logbook Method (CLI + MCP server)"
  homepage "https://github.com/agustinvalencia/cuaderno"
  version "0.19.0"
  license "MPL-2.0"

  on_macos do
    on_arm do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.19.0/cuaderno-0.19.0-aarch64-apple-darwin.tar.gz"
      sha256 "edb11bea63c9dde0396d780f9471308767ee73e1239a24d4a6e98716ce22ea94"
    end
    on_intel do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.19.0/cuaderno-0.19.0-x86_64-apple-darwin.tar.gz"
      sha256 "09811dda9a09e45fc9bcbb97a1d6e0af9a1380300e0c9d7805cbd43901c02fb0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.19.0/cuaderno-0.19.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "82da909d25920d9f0e19d337e73d9634841f37f72cd9da83c241f929dfb4afad"
    end
    on_intel do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.19.0/cuaderno-0.19.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "5a6477bef745e41ad384ec6fccd15bd96590df6daa4beced0e47b627d8161ffb"
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
