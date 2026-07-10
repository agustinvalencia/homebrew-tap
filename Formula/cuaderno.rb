class Cuaderno < Formula
  desc "Markdown vault manager for the Research Logbook Method (CLI + MCP server)"
  homepage "https://github.com/agustinvalencia/cuaderno"
  version "0.19.1"
  license "MPL-2.0"

  on_macos do
    on_arm do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.19.1/cuaderno-0.19.1-aarch64-apple-darwin.tar.gz"
      sha256 "edf8fb6bb0d56f0ed60ed55fea3598b9b0f673731cc8539dcbaf3081e29aff6c"
    end
    on_intel do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.19.1/cuaderno-0.19.1-x86_64-apple-darwin.tar.gz"
      sha256 "da8d7c21999f78c45d8c80cbfe4fbd811481cb52b7f9f8ed3ae4543fc342f8e2"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.19.1/cuaderno-0.19.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "7e176a137cbd862820beba59f9bb98e82b09b2c3378c5aa88eec220fe6059bf0"
    end
    on_intel do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.19.1/cuaderno-0.19.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "3589b1fc05fa2398a80bd93957af521e4535e60ed5fc010503b4415aee65f690"
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
