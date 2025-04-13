return {
  "epwalsh/obsidian.nvim",
  version = "*",  -- recommended, use latest release instead of latest commit
  lazy = false,
  ft = "markdown",
  -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
  -- event = {
  --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
  --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
  --   -- refer to `:h file-pattern` for more examples
  --   "BufReadPre path/to/my-vault/*.md",
  --   "BufNewFile path/to/my-vault/*.md",
  -- },
  dependencies = {
    -- Required.
    "nvim-lua/plenary.nvim",

    -- see below for full list of optional dependencies 👇
  },
  opts = {
    workspaces = {
      {
        name = "vaulty",
        path = "~/vaulty",
      },
      --[[
      --{
        name = "work",
        path = "~/vaults/work",
      },--]]
    },








	templates = {
	    folder = "templates",  -- A folder named "templates" inside ~/vaulty
	            },

	daily_notes = {
	    -- Optional, if you keep daily notes in a separate directory.
	    folder = "dnotes",
	    -- Optional, if you want to change the date format for the ID of daily notes.
	    date_format = "%y%m%d - %A",
	    alias_format = "%y%m%d",
	        -- Optional, default tags to add to each new daily note created.
    	    default_tags = { "dnotes" },
	    -- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
	    template = "/home/ad/vaulty/templates/daily.md",
  			},

  },
}
