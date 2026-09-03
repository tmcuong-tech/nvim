# Neovim config by tmcuong

Cấu hình dùng `vim-plug`, Coc và native LSP, có thể chạy trên Windows, Linux và macOS. `vim-plug` cùng các plugin còn thiếu được cài tự động trong lần khởi động đầu tiên.

## Yêu cầu cơ bản

- Neovim 0.11.3 trở lên.
- Git.
- Node.js 18 trở lên cho `coc.nvim` và các Coc extension.
- [Nerd Font](https://www.nerdfonts.com/) để hiển thị icon đúng.
- `ripgrep` (`rg`) được khuyến nghị cho tìm kiếm nhanh bằng `:Rg`/`F7`; cấu hình vẫn khởi động nếu thiếu.

Mason cần thêm các công cụ giải nén:

- Windows: PowerShell hoặc `pwsh`, GNU tar và 7-Zip (hoặc trình giải nén tương đương).
- Linux/macOS: `curl` hoặc `wget`, `unzip`, `tar` và `gzip`.

Các runtime theo ngôn ngữ là tùy chọn: Go cho `gopls`, Rust/Cargo cho `asm-lsp`, JDK cho Java và Python cho dự án Python. Thiếu runtime tùy chọn sẽ không làm Neovim lỗi khi khởi động.

## Cài đặt

Sao lưu cấu hình hiện tại trước khi clone.

### Windows PowerShell

```powershell
Move-Item $env:LOCALAPPDATA\nvim $env:LOCALAPPDATA\nvim.bak -ErrorAction SilentlyContinue
git clone https://github.com/tmcuong-tech/dotfile.git $env:LOCALAPPDATA\nvim
nvim
```

### Linux/macOS

```sh
mv ~/.config/nvim ~/.config/nvim.bak 2>/dev/null || true
git clone https://github.com/tmcuong-tech/dotfile.git ~/.config/nvim
nvim
```

Lần chạy đầu cần kết nối mạng. Nếu cài tự động bị gián đoạn, chạy:

```vim
:PlugInstall
:CocUpdateSync
:Mason
```

## LSP và completion

| Ngôn ngữ | Client |
| --- | --- |
| C/C++ | Coc + clangd |
| Python | Coc + Pyright |
| Java | Coc + JDT LS |
| Rust | Coc + rust-analyzer |
| Bash, JSON, CSS, HTML, Vim, TypeScript/JavaScript, CMake, YAML, Svelte | Coc |
| Lua | native LSP + lua-language-server |
| Go | native LSP + gopls |
| Assembly | native LSP + asm-lsp |

Mason tự cài `lua-language-server`. `gopls` chỉ được yêu cầu khi máy có Go. Trên Linux/macOS, `asm-lsp` chỉ được yêu cầu khi có Cargo.

Trên Windows, Mason có thể yêu cầu Visual C++ `link.exe` để build `asm-lsp`. Có thể tránh Visual Studio Build Tools bằng Rust GNU + GCC:

```powershell
rustup toolchain install stable-x86_64-pc-windows-gnu --profile minimal
cargo +stable-x86_64-pc-windows-gnu install asm-lsp --locked
```

Đảm bảo thư mục Cargo `bin` nằm trong `PATH`, sau đó khởi động lại Neovim.

## Kiểm tra sau khi cài

```vim
:PlugStatus
:CocInfo
:checkhealth vim.lsp
:checkhealth mason
```

Các phím thường dùng:

- `F5`: bật/tắt NERDTree.
- `F6`: tìm file.
- `F7`: tìm nội dung bằng ripgrep.
- `Space t t`: bật/tắt Floaterm.
- `gd`, `gr`, `K`: definition, references và hover.
