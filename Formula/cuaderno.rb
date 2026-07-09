class Cuaderno < Formula
  desc "Markdown vault manager for the Research Logbook Method (CLI + MCP server)"
  homepage "https://github.com/agustinvalencia/cuaderno"
  version "0.15.0"
  license "MPL-2.0"

  on_macos do
    on_arm do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.15.0/cuaderno-0.15.0-aarch64-apple-darwin.tar.gz"
      sha256 "42693001a6b47d2117741018efd63ffe91a82f0135b1d806453db8d49810e7bc"
    end
    on_intel do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.15.0/cuaderno-0.15.0-x86_64-apple-darwin.tar.gz"
      sha256 "70a25e80108581b483fd5a2ee6745236575c4ed664a6cf8905bf981756d86836"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.15.0/cuaderno-0.15.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "78bc42a3a8731eafb76803193f764661d75fc0d6c2cdbe6abb142efdb2e1d943"
    end
    on_intel do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.15.0/cuaderno-0.15.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "7ba0c5aa07e6a8bd65ea3c0c5bf8917cd8f195fe68e2d28f509496bd083b5c0b"
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
