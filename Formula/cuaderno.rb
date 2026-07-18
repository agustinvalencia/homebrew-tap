class Cuaderno < Formula
  desc "Markdown vault manager for the Research Logbook Method (CLI + MCP server)"
  homepage "https://github.com/agustinvalencia/cuaderno"
  version "0.29.1"
  license "MPL-2.0"

  on_macos do
    on_arm do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.29.1/cuaderno-0.29.1-aarch64-apple-darwin.tar.gz"
      sha256 "896ee3f97a7f3e1d32385e88cbfc7f7ca8614f00e3b40580ba4d1b91672d8f67"
    end
    on_intel do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.29.1/cuaderno-0.29.1-x86_64-apple-darwin.tar.gz"
      sha256 "1f07813c10ca6a0155653112da6785fa8298d5a5264670375286301f8811d69f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.29.1/cuaderno-0.29.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "6801f7c43f975bd7229af5a383866de7efe4dd5169ba7a4e14d5f94b74ceb577"
    end
    on_intel do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.29.1/cuaderno-0.29.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "cf4005dcb85d8699b884442afc5758a18ebec4f05a38c0da200c8650595db308"
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
