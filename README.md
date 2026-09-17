# Homebrew Tap

This is a Homebrew tap for my personal projects.

## Installation

```bash
brew tap agustinvalencia/tap
```

## Available Formulae

### cuaderno

Markdown vault manager implementing the Research Logbook Method. Ships two binaries: `cdno` (the CLI for the daily loop) and `cdno-mcp` (the MCP server exposing the vault to Claude / Kiro / Gemini CLI).

```bash
brew install agustinvalencia/tap/cuaderno
```

### mdvault

CLI tool for managing markdown vaults with structured notes, validation, and search. (Predecessor to cuaderno; both are maintained.)

```bash
brew install agustinvalencia/tap/mdvault
```

## Available Casks

### cuaderno-app

The Cuaderno desktop app (Tauri). Apple Silicon only.

```bash
brew install --cask agustinvalencia/tap/cuaderno-app
```

> **Known deprecation warning.** `brew upgrade` prints ``Calling `postflight` is
> deprecated! Use `postflight_steps` instead`` for this cask. It is expected and
> harmless for now — do not "fix" it by renaming the stanza.
>
> The `postflight` block strips `com.apple.quarantine` from the installed app,
> which Gatekeeper would otherwise block because the app is ad-hoc signed rather
> than notarised. `postflight_steps` accepts only a fixed vocabulary of file
> operations (`mkdir`, `touch`, `move`, `symlink`, …) with literal arguments — it
> has no `system_command`, so the `xattr` call cannot be expressed in it. The
> `--no-quarantine` flag that used to serve the same purpose was removed from
> Homebrew in [Homebrew/brew#20755](https://github.com/Homebrew/brew/issues/20755).
>
> Legacy flight blocks remain supported for third-party taps, so this is a
> warning rather than a breakage. The real fix is to notarise the DMG and delete
> the block: [cuaderno#577](https://github.com/agustinvalencia/cuaderno/issues/577).

## More Information

- [cuaderno repository](https://github.com/agustinvalencia/cuaderno)
- [mdvault repository](https://github.com/agustinvalencia/mdvault)
