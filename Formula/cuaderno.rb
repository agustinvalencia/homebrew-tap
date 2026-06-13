class Cuaderno < Formula
  desc "Markdown vault manager for the Research Logbook Method (CLI + MCP server)"
  homepage "https://github.com/agustinvalencia/cuaderno"
  version "0.1.9"
  license "MPL-2.0"

  on_macos do
    on_arm do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.1.9/cuaderno-0.1.9-aarch64-apple-darwin.tar.gz"
      sha256 "6907e37422386d4181d26cdc1a7b1b432c1622003000766a2d96845a334e7d25"
    end
    on_intel do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.1.9/cuaderno-0.1.9-x86_64-apple-darwin.tar.gz"
      sha256 "725162f18bf2e13fd21760c2e4f639017fcf58996d38dbe857295ad290c7259b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.1.9/cuaderno-0.1.9-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "cabb6e866b46f8e9f11b59006f9e2f3a4866f6a8414c58c8f3c3fba1567d9f22"
    end
    on_intel do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.1.9/cuaderno-0.1.9-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "1338eb5ff38df49ec5b4ef2215342959355b15c6dd79db6eed94e915b9dcd36d"
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
