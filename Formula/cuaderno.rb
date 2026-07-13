class Cuaderno < Formula
  desc "Markdown vault manager for the Research Logbook Method (CLI + MCP server)"
  homepage "https://github.com/agustinvalencia/cuaderno"
  version "0.27.0"
  license "MPL-2.0"

  on_macos do
    on_arm do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.27.0/cuaderno-0.27.0-aarch64-apple-darwin.tar.gz"
      sha256 "1ab49bcddb5e2012bb1d1a5efdd9d0aa5a89f669a06a88a4e3bbb9dc7169aba5"
    end
    on_intel do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.27.0/cuaderno-0.27.0-x86_64-apple-darwin.tar.gz"
      sha256 "7f14b9480ebf5993e108d073b9d228a7ea1f1d24f8043af4c09cd78da1355088"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.27.0/cuaderno-0.27.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "567df80732bb41fb8983952baa3290318740403350fccf37481707826f0b257f"
    end
    on_intel do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.27.0/cuaderno-0.27.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "2d96541292529794516546c15a190d43dde68779fb7f186c9fd5b977a60bd8b4"
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
