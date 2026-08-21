class Cuaderno < Formula
  desc "Markdown vault manager for the Research Logbook Method (CLI + MCP server)"
  homepage "https://github.com/agustinvalencia/cuaderno"
  version "0.35.1"
  license "MPL-2.0"

  on_macos do
    on_arm do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.35.1/cuaderno-0.35.1-aarch64-apple-darwin.tar.gz"
      sha256 "2303043166e1d80f5dfa94747d57bf27a63d702f8ad0e98e21c65c3e4189ff67"
    end
    on_intel do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.35.1/cuaderno-0.35.1-x86_64-apple-darwin.tar.gz"
      sha256 "e8a0691be3270025c82eb9217eb53b6b721c1361e290f8ec2b8a20d4f0a95a7f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.35.1/cuaderno-0.35.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "894b9f67bfccdd78998ef8df3ea0462fb95b93148a6b76ee2d27a7800e7a301e"
    end
    on_intel do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.35.1/cuaderno-0.35.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "d573c90f224a29e1a9a18e071cc7ffa058cfd332c03a7de51d5ec430710b26f9"
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
