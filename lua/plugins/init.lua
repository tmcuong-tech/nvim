-- Author:
--
--     ████████╗███╗   ███╗ ██████╗██╗   ██╗ ██████╗ ███╗   ██╗ ██████╗
--     ╚══██╔══╝████╗ ████║██╔════╝██║   ██║██╔═══██╗████╗  ██║██╔════╝
--        ██║   ██╔████╔██║██║     ██║   ██║██║   ██║██╔██╗ ██║██║  ███╗
--        ██║   ██║╚██╔╝██║██║     ██║   ██║██║   ██║██║╚██╗██║██║   ██║
--        ██║   ██║ ╚═╝ ██║╚██████╗╚██████╔╝╚██████╔╝██║ ╚████║╚██████╔╝
--        ╚═╝   ╚═╝     ╚═╝ ╚═════╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═══╝ ╚═════╝
--
--
-- github.com/tmcuong-tech
--

return {
  -- FORMATTER
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
        "eslint_d",
        "shellcheck",
        "hadolint",
        "sqlfluff",
        "delve",
        "js-debug-adapter",
        "netcoredbg",
        "php-debug-adapter",
        "bash-debug-adapter",
        "java-debug-adapter",
        "java-test",
        "php-cs-fixer",
        "csharpier",
        "xmlformatter",
      },
      auto_update = false,
      -- CI and offline sessions can disable background installation without
      -- changing the normal first-run experience.
      run_on_start = vim.env.NVIM_DISABLE_MASON_AUTO_INSTALL ~= "1",
      start_delay = 3000,
      debounce_hours = 24,
    },
  },

  -- LSP
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  {
    "mfussenegger/nvim-jdtls",
    ft = "java",
  },

  -- COMPLETION
  {
    import = "nvchad.blink.lazyspec",
  },

  -- TREESITTER
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

  -- LINTING
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require "configs.lint"
    end,
  },

  -- DAP DEBUGING
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
      {
        "<leader>dc",
        function()
          require("dap").run_to_cursor()
        end,
        desc = "Debug: Run to cursor",
      },
      {
        "<leader>dl",
        function()
          require("dap").run_last()
        end,
        desc = "Debug: Run last",
      },
      {
        "<leader>dr",
        function()
          require("dap").repl.toggle()
        end,
        desc = "Debug: Toggle REPL",
      },
      {
        "<leader>dt",
        function()
          require("dap").terminate()
        end,
        desc = "Debug: Terminate",
      },
      {
        "<leader>de",
        function()
          require("dapui").eval()
        end,
        mode = { "n", "v" },
        desc = "Debug: Evaluate expression",
      },
    },
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      {
        "theHamsta/nvim-dap-virtual-text",
        opts = {},
      },
    },
    config = function()
      require "configs.dap"
    end,
  },

  -- TESTING
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
      {
        "<leader>td",
        function()
          require("neotest").run.run { strategy = "dap" }
        end,
        desc = "Test: Debug nearest",
      },
    },
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",

      "nvim-neotest/neotest-python",
      "fredrikaverpil/neotest-golang",
      "rcasia/neotest-java",
      "nvim-neotest/neotest-jest",
      "marilari88/neotest-vitest",
      "rouge8/neotest-rust",
    },

    config = function()
      require "configs.neotest"
    end,
  },

  {
    "leoluz/nvim-dap-go",
    ft = "go",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      require("dap-go").setup()
    end,
  },

  -- DIAGNOSTICS AND CODE NAVIGATION
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    opts = { focus = true },
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics: Workspace" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Diagnostics: Buffer" },
      { "<leader>xs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Symbols: Trouble" },
      { "<leader>xq", "<cmd>Trouble qflist toggle<cr>", desc = "Diagnostics: Quickfix" },
    },
  },

  {
    "stevearc/aerial.nvim",
    cmd = { "AerialOpen", "AerialToggle", "AerialNavToggle" },
    opts = {
      backends = { "lsp", "treesitter", "markdown", "man" },
      layout = { default_direction = "prefer_right", min_width = 30 },
      show_guides = true,
    },
    keys = {
      { "<leader>cs", "<cmd>AerialToggle!<cr>", desc = "Symbols: Outline" },
      { "[s", "<cmd>AerialPrev<cr>", desc = "Symbols: Previous" },
      { "]s", "<cmd>AerialNext<cr>", desc = "Symbols: Next" },
    },
  },

  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "VeryLazy",
    opts = { max_lines = 3 },
    keys = {
      { "<leader>uc", "<cmd>TSContext toggle<cr>", desc = "UI: Toggle code context" },
    },
  },

  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    opts = {
      notification = { window = { winblend = 0 } },
    },
  },

  -- PROJECT SEARCH, TASKS, AND SESSIONS
  {
    "nvim-pack/nvim-spectre",
    cmd = "Spectre",
    opts = {},
    keys = {
      { "<leader>sr", "<cmd>Spectre<cr>", desc = "Search: Replace in project" },
      {
        "<leader>sw",
        function()
          require("spectre").open_visual { select_word = true }
        end,
        desc = "Search: Replace current word",
      },
      {
        "<leader>sw",
        function()
          require("spectre").open_visual()
        end,
        mode = "v",
        desc = "Search: Replace selection",
      },
    },
  },

  {
    "stevearc/overseer.nvim",
    cmd = { "OverseerRun", "OverseerToggle", "OverseerQuickAction", "OverseerTaskAction" },
    opts = {
      task_list = { direction = "bottom", min_height = 15, max_height = 25 },
    },
    keys = {
      { "<leader>rr", "<cmd>OverseerRun<cr>", desc = "Tasks: Run" },
      { "<leader>rt", "<cmd>OverseerToggle<cr>", desc = "Tasks: Toggle list" },
      { "<leader>ra", "<cmd>OverseerTaskAction<cr>", desc = "Tasks: Action" },
    },
  },

  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {},
    keys = {
      {
        "<leader>qs",
        function()
          require("persistence").select()
        end,
        desc = "Session: Select",
      },
      {
        "<leader>ql",
        function()
          require("persistence").load { last = true }
        end,
        desc = "Session: Restore last",
      },
      {
        "<leader>qd",
        function()
          require("persistence").stop()
        end,
        desc = "Session: Do not save",
      },
    },
  },

  -- GIT WORKFLOW
  {
    "NeogitOrg/neogit",
    cmd = "Neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "nvim-telescope/telescope.nvim",
    },
    opts = { kind = "split" },
    keys = {
      { "<leader>gg", "<cmd>Neogit<cr>", desc = "Git: Status" },
      { "<leader>gc", "<cmd>Neogit commit<cr>", desc = "Git: Commit" },
    },
  },

  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Git: Diff view" },
      { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "Git: File history" },
    },
  },

  {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
    keys = {
      { "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Search: TODO comments" },
      {
        "]t",
        function()
          require("todo-comments").jump_next()
        end,
        desc = "TODO: Next",
      },
      {
        "[t",
        function()
          require("todo-comments").jump_prev()
        end,
        desc = "TODO: Previous",
      },
    },
  },
}
