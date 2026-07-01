class Cuaderno < Formula
  desc "Markdown vault manager for the Research Logbook Method (CLI + MCP server)"
  homepage "https://github.com/agustinvalencia/cuaderno"
  version "0.2.0"
  license "MPL-2.0"

  on_macos do
    on_arm do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.2.0/cuaderno-0.2.0-aarch64-apple-darwin.tar.gz"
      sha256 "f29c588c4580b5c71ee9c58e7eb1f7015e0953c6baa136f600e21e20fce9330e"
    end
    on_intel do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.2.0/cuaderno-0.2.0-x86_64-apple-darwin.tar.gz"
      sha256 "3474345400bdd3484c71db62e3b4831b1c3203e0958abda4541cbbc7417d712c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.2.0/cuaderno-0.2.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "616ba2e0bdf10924eda281540ad2ee6f8a10230a4b21d97ec02b89e712c23f67"
    end
    on_intel do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.2.0/cuaderno-0.2.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "1156d6f9a38956bffcf3c3c028f315c8c878d074ded94d7b9d2d6a82d6c8ea1d"
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
