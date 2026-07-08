class Cuaderno < Formula
  desc "Markdown vault manager for the Research Logbook Method (CLI + MCP server)"
  homepage "https://github.com/agustinvalencia/cuaderno"
  version "0.9.0"
  license "MPL-2.0"

  on_macos do
    on_arm do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.9.0/cuaderno-0.9.0-aarch64-apple-darwin.tar.gz"
      sha256 "888874d045b8668b081b308d45a9b942c8deb84beac453b15d1a48374b13c21e"
    end
    on_intel do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.9.0/cuaderno-0.9.0-x86_64-apple-darwin.tar.gz"
      sha256 "7fd33acf996ec8659bd2ed4db74870e8d748e6d73df735ee7f532399538785ca"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.9.0/cuaderno-0.9.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "947d7efee0a5dc2c1fd4a76c4e9fd478a35e90354d71934e2c8da6c6cf745a25"
    end
    on_intel do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.9.0/cuaderno-0.9.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "4fcec6c586c6b80e7aa09ccb43ed034c31f1fd91f545e35cf9abf2254137b498"
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
