return {
  -- =========================================================
  -- FORMATTER
  -- =========================================================

  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    opts = require "configs.conform",
  },

  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonUpdate" },
    opts = {
      ui = { border = "rounded" },
    },
  },

  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
    event = "VeryLazy",
    opts = {
      -- Keep every configured server/tool declared here so a fresh machine
      -- converges to the same environment. Language runtimes remain external.
      ensure_installed = {
        "lua-language-server",
        "stylua",
        "html-lsp",
        "css-lsp",
        "bash-language-server",
        "clangd",
        "clang-format",
        "pyright",
        "ruff",
        "typescript-language-server",
        "prettier",
        "json-lsp",
        "yaml-language-server",
        "dockerfile-language-server",
        "docker-compose-language-service",
        "marksman",
        "markdown-oxide",
        "shfmt",
        "debugpy",
        "codelldb",
        "gopls",
        "rust-analyzer",
        "jdtls",
        "google-java-format",
        "intelephense",
        "sqlls",
        "lemminx",
        "cmake-language-server",
        "cmakelang",
        "omnisharp",
        "autotools-language-server",
        "yamlfmt",
        "yamllint",
        "asmfmt",
        "cpplint",
        "cmakelint",
        "markdownlint",
      },
      auto_update = false,
      run_on_start = true,
      start_delay = 3000,
      debounce_hours = 24,
    },
  },

  -- =========================================================
  -- LSP
  -- =========================================================

  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  -- =========================================================
  -- COMPLETION
  -- =========================================================

  {
    import = "nvchad.blink.lazyspec",
  },

  -- =========================================================
  -- TREESITTER
  -- =========================================================

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        -- Vim / Neovim
        "vim",
        "vimdoc",
        "query",
        "lua",

        -- Web
        "html",
        "css",
        "javascript",
        "typescript",
        "tsx",

        -- C / C++
        "c",
        "cpp",

        -- Python
        "python",

        -- Rust
        "rust",

        -- Go
        "go",

        -- Java
        "java",

        -- Shell
        "bash",

        -- Assembly
        "asm",

        -- PHP
        "php",

        -- SQL
        "sql",

        -- JSON / YAML / XML
        "json",
        "yaml",
        "xml",

        -- Docker
        "dockerfile",

        -- CMake
        "cmake",

        -- Markdown
        "markdown",
        "markdown_inline",

        -- Git
        "git_config",
        "git_rebase",
        "gitcommit",
        "gitignore",
        "gitattributes",
      },
    },
  },

  -- =========================================================
  -- LINTING
  -- =========================================================
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require "configs.lint"
    end,
  },

  -- ========================================================
  -- DAP DEBUGING
  -- ========================================================
  {
    "mfussenegger/nvim-dap",
    keys = {
      {
        "<F5>",
        function()
          require("dap").continue()
        end,
        desc = "Debug: Continue",
      },
      {
        "<F10>",
        function()
          require("dap").step_over()
        end,
        desc = "Debug: Step Over",
      },
      {
        "<F11>",
        function()
          require("dap").step_into()
        end,
        desc = "Debug: Step Into",
      },
      {
        "<F12>",
        function()
          require("dap").step_out()
        end,
        desc = "Debug: Step Out",
      },
      {
        "<leader>db",
        function()
          require("dap").toggle_breakpoint()
        end,
        desc = "Debug: Toggle Breakpoint",
      },
      {
        "<leader>dB",
        function()
          require("dap").set_breakpoint(vim.fn.input "Breakpoint condition: ")
        end,
        desc = "Debug: Conditional Breakpoint",
      },
      {
        "<leader>du",
        function()
          require("dapui").toggle()
        end,
        desc = "Debug: Toggle UI",
      },
    },
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
    },
    config = function()
      require "configs.dap"
    end,
  },

  -- =======================================================
  -- TESTING
  -- =======================================================
  {
    "nvim-neotest/neotest",
    cmd = "Neotest",
    keys = {
      {
        "<leader>tt",
        function()
          require("neotest").run.run()
        end,
        desc = "Test: Run nearest",
      },
      {
        "<leader>tf",
        function()
          require("neotest").run.run(vim.fn.expand "%")
        end,
        desc = "Test: Run file",
      },
      {
        "<leader>tS",
        function()
          require("neotest").run.stop()
        end,
        desc = "Test: Stop",
      },
      {
        "<leader>ts",
        function()
          require("neotest").summary.toggle()
        end,
        desc = "Test: Summary",
      },
      {
        "<leader>to",
        function()
          require("neotest").output.open { enter = true }
        end,
        desc = "Test: Output",
      },
    },
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",

      "nvim-neotest/neotest-python",
      "fredrikaverpil/neotest-golang",
      "rcasia/neotest-java",
    },

    config = function()
      require "configs.neotest"
    end,
  },
}
