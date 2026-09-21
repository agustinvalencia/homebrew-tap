class Cuaderno < Formula
  desc "Markdown vault manager for the Research Logbook Method (CLI + MCP server)"
  homepage "https://github.com/agustinvalencia/cuaderno"
  version "0.38.0"
  license "MPL-2.0"

  on_macos do
    on_arm do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.38.0/cuaderno-0.38.0-aarch64-apple-darwin.tar.gz"
      sha256 "9b98c4045d03803a1c9c305422bfecb8aeeeb7d3f7fafd773d27050d8b342bc6"
    end
    on_intel do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.38.0/cuaderno-0.38.0-x86_64-apple-darwin.tar.gz"
      sha256 "9c15a1764b9359ce972f9bb8eb6446d45bca18ab3dd9a2059f4467be049f519f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.38.0/cuaderno-0.38.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "a4ef4fb7f8142a3cc8c8334c1d4326e5e96506182d8bf36af6a197832cbac28c"
    end
    on_intel do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.38.0/cuaderno-0.38.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "a9e39b2fdb0f6c242957359fd21833ec4724af5f99dee88d475f4f7a6bda2093"
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
