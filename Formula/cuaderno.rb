class Cuaderno < Formula
  desc "Markdown vault manager for the Research Logbook Method (CLI + MCP server)"
  homepage "https://github.com/agustinvalencia/cuaderno"
  version "0.1.2"
  license "MPL-2.0"

  on_macos do
    on_arm do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.1.2/cuaderno-0.1.2-aarch64-apple-darwin.tar.gz"
      sha256 "2673627d8bab61d335600d4ec7354a503fd38c6a25e52a24efab6ae602a9af37"
    end
    on_intel do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.1.2/cuaderno-0.1.2-x86_64-apple-darwin.tar.gz"
      sha256 "5360ba00a51ab3e4fb15b0b2a0ee8fee09587260148c2325c16a5885243ff5fd"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.1.2/cuaderno-0.1.2-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "c8277c97620c8d3cdb070ec7b0b8eb28a36631ffff042af77ccd660bf6f98156"
    end
    on_intel do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.1.2/cuaderno-0.1.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "d96a8259143b48d996d094d59d478562651151f92322b61262fa2bbd6618a9d6"
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
