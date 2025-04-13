return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",  -- use the latest stable branch of neo-tree
    enabled = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended for icons
      "MunifTanjim/nui.nvim",
      -- Optional: {"3rd/image.nvim", opts = {}}, -- For image preview support (if desired)
    },
    lazy = false,  -- set to false to load neo-tree at startup (adjust as needed)
    opts = {
      -- Add any neo-tree configuration options here
      filesystem = {
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = true,
        },
      },
    },
    config = function()
      -- This function runs after the plugin is loaded.
      require("neo-tree").setup({
        -- You can add additional configuration options here.
      })
      -- Example keymap: Toggle neo-tree with <leader>e
      vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle<CR>", { desc = "Toggle Neo-tree" })
    end,
  },
}

