class Cuaderno < Formula
  desc "Markdown vault manager for the Research Logbook Method (CLI + MCP server)"
  homepage "https://github.com/agustinvalencia/cuaderno"
  version "0.1.15"
  license "MPL-2.0"

  on_macos do
    on_arm do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.1.15/cuaderno-0.1.15-aarch64-apple-darwin.tar.gz"
      sha256 "b29fa971b1b7ffa760ea00fca947e0cc938263c988919877b3b4d7321b6b51e0"
    end
    on_intel do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.1.15/cuaderno-0.1.15-x86_64-apple-darwin.tar.gz"
      sha256 "7473f3e6963b096c0881ff880639c8378f99189ebfebfd49deb505feef6fbe4e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.1.15/cuaderno-0.1.15-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "bde07d8581396b6b46cf7358f31810d8ecfe1465c534f0212419e67dac7e7d46"
    end
    on_intel do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.1.15/cuaderno-0.1.15-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "ec2c8534e836a522bddb4b989f710ea8c0f3a005032d373ef66aaa71b5f5746c"
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
