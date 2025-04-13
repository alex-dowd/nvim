return{
	{
	"nvim-treesitter/nvim-treesitter",
	enabled = false,
	diable = { "latex", "bibtex", "tex" },
	build = ":TSUpdate",
	config = function () 
      		local configs = require("nvim-treesitter.configs")

      		configs.setup({
          		ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "elixir", "heex", "javascript", "html", "latex", "markdown", "bibtex" },
         		sync_install = false,
			highlight = { enable = true },
        		indent = { enable = true },  
        			})
    		end
	}
}
