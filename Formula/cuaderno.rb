class Cuaderno < Formula
  desc "Markdown vault manager for the Research Logbook Method (CLI + MCP server)"
  homepage "https://github.com/agustinvalencia/cuaderno"
  version "0.25.0"
  license "MPL-2.0"

  on_macos do
    on_arm do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.25.0/cuaderno-0.25.0-aarch64-apple-darwin.tar.gz"
      sha256 "18d61648d9eee350a78b762391e3b1b3fdd810e2ca95e71bd9dd2050af8dc9c5"
    end
    on_intel do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.25.0/cuaderno-0.25.0-x86_64-apple-darwin.tar.gz"
      sha256 "7cd4fa0c6fb1371c5fef0c5697cf6d7b11a0100bc22db911d305f13344b88e2e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.25.0/cuaderno-0.25.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "1bd532f25534252cfb921737e93b59cadbf5d2b85bb716b1f5839d35156edcb9"
    end
    on_intel do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.25.0/cuaderno-0.25.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "eab8f1037e97a25d5dada9f1eb5c67eb9f31e99709f916b872e15db2d391175e"
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
