return {
  {
    "samoshkin/vim-mergetool",
    init = function()
      vim.g.mergetool_layout = "mr"
      vim.g.mergetool_prefer_revision = "local"
      vim.keymap.set("n", "<leader>mt", "<Plug>(MergetoolToggle)", {
        desc = "Git: Merge Tool Toggle",
        silent = true,
      })
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        add = { text = "✚" },
        change = { text = "✹" },
        delete = { text = "✖" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
      current_line_blame = false,
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, {
            buffer = bufnr,
            desc = desc,
          })
        end

        map("n", "]g", gs.next_hunk, "Git: Next Hunk")
        map("n", "[g", gs.prev_hunk, "Git: Previous Hunk")

        -- Thao tác hunk
        map("n", "<leader>gs", gs.stage_hunk, "Git: Stage Hunk")
        map("n", "<leader>gr", gs.reset_hunk, "Git: Reset Hunk")
        map("n", "<leader>gp", gs.preview_hunk, "Git: Preview Hunk")
        map("n", "<leader>gb", function()
          gs.blame_line({ full = true })
        end, "Git: Blame Line")
      end,
    },
  },
  {
    "airblade/vim-gitgutter",
    init = function()
      vim.g.gitgutter_sign_added = "✚"
      vim.g.gitgutter_sign_modified = "✹"
      vim.g.gitgutter_sign_removed = "✖"
      vim.g.gitgutter_preview_win_floating = 1
    end,
  },
}
