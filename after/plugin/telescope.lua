local builtin = require('telescope.builtin')


-- Fuzzy find to include .config
vim.keymap.set('n', '<leader>ff', function()
  builtin.find_files({
    hidden = true,  -- include hidden files
    search_dirs = { vim.fn.expand("~/.config"), vim.fn.getcwd() }
  })
end, { desc = 'Telescope find files including .config' })



-- .TeX find
vim.keymap.set('n', '<leader>fn', function()
  builtin.find_files({
    find_command = { "fd", "--type", "f", "--extension", "tex" },
    search_dirs = { "~" },
    hidden = false,  -- include hidden files/directories
  })
end, { desc = 'System-wide .tex file search' })


-- Markdown Find
vim.keymap.set('n', '<leader>fm', function()
  builtin.find_files({
    find_command = { "fd", "--type", "f", "--extension", "md" },
    search_dirs = { vim.fn.expand("~/vaulty/") },  -- or use "/" for a system-wide search
    hidden = false,  -- include hidden files, if needed
  })
end, { desc = 'Obsidian Vault Markdown file search' })

-- Daily Notes Find
vim.keymap.set('n', '<leader>fm', function()
  builtin.find_files({
    find_command = { "fd", "--type", "f", "--extension", "md" },
    search_dirs = { vim.fn.expand("~/vaulty/dnotes") },  -- or use "/" for a system-wide search
    hidden = false,  -- include hidden files, if needed
  })
end, { desc = 'Daily Notes Markdown file search' })




--Standard Unaltered telescope keymaps
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })

vim.keymap.set('n', '<leader>of', builtin.oldfiles, { desc = 'Telescope old files' })
