class Cuaderno < Formula
  desc "Markdown vault manager for the Research Logbook Method (CLI + MCP server)"
  homepage "https://github.com/agustinvalencia/cuaderno"
  version "0.44.0"
  license "MPL-2.0"

  on_macos do
    on_arm do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.44.0/cuaderno-0.44.0-aarch64-apple-darwin.tar.gz"
      sha256 "37cee607a45bfd2fb221c2cf25a1f8b71cb72100cee8013369298bdb0e9cea70"
    end
    on_intel do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.44.0/cuaderno-0.44.0-x86_64-apple-darwin.tar.gz"
      sha256 "31ef18299f6926871dfe154981c73ae4c189227dd1dd0fa3d3539ada8fd4c495"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.44.0/cuaderno-0.44.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "b2182e5c786496657f52627edaab4b2edded7a0516da1eded2ac1b5751125241"
    end
    on_intel do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.44.0/cuaderno-0.44.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "89cb8e189bce89696def6c988a758fd9150565fca919a37f25ecfd631420b165"
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
