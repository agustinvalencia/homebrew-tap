class Cuaderno < Formula
  desc "Markdown vault manager for the Research Logbook Method (CLI + MCP server)"
  homepage "https://github.com/agustinvalencia/cuaderno"
  version "0.42.0"
  license "MPL-2.0"

  on_macos do
    on_arm do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.42.0/cuaderno-0.42.0-aarch64-apple-darwin.tar.gz"
      sha256 "c963c64df7c58d24f748189248bad1c7ea61a2872be65f152dbd0723ce6b6939"
    end
    on_intel do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.42.0/cuaderno-0.42.0-x86_64-apple-darwin.tar.gz"
      sha256 "43a4e99da65c0383cf2efcc05cf3fd8392c4d4638ec8b2cbdd5752fb000c4b12"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.42.0/cuaderno-0.42.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "e0a9e8d6931532d5687703430d69e29de64bf181ec99772f1c8e0f1ae1a7ae44"
    end
    on_intel do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.42.0/cuaderno-0.42.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "d62eb42b1ecee2dbaa0160b1e76b8933850fddeca9994805764ca505d0d58fc7"
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
