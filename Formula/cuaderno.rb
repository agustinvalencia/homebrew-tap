class Cuaderno < Formula
  desc "Markdown vault manager for the Research Logbook Method (CLI + MCP server)"
  homepage "https://github.com/agustinvalencia/cuaderno"
  version "0.1.23"
  license "MPL-2.0"

  on_macos do
    on_arm do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.1.23/cuaderno-0.1.23-aarch64-apple-darwin.tar.gz"
      sha256 "9f23ed7ef4fa0991cc21a3963a8e244007dcb30c636d2b5386a1c3e271e82ff5"
    end
    on_intel do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.1.23/cuaderno-0.1.23-x86_64-apple-darwin.tar.gz"
      sha256 "c789091b09aeacbca7f82fffb8b48b7a1fee0a1fde598a34ee3888f95cd37039"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.1.23/cuaderno-0.1.23-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "52875c139e5ddf4a8147d6f7b006557055bf7c97b7ba16e609a0c1d053fd2e23"
    end
    on_intel do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.1.23/cuaderno-0.1.23-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "f9745d2abab10cf4aef6eaba95759dcf5febd54f3944c5da6933fd6a9025f057"
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
