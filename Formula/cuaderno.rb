class Cuaderno < Formula
  desc "Markdown vault manager for the Research Logbook Method (CLI + MCP server)"
  homepage "https://github.com/agustinvalencia/cuaderno"
  version "0.43.0"
  license "MPL-2.0"

  on_macos do
    on_arm do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.43.0/cuaderno-0.43.0-aarch64-apple-darwin.tar.gz"
      sha256 "c53c6fd21e0180e0f7d4c567567cc95b24158d113a1a7c938ee4c8b2da75754a"
    end
    on_intel do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.43.0/cuaderno-0.43.0-x86_64-apple-darwin.tar.gz"
      sha256 "5c08856d7395a1a8dae9fac9c6fc89497a32d410409200afd6af4ea1b801da00"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.43.0/cuaderno-0.43.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "22cb2a8127151a1ea2755fc269919e82fe932e25c05b4fbd7123932a77b0cf4a"
    end
    on_intel do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.43.0/cuaderno-0.43.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "61739a2dae0175c8013f2f04776d35e9fdf5b490acce99db6c56f0ff544b7502"
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
