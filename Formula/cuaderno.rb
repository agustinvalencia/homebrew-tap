class Cuaderno < Formula
  desc "Markdown vault manager for the Research Logbook Method (CLI + MCP server)"
  homepage "https://github.com/agustinvalencia/cuaderno"
  version "0.33.1"
  license "MPL-2.0"

  on_macos do
    on_arm do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.33.1/cuaderno-0.33.1-aarch64-apple-darwin.tar.gz"
      sha256 "22845b3eda04e377969a7e84b4f010c301c210221dc41c376a32673f716b9924"
    end
    on_intel do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.33.1/cuaderno-0.33.1-x86_64-apple-darwin.tar.gz"
      sha256 "67450575d2f1280f9a6a5bb42ac07c364a938bf40ea6cf3d8a8d6ee14c217d9f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.33.1/cuaderno-0.33.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "e78d177f99ea8393da6cb1563b1ce137893f8b45d2c1e9650df483c1f63cd400"
    end
    on_intel do
      url "https://github.com/agustinvalencia/cuaderno/releases/download/v0.33.1/cuaderno-0.33.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "8a3a7b1f7289fb7da54d4bfe0e4d286225e5cfae54d945a9e1a16ebe8970c16c"
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
