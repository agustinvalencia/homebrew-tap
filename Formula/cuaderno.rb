class Cuaderno < Formula
  desc "Markdown vault manager for the Research Logbook Method (CLI + MCP server)"
  homepage "https://github.com/agustinvalencia/cuaderno"
  version "0.18.0"
  license "MPL-2.0"

  on_macos do
    on_arm do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.18.0/cuaderno-0.18.0-aarch64-apple-darwin.tar.gz"
      sha256 "307eaf576fcf695657394b8578365f0e37569dce9732502957bdc5e8d8fc4ec4"
    end
    on_intel do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.18.0/cuaderno-0.18.0-x86_64-apple-darwin.tar.gz"
      sha256 "9b4001aac9f082753c4470262505f88c5e4ab597d60347b6a374e0c750dd3b11"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.18.0/cuaderno-0.18.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "12e1e8406d65a63c2013526f8c414ed405ec2ec4a9ad257763b7502e1fb952f6"
    end
    on_intel do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.18.0/cuaderno-0.18.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "87aeabd11a671b39e862817c24cdc1e63cd929608b3aded2745fab60b1a23d45"
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
