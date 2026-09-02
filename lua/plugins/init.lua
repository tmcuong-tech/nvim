return {
  -- =========================================================
  -- FORMATTER
  -- =========================================================

  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    opts = require("configs.conform"),
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
      -- Cross-platform tools only. Install ecosystem-specific tools with
      -- :Mason to avoid downloading large runtimes a machine does not use.
      ensure_installed = {
        "lua-language-server",
        "stylua",
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
        "shfmt",
        "debugpy",
        "codelldb",
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
      require("configs.lspconfig")
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
      require("configs.lint")
    end,
  },

  -- ========================================================
  -- DAP DEBUGING
  -- ========================================================
  {
    "mfussenegger/nvim-dap",
    keys = {
      { "<F5>", function() require("dap").continue() end, desc = "Debug: Continue" },
      { "<leader>du", function() require("dapui").toggle() end, desc = "Debug: Toggle UI" },
    },
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
    },
    config = function()
      require("configs.dap")
    end,
  },

  -- =======================================================
  -- TESTING
  -- =======================================================
  {
    "nvim-neotest/neotest",
    cmd = "Neotest",
    keys = {
      { "<leader>tt", function() require("neotest").run.run() end, desc = "Test: Run nearest" },
      { "<leader>tf", function() require("neotest").run.run(vim.fn.expand "%") end, desc = "Test: Run file" },
      { "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Test: Summary" },
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
      require("configs.neotest")
    end,
  },
}
