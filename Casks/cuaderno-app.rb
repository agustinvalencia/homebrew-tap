cask "cuaderno-app" do
  version "0.7.0"
  sha256 "5b433ee7aab861b80d71b6f8c6805153fd0d1a1b90a98d6836d10327cf9cf527"

  url "https://github.com/agustinvalencia/cuaderno/releases/download/v#{version}/cuaderno-app-#{version}-aarch64-apple-darwin.dmg"
  name "Cuaderno"
  desc "Desktop app for the Cuaderno research-logbook vault (Tauri)"
  homepage "https://github.com/agustinvalencia/cuaderno"

  # Apple Silicon only for now: the release workflow builds the dmg on
  # the arm64 runner. An Intel dmg can join when there is a taker.
  depends_on arch: :arm64

  app "cuaderno.app"

  caveats <<~EOS
    The app is ad-hoc signed (not notarized). Install with
    --no-quarantine to skip the Gatekeeper block:

      brew install --cask agustinvalencia/tap/cuaderno-app --no-quarantine

    A Finder-launched app inherits no shell environment, so tell GUI
    apps where the vault lives (once per login):

      launchctl setenv CUADERNO_VAULT_PATH "$HOME/Documents/notebook"

    then launch cuaderno. One-off alternative from a terminal:

      CUADERNO_VAULT_PATH=~/Documents/notebook open -a cuaderno
  EOS
end
