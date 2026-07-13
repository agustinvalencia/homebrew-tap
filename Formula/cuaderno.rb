class Cuaderno < Formula
  desc "Markdown vault manager for the Research Logbook Method (CLI + MCP server)"
  homepage "https://github.com/agustinvalencia/cuaderno"
  version "0.28.0"
  license "MPL-2.0"

  on_macos do
    on_arm do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.28.0/cuaderno-0.28.0-aarch64-apple-darwin.tar.gz"
      sha256 "e7e580d22e747e77c9e36482d1d639b7662a8fe61cdc36ba5fbbb2b26e05e95b"
    end
    on_intel do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.28.0/cuaderno-0.28.0-x86_64-apple-darwin.tar.gz"
      sha256 "1346ca8597f7aeeb5bdb5cdc7ab49b0f4f8549d6c88d6ae51b2014cc8fc0d574"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.28.0/cuaderno-0.28.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "3f98d30d083cbe40a49c47ab780527ec7c76ac0e2e52c79b2b2b6d652fbd8120"
    end
    on_intel do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.28.0/cuaderno-0.28.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "5d5841075097f97e7dbbcd28d41057af33423980582db4d37342006d8ed0cc39"
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
