class Cuaderno < Formula
  desc "Markdown vault manager for the Research Logbook Method (CLI + MCP server)"
  homepage "https://github.com/agustinvalencia/cuaderno"
  version "0.1.25"
  license "MPL-2.0"

  on_macos do
    on_arm do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.1.25/cuaderno-0.1.25-aarch64-apple-darwin.tar.gz"
      sha256 "ded581994ae8d1137a632efd10e2fa2a0c017eedb0bc9134f962147e6cc73bee"
    end
    on_intel do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.1.25/cuaderno-0.1.25-x86_64-apple-darwin.tar.gz"
      sha256 "8fae0cec579c3a7fdf7c40d8b38dcc365642e23815af7607b22701ac5ff6fcd0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.1.25/cuaderno-0.1.25-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "2a84d67dc5149b1310b5af3f629b15c93f8d72ecc9886f17c124e8b240eab652"
    end
    on_intel do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.1.25/cuaderno-0.1.25-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "ba0a9e08581f7e2588389a0de721383bd4876904a3991a94500874e98370e4e5"
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
