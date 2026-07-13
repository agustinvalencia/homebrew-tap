class Cuaderno < Formula
  desc "Markdown vault manager for the Research Logbook Method (CLI + MCP server)"
  homepage "https://github.com/agustinvalencia/cuaderno"
  version "0.26.0"
  license "MPL-2.0"

  on_macos do
    on_arm do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.26.0/cuaderno-0.26.0-aarch64-apple-darwin.tar.gz"
      sha256 "e6998bf17becf1257f0f26a3710221b84d75714fa514c20c5db6096e3153f09b"
    end
    on_intel do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.26.0/cuaderno-0.26.0-x86_64-apple-darwin.tar.gz"
      sha256 "8baa39bea67b18673b063f6423b554d40d47569eb3a3082cd0418adf9c1991b7"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.26.0/cuaderno-0.26.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "c8acc1a34497b79d8f68d92c4fa17348b815b8950b0d17df8c8e228a16f4fe0a"
    end
    on_intel do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.26.0/cuaderno-0.26.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "9477b26fcea95c03ea452a7e2cb645af068bfc1dc264c4f7ec9c16432de86288"
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
