class Cuaderno < Formula
  desc "Markdown vault manager for the Research Logbook Method (CLI + MCP server)"
  homepage "https://github.com/agustinvalencia/cuaderno"
  version "0.32.1"
  license "MPL-2.0"

  on_macos do
    on_arm do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.32.1/cuaderno-0.32.1-aarch64-apple-darwin.tar.gz"
      sha256 "ca7e3dd1425bb012984d67d5af6b0635edec8612e8e89896c1f658e60e8a8030"
    end
    on_intel do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.32.1/cuaderno-0.32.1-x86_64-apple-darwin.tar.gz"
      sha256 "298468abec1165c126dfb42193216f1029bc762b517e17ed909a3a722974eaa4"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.32.1/cuaderno-0.32.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "b800ea5e205062cf29f5bd394663ac9455b6f565e5de60627fe8bac78330923c"
    end
    on_intel do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.32.1/cuaderno-0.32.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "782a702053a7de8b9a75ef650ceca544692413a5e35f1ddf214d4afed80ad6c8"
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
