cask "cuaderno-app" do
  version "0.8.0"
  sha256 "b3f0fbc01ade33e5d2e95ef794af584429ef8560e67d9039e0d56f114344508e"

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
