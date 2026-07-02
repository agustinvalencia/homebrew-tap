class Cuaderno < Formula
  desc "Markdown vault manager for the Research Logbook Method (CLI + MCP server)"
  homepage "https://github.com/agustinvalencia/cuaderno"
  version "0.2.1"
  license "MPL-2.0"

  on_macos do
    on_arm do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.2.1/cuaderno-0.2.1-aarch64-apple-darwin.tar.gz"
      sha256 "a4cf9308db90813f43f6ee575bc46ec7403f065f980c962a03294d08cdd46f46"
    end
    on_intel do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.2.1/cuaderno-0.2.1-x86_64-apple-darwin.tar.gz"
      sha256 "a26c7fc54fa94f1f1bfe17af57f1bcf5debda9274c147e1b02005795a12c9fd4"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.2.1/cuaderno-0.2.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "fad0c11186f2497aeba514c353c3375620eb0ff501d2b2add977ea788f52e2d7"
    end
    on_intel do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.2.1/cuaderno-0.2.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "e546f773593cc04c3ff5151e7b4210f94db22e48795b4ec24a9876388d73367f"
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
