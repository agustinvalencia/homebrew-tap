cask "cuaderno-app" do
  version "0.8.1"
  sha256 "17c4788b8463e7da862ddcb5ae102c97175e449016dc950965afaa8705f6457b"

  url "https://github.com/agustinvalencia/cuaderno/releases/download/v#{version}/cuaderno-app-#{version}-aarch64-apple-darwin.dmg"
  name "Cuaderno"
  desc "Desktop app for the Cuaderno research-logbook vault (Tauri)"
  homepage "https://github.com/agustinvalencia/cuaderno"

  # Apple Silicon only for now: the release workflow builds the dmg on
  # the arm64 runner. An Intel dmg can join when there is a taker.
  depends_on arch: :arm64

  app "cuaderno.app"

  caveats <<~EOS
    The app is ad-hoc signed (not notarized), so Gatekeeper blocks the
    first launch. Strip the quarantine attribute after installing
    (recent Homebrew removed the --no-quarantine flag):

      xattr -dr com.apple.quarantine /Applications/cuaderno.app

    A Finder-launched app inherits no shell environment, so tell GUI
    apps where the vault lives (once per login):

      launchctl setenv CUADERNO_VAULT_PATH "$HOME/Documents/notebook"

    then launch cuaderno. One-off alternative from a terminal:

      CUADERNO_VAULT_PATH=~/Documents/notebook open -a cuaderno
  EOS
end
