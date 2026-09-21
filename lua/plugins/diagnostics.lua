return {
  {
    "neovim/nvim-lspconfig",
    opts = function()
      vim.diagnostic.config({
        virtual_text = false,
        signs = true,
        underline = false,
        update_in_insert = true,
      })

      local signs = {
        Error = "✗",
        Warn = "▲",
        Hint = "󰌵",
        Info = "●",
      }

      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, {
          text = icon,
          texthl = hl,
          numhl = "",
        })
      end
    end,
  },
}
