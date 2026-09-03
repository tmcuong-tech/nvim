# Neovim config by tmcuong

A cross-platform Neovim configuration for Windows and Linux with native LSP,
code completion, diagnostics, formatting, build/run commands, Git integration,
and debugging through Vimspector.

## Requirements

### Required

- [Neovim](https://neovim.io/) 0.11.3 or newer
- [VimPlug](https://github.com/junegunn/vim-plug)
- [Git](https://git-scm.com/)
- [JetBrainsMono Nerd Font](https://www.nerdfonts.com/font-downloads)
- [ripgrep](https://github.com/BurntSushi/ripgrep) for fast file-content search
- Python 3 with the `pynvim` package
- Node.js 20 or newer
- Java Development Kit (JDK)
- CMake
- Ninja or Make
- `curl` or `wget`, plus `tar`, `gzip`, and `unzip` for Mason
- A C/C++ compiler:
  - Windows: MinGW-w64/GCC, LLVM/Clang, or Visual Studio Build Tools
  - Linux: GCC or LLVM/Clang
- `clangd` for C/C++ language support
- `gdb` or `lldb` for C/C++ debugging


Mason installs the configured language servers, formatters, and debug adapters.
It does not install compilers, language runtimes, CMake, Git, or system build
tools.

### Optional language toolchains

- Go for Go development and Delve debugging
- Rust and Cargo for Rust development
- `tsx` or `ts-node` for running TypeScript files directly
- `bash` for shell scripts on Windows

