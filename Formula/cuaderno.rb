class Cuaderno < Formula
  desc "Markdown vault manager for the Research Logbook Method (CLI + MCP server)"
  homepage "https://github.com/agustinvalencia/cuaderno"
  version "0.17.0"
  license "MPL-2.0"

  on_macos do
    on_arm do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.17.0/cuaderno-0.17.0-aarch64-apple-darwin.tar.gz"
      sha256 "6b6b1881b94895b4c38d6f4ac40266a8a8560fc4bb5530892b9495c2ac5286b9"
    end
    on_intel do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.17.0/cuaderno-0.17.0-x86_64-apple-darwin.tar.gz"
      sha256 "db59618c17bc8b8e7faa9062e82a13b789f2a24e2d080b915ef8d156330abc38"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.17.0/cuaderno-0.17.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "fd30ae296a4866ec89f3b5d44602816e509ac910081c01f58b111dc20df61e9b"
    end
    on_intel do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.17.0/cuaderno-0.17.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "b6c4d5c1f630b5377a38492ea47f6c08fc2fef2ec17f69e136988ad33d2e0679"
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
