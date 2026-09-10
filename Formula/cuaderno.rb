class Cuaderno < Formula
  desc "Markdown vault manager for the Research Logbook Method (CLI + MCP server)"
  homepage "https://github.com/agustinvalencia/cuaderno"
  version "0.37.0"
  license "MPL-2.0"

  on_macos do
    on_arm do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.37.0/cuaderno-0.37.0-aarch64-apple-darwin.tar.gz"
      sha256 "a32e2005af07a4db17723d10142d25fa5ada51fed26fc09a1ad18aad08c1e749"
    end
    on_intel do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.37.0/cuaderno-0.37.0-x86_64-apple-darwin.tar.gz"
      sha256 "a54d7b4807f8ffba061cedeadc5c3d21c4b7f85d83ee85683451d16a7359fb79"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.37.0/cuaderno-0.37.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "c1910e09e0e4613fd5ac288e8497ec6228baeeee072ea71b191cc422d845c038"
    end
    on_intel do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.37.0/cuaderno-0.37.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "fce361ecdbae7d861a35bfa05393dcdf1e8f3331e119484357aacca0f496e033"
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
