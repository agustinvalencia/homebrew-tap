cask "cuaderno-app" do
  version "0.25.0"
  sha256 "19cc8df194aebb5041e659a5d84d91e75cf15cd9eeb240af01f8a4579879ee94"

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
