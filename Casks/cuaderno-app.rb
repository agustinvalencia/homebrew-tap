cask "cuaderno-app" do
  version "0.20.1"
  sha256 "463f0364a17d6c9ce6bec8b5fa5d149afe6e8ce3b8a3fbe5db19de6e010aa698"

  url "https://github.com/agustinvalencia/cuaderno/releases/download/v#{version}/cuaderno-app-#{version}-aarch64-apple-darwin.dmg"
  name "Cuaderno"
  desc "Desktop app for the Cuaderno research-logbook vault (Tauri)"
  homepage "https://github.com/agustinvalencia/cuaderno"

  # Apple Silicon only for now: the release workflow builds the dmg on
  # the arm64 runner. An Intel dmg can join when there is a taker.
  depends_on macos: :big_sur
  depends_on arch: :arm64

  app "cuaderno.app"

  # The app is ad-hoc signed (not notarized), so Gatekeeper flags it as
  # "damaged" on first launch. Strip the quarantine attribute after the
  # app is staged (recent Homebrew removed the --no-quarantine flag).
  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/cuaderno.app"]
  end

  caveats <<~EOS
    The app is ad-hoc signed (not notarized). This cask strips the
    quarantine attribute on install so Gatekeeper won't block the first
    launch. If macOS still reports it as damaged, run manually:

      xattr -dr com.apple.quarantine /Applications/cuaderno.app

    On first launch the app asks for your vault folder with a native
    picker and remembers the choice — no environment setup needed.
    CUADERNO_VAULT_PATH remains an explicit override for terminals:

      CUADERNO_VAULT_PATH=~/Documents/notebook open -a cuaderno
  EOS
end
