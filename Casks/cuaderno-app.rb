cask "cuaderno-app" do
  version "0.16.0"
  sha256 "b0e00e0af0389e189f119b5e5724ce2021b543a52afd463ff64b9d61cbc66860"

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

    On first launch the app asks for your vault folder with a native
    picker and remembers the choice — no environment setup needed.
    CUADERNO_VAULT_PATH remains an explicit override for terminals:

      CUADERNO_VAULT_PATH=~/Documents/notebook open -a cuaderno
  EOS
end
