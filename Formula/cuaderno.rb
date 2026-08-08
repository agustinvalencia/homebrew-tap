class Cuaderno < Formula
  desc "Markdown vault manager for the Research Logbook Method (CLI + MCP server)"
  homepage "https://github.com/agustinvalencia/cuaderno"
  version "0.34.0"
  license "MPL-2.0"

  on_macos do
    on_arm do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.34.0/cuaderno-0.34.0-aarch64-apple-darwin.tar.gz"
      sha256 "852e289d5f68a9309d638dfa242a2e752a65796fef8ab2fa42bdd7cb0c634580"
    end
    on_intel do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.34.0/cuaderno-0.34.0-x86_64-apple-darwin.tar.gz"
      sha256 "b1251746e715d23a21d1c2106747b835ed49fdd78a0e5ac28b9271788a1ad232"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.34.0/cuaderno-0.34.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "4453c20d38da3cba752a5c2caeb9a056957928b2ce5a21702e6e390b0eb7abce"
    end
    on_intel do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.34.0/cuaderno-0.34.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "801c6f434f26a62765a3399b2a5cb64f4ef3ea9a9f13b36088e825282f5880a6"
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
