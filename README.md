# Stable cross-platform NvChad IDE configuration

A portable Neovim configuration based on NvChad 2.5. It provides a complete
day-to-day IDE workflow on Windows and Linux: navigation, completion, LSP,
formatting, linting, diagnostics, project-wide search and replace, Git, tasks,
sessions, debugging, and testing.

## Requirements

- Neovim 0.11 or newer
- Git and a Nerd Font
- `ripgrep` for fast project search
- `curl` or `wget`, plus an archive extractor, for Mason
- The runtime/SDK for each language you use

| Language | Required host runtime |
| --- | --- |
| JavaScript / TypeScript | Node.js |
| Python | Python |
| Go | Go |
| Rust | Rust toolchain (`cargo`) |
| Java | JDK 17 or newer (`java` and `javac`) |
| C# | .NET SDK, not only the .NET runtime |
| PHP | PHP |
| C / C++ | A compiler such as GCC or Clang |
| Bash | Bash or another compatible POSIX shell |

## Install

Back up your current configuration and clone this repository to:

- Linux/macOS: `~/.config/nvim`
- Windows: `%LOCALAPPDATA%\nvim`

Start `nvim`. lazy.nvim installs plugins and Mason installs the declared
language tools in the background. Plugin versions are pinned in
`lazy-lock.json`; use `:Lazy update` only when intentionally upgrading.

Wait for both `:Lazy` and `:Mason` to finish on the first launch. Mason manages
language servers, formatters, linters, and debug adapters. It does not install
language runtimes such as a JDK or the .NET SDK.

Useful setup commands:

```vim
:Lazy
:Mason
:checkhealth
:ConfigHealth
:ConfigValidate
```

`ConfigHealth` distinguishes language servers and editor tools from host
runtimes. Mason can install the former; language runtimes and SDKs must be
installed by the operating system.

Executable paths are resolved through Neovim, so Mason's `.cmd` wrappers on
Windows and native executables on Linux use the same configuration.

## IDE capabilities

- NvChad explorer, Telescope search, buffers, terminals, Git signs and completion
- LSP navigation, rename, code actions, code lens and inlay hints
- Conform format-on-save with LSP fallback
- Debounced nvim-lint diagnostics
- Trouble workspace/buffer diagnostics and Aerial symbol outline
- Spectre project-wide search and replace
- Overseer task/build runner
- Persistence sessions per working directory
- Neogit status/commit workflow and Diffview history/diffs
- DAP UI, inline debug values, REPL and adapters for common languages
- Neotest discovery, output, summary and debug-nearest-test workflow
- Treesitter context and searchable TODO/FIXME annotations

## Keymaps

The leader key is `Space`. NvChad's standard mappings remain available.

| Key | Action |
| --- | --- |
| `<leader>ff` / `<leader>fw` | Find files / live grep |
| `<leader>sr` | Search and replace across project |
| `<leader>cs` | Toggle symbol outline |
| `<leader>xx` / `<leader>xX` | Workspace / buffer diagnostics |
| `[d` / `]d` | Previous / next diagnostic |
| `<leader>ih` | Toggle LSP inlay hints |
| `<leader>cl` | Run LSP code lens |
| `<leader>rr` / `<leader>rt` | Run task / toggle task list |
| `<leader>qs` / `<leader>ql` | Select session / restore last session |
| `<leader>gg` / `<leader>gc` | Git status / commit |
| `<leader>gd` / `<leader>gh` | Diff view / file history |
| `<F5>` | Start or continue debugging |
| `<F10>` / `<F11>` / `<F12>` | Step over / into / out |
| `<leader>db` / `<leader>dB` | Breakpoint / conditional breakpoint |
| `<leader>du` / `<leader>dr` | Debug UI / REPL |
| `<leader>tt` / `<leader>tf` | Test nearest / current file |
| `<leader>td` | Debug nearest test |
| `<leader>ts` / `<leader>to` | Test summary / output |

## Language coverage

| Language | LSP | Format/Lint | Debug | Test |
| --- | --- | --- | --- | --- |
| C / C++ | clangd | clang-format / cpplint | CodeLLDB | project task |
| Rust | rust-analyzer | rustfmt | CodeLLDB | cargo/neotest |
| Python | pyright | Ruff | debugpy | pytest/neotest |
| Go | gopls | gofmt | Delve/nvim-dap-go | go test/neotest |
| Java | jdtls | google-java-format | java-debug | JUnit/neotest |
| JS / TypeScript | ts_ls | Prettier / ESLint | vscode-js-debug | Jest/Vitest |
| Bash | bashls | shfmt / ShellCheck | bash-debug | project task |
| PHP | intelephense | php-cs-fixer | Xdebug | project task |
| C# | OmniSharp | CSharpier | netcoredbg | dotnet task |
| Lua | lua_ls | Stylua | - | project task |
| SQL | sqlls | sqlfluff | - | task |
| JSON / YAML / XML | dedicated LSP | formatter/linter | - | task |
| Docker / CMake / Markdown | dedicated LSP | formatter/linter | - | task |

## Project structure and extension rules

- `lua/plugins/init.lua` owns plugin declarations and lazy-loading keymaps.
- `lua/configs/` contains plugin behaviour, not duplicate plugin keymaps.
- `lua/mappings.lua` contains global mappings that do not load a plugin.
- `ftplugin/` contains language-specific startup logic such as Java/JDTLS.
- `lua/configs/health.lua` provides environment and integration validation.

When adding a plugin, declare its dependencies explicitly, give it a lazy-load
trigger (`event`, `cmd`, `ft`, or `keys`), and keep each keymap in exactly one
place. Add its module or command to `ConfigValidate` when it becomes part of the
core workflow. Avoid installing a second plugin that owns the same
responsibility; for example, this configuration intentionally enables only
`markdown-oxide` as the Markdown language server.

External packages under Neovim's `site/pack` are outside lazy.nvim's ownership
and can still conflict with this configuration. Run `:checkhealth lazy` and
remove old plugin-manager or Coc packages when they are no longer needed.

## Validation

After `:Lazy` has installed the pinned plugins, validate the complete plugin
graph from either Windows PowerShell or a Linux shell:

```sh
nvim --headless -i NONE "+ConfigValidate" +qa
```

Inside Neovim, `:ConfigValidate` performs the same check and `:ConfigHealth`
reports missing external tools and language runtimes. CI synchronizes pinned
plugins and runs `ConfigValidate` on both Windows and Linux. Mason background
installation is disabled only in CI, keeping validation independent of network
timing and optional language runtimes.
