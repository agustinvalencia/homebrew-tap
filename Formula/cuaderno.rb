class Cuaderno < Formula
  desc "Markdown vault manager for the Research Logbook Method (CLI + MCP server)"
  homepage "https://github.com/agustinvalencia/cuaderno"
  version "0.41.0"
  license "MPL-2.0"

  on_macos do
    on_arm do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.41.0/cuaderno-0.41.0-aarch64-apple-darwin.tar.gz"
      sha256 "7c64ab2128f607b7c38db6f7fd39ef7152257802274cc52831a8b3c1a3aea7d9"
    end
    on_intel do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.41.0/cuaderno-0.41.0-x86_64-apple-darwin.tar.gz"
      sha256 "34a381578beaf29141b6993ee00f23298ecbc78897f41edb9efa1cf6d5e1172f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.41.0/cuaderno-0.41.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "227c6405cac18dd8035169b90316061ed83f0b7f34b77f21a9bdd86c368f8601"
    end
    on_intel do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.41.0/cuaderno-0.41.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "bdf5447d1ad0be6a436ae9517432388ebc7c8ef7ff732095ff591fa6557e9f4a"
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
