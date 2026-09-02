# Portable NvChad configuration

A cross-platform Neovim configuration based on NvChad 2.5. It includes LSP,
completion, formatting, linting, Treesitter, debugging, and test integration.

## Requirements

- Neovim 0.11 or newer
- Git
- A Nerd Font (recommended)
- `curl` or `wget`, plus an archive extractor, for Mason
- Language runtimes/compilers for the projects you use

## Install

Back up your existing Neovim configuration, then clone this repository to the
configuration directory for your operating system:

- Linux/macOS: `~/.config/nvim`
- Windows: `%LOCALAPPDATA%\nvim`

Start `nvim`. lazy.nvim bootstraps itself and installs plugins. Mason then
installs all declared language tools in the background. Run `:Mason` to inspect
installation progress and `:checkhealth` to diagnose the host machine.
`:ConfigHealth` prints a concise status of every configured external tool.

The first launch requires an internet connection. Plugin versions are pinned in
`lazy-lock.json`; use `:Lazy update` intentionally when upgrading.

Mason installs tools asynchronously. DAP adapters are registered in advance,
so newly installed debuggers can be used without restarting Neovim. Some tools
still require their language runtime, such as Java, Node.js, Python, Go, Rust,
or .NET.

## Main keymaps

| Key | Action |
| --- | --- |
| `<F5>` | Start/continue debugging |
| `<F10>` / `<F11>` / `<F12>` | Step over/into/out |
| `<leader>db` | Toggle breakpoint |
| `<leader>du` | Toggle debugger UI |
| `<leader>li` | Run linter |
| `<leader>tt` | Run nearest test |
| `<leader>tf` | Run current test file |
| `<leader>ts` | Toggle test summary |

Format-on-save uses an installed formatter first and falls back to LSP. Missing
optional executables never prevent Neovim from starting.

## Validation

Run the reproducible headless smoke test from the configuration directory:

```sh
nvim --headless -l scripts/smoke.lua
```
