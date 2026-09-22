# ⚡ Cross-Platform Neovim Configuration (LazyVim)

A modern, high-performance, and fully cross-platform Neovim configuration built on top of [LazyVim](https://github.com/LazyVim/LazyVim). Optimized for both **Windows** (via Scoop/Winget) and **Linux** (Arch Linux / Omarchy, Debian/Ubuntu, Fedora), featuring:

* 🚀 **Real-time Diagnostic Catching in Insert Mode**: Errors and warnings are analyzed and displayed live via virtual text as you type—no need to switch to Normal mode or save the file.
* 🛠️ **Pre-configured Polyglot Support**: Complete LSP, Treesitter, Formatter, Linter, and DAP Debugger setups for **C/C++, Java (JDTLS), Python, C#, Bash, Lua, Web (HTML/CSS/JS/TS), and CMake**.
* ⚡ **LazyVim Extras Pre-loaded**: Declarative extra loading in `lua/config/lazy.lua`—automatic setup upon cloning without touching `:LazyExtras`.
* 🪟 **Snacks.nvim Integrated**: Floating terminal (`<leader>ft`), lightning-fast picker (`<leader>ff`, `<leader>fg`), Lazygit (`<leader>gg`), and safe buffer deletion (`<leader>bd`).

---

## 📋 System Prerequisites

For Tree-sitter parser compilation, Fuzzy search, Mason tools, LSP servers, and Debuggers to work out-of-the-box, ensure the required CLI utilities are installed for your operating system.

### 🐧 Linux

#### 1. Arch Linux / Omarchy / EndeavourOS / Manjaro (`pacman`)
```bash
sudo pacman -S --needed \
  base-devel \
  neovim \
  git \
  curl \
  tar \
  ripgrep \
  fd \
  lazygit \
  fzf \
  zoxide \
  wl-clipboard \
  python \
  python-pip \
  jdk17-openjdk \
  nodejs \
  npm
```
> [!NOTE]
> * `wl-clipboard` is essential for Wayland (Hyprland, Sway, Omarchy, GNOME). If you are using **X11**, replace `wl-clipboard` with `xclip` or `xsel`.
> * `base-devel` provides `gcc` and `make` required by Treesitter to compile language parsers.

#### 2. Ubuntu / Debian / Pop!_OS / Linux Mint (`apt`)
```bash
# Update package repositories
sudo apt update

# Install build tools and dependencies
sudo apt install -y \
  build-essential \
  git \
  curl \
  tar \
  ripgrep \
  fd-find \
  fzf \
  zoxide \
  wl-clipboard \
  xclip \
  python3 \
  python3-pip \
  python3-venv \
  openjdk-17-jdk \
  nodejs \
  npm

# Symlink fdfind to fd (Debian/Ubuntu specific naming)
ln -sf $(which fdfind) ~/.local/bin/fd

# Install lazygit (Official Debian/Ubuntu repo or binary)
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit /usr/local/bin
rm -f lazygit lazygit.tar.gz
```

#### 3. Fedora / RHEL (`dnf`)
```bash
sudo dnf groupinstall -y "Development Tools"
sudo dnf install -y \
  neovim \
  git \
  curl \
  tar \
  ripgrep \
  fd-find \
  lazygit \
  fzf \
  zoxide \
  wl-clipboard \
  xclip \
  python3 \
  python3-pip \
  java-17-openjdk-devel \
  nodejs \
  npm
```

---

### 🪟 Windows

#### 1. Using Scoop (Recommended)
[Scoop](https://scoop.sh/) is the cleanest and most Unix-like package manager for Windows:

```powershell
# Add required buckets
scoop bucket add extras
scoop bucket add main

# Install all development dependencies
scoop install neovim mingw git curl tar ripgrep fd lazygit fzf zoxide win32yank python openjdk nodejs
```

> [!TIP]
> `mingw` provides `gcc`, which is required on Windows to compile Treesitter parsers and build native C/C++ components. `win32yank` enables seamless system clipboard integration.

#### 2. Using Winget (Windows Package Manager)
If you prefer Windows official `winget`:

```powershell
winget install --id Neovim.Neovim -e
winget install --id Git.Git -e
winget install --id BurntSushi.ripgrep.MSVC -e
winget install --id sharkdp.fd -e
winget install --id JesseDuffield.lazygit -e
winget install --id ajeetdsouza.zoxide -e
winget install --id junegunn.fzf -e
winget install --id equalsraf.win32yank -e
winget install --id Python.Python.3.13 -e
winget install --id Microsoft.OpenJDK.17 -e
winget install --id OpenJS.NodeJS.LTS -e
winget install --id MSYS2.MSYS2 -e # For MinGW / GCC C compiler
```

---

### 🔤 Recommended Nerd Font

For icons (file types, Git status, diagnostics, and UI elements) to render correctly, install and set a **Nerd Font** in your terminal (e.g. WezTerm, Ghostty, Kitty, Windows Terminal, Alacritty):

* **[JetBrainsMono Nerd Font](https://github.com/ryanoasis/nerd-fonts/releases)** *(Recommended)*
* **FiraCode Nerd Font**
* **GeistMono Nerd Font**

On Windows (Scoop):
```powershell
scoop bucket add nerd-fonts
scoop install JetBrainsMono-NF
```

On Arch Linux:
```bash
sudo pacman -S ttf-jetbrains-mono-nerd
```

---

## 📦 Installation & Setup

### 1. Clone the Configuration

#### On Linux / macOS:
```bash
git clone <YOUR-REPOSITORY-URL> ~/.config/nvim
```

#### On Windows (PowerShell):
```powershell
git clone <YOUR-REPOSITORY-URL> $env:LOCALAPPDATA\nvim
```

### 2. First Launch
Launch Neovim:
```bash
nvim
```

Neovim will automatically:
1. Bootstrap and download `lazy.nvim`.
2. Synchronize all core plugins and LazyVim Extras (`dap.core`, `lang.clangd`, `lang.java`, `lang.python`, `lang.json`).
3. Automatically install all language servers, debug adapters (`codelldb`, `debugpy`), and formatters via `Mason`.

---

## ⌨️ Useful Keybindings Quick Reference

### ⚡ General & Buffers
| Keybinding | Description |
|---|---|
| `<leader>w` or `<C-s>` | Save file |
| `<leader>q` | Quit Neovim |
| `<leader>wq` | Save and quit |
| `<Esc>` | Clear search highlighting |
| `<leader>bd` | Delete current buffer (layout-safe via `Snacks.bufdelete`) |
| `<S-h>` / `<S-l>` | Switch to previous / next buffer |
| `<C-Up/Down/Left/Right>` | Resize active window splits |
| `<leader>cf` / `<leader>fm` | Format document with Conform |
| `<leader>uf` | Toggle auto-formatting on/off for current buffer |

### 🔍 Snacks Picker & Navigation
| Keybinding | Description |
|---|---|
| `<leader>ff` | Find files (Fuzzy file search) |
| `<leader>fg` | Live Grep across workspace |
| `<leader>fb` | Open buffer list |
| `<leader>fr` | Recent files |
| `<leader>fe` | File explorer sidebar |
| `<leader>fz` | Jump to directory via Zoxide |
| `<leader>fp` | Projects picker |
| `<leader>ft` | Toggle Floating Terminal |
| `<leader>ft` | Toggle Floating Terminal (Snacks) |
| `<leader>uz` | Toggle Zen Mode |
| `<leader>.` | Open scratch buffer |

### 🖥️ Floaterm
| Keybinding | Description |
|---|---|
| `<leader>zt` | Toggle Floaterm terminal |
| `<leader>zo` | Create new Floaterm window |
| `<leader>zk` | Kill active Floaterm window |
| `<leader>zn` | Switch to next Floaterm window |
| `<leader>zp` | Switch to previous Floaterm window |


### 🐛 Debugging (DAP - C/C++, Python, Java)
| Keybinding | Description |
|---|---|
| `<F5>` | Start / Continue debugging |
| `<F9>` or `<leader>db` | Toggle breakpoint |
| `<F10>` | Step over |
| `<F11>` | Step into |
| `<S-F11>` | Step out |
| `<leader>dr` | Open DAP REPL |
| `<leader>dt` | Terminate debug session |

### 🌿 Git
| Keybinding | Description |
|---|---|
| `<leader>gg` | Open Lazygit popup |
| `<leader>gb` | Detailed Git blame for current line (Gitsigns) |
| `]g` / `[g` | Jump to next / previous Git hunk |
| `<leader>gs` | Stage current Git hunk |
| `<leader>gr` | Reset current Git hunk |
| `<leader>gp` | Preview current Git hunk diff |

---

## 🩺 Verifying Configuration Health

To verify your Neovim environment and diagnose any missing external dependencies, run inside Neovim:
```vim
:checkhealth
```
or from your shell:
```bash
nvim --headless "+checkhealth" "+w! health.txt" "+q" && cat health.txt
```
