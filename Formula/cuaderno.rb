class Cuaderno < Formula
  desc "Markdown vault manager for the Research Logbook Method (CLI + MCP server)"
  homepage "https://github.com/agustinvalencia/cuaderno"
  version "0.24.0"
  license "MPL-2.0"

  on_macos do
    on_arm do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.24.0/cuaderno-0.24.0-aarch64-apple-darwin.tar.gz"
      sha256 "8450c01e8e7215d09148386c07a9c9d2f6b7a1c5f5be58dc34a58659f3a6db06"
    end
    on_intel do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.24.0/cuaderno-0.24.0-x86_64-apple-darwin.tar.gz"
      sha256 "85ae8bf86c6b7c0732e498cd40f885ce32f73c3e70f42b4130e3736eb360c105"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.24.0/cuaderno-0.24.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "2db07ebb076f2bcc7b603d5dff70421cfd76f5eb04255da5fb87584e15706705"
    end
    on_intel do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.24.0/cuaderno-0.24.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "59f60aee79155e28b892230970fcd4a885d50aae11d45de702aded551d1e1c89"
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
