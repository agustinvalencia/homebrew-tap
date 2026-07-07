class Cuaderno < Formula
  desc "Markdown vault manager for the Research Logbook Method (CLI + MCP server)"
  homepage "https://github.com/agustinvalencia/cuaderno"
  version "0.4.0"
  license "MPL-2.0"

  on_macos do
    on_arm do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.4.0/cuaderno-0.4.0-aarch64-apple-darwin.tar.gz"
      sha256 "34acbeb25f3f2a8cd4c042bc3b85418e545e2e281f704653277160c49a0d8219"
    end
    on_intel do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.4.0/cuaderno-0.4.0-x86_64-apple-darwin.tar.gz"
      sha256 "ee5b25a27702dc7cd8d10c13dd43c6bed98ca8df1e2c18c6b43570e57819b16e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.4.0/cuaderno-0.4.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "a4318e89d89c50f73c5bb6ea28cc8df5d8a1034501b878556001b46b1ea5145f"
    end
    on_intel do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.4.0/cuaderno-0.4.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "3963f6338e1241a58623add72b727f4070e92d315c0db285aad9ed398ccb7760"
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
