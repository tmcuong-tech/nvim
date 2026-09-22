return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, {
          "c",
          "cpp",
          "python",
          "java",
          "c_sharp",
          "bash",
          "lua",
          "html",
          "css",
          "cmake",
          "markdown",
          "markdown_inline",
          "json",
          "yaml",
          "toml",
          "vim",
          "vimdoc",
          "query",
        })
      end
    end,
  },
}
