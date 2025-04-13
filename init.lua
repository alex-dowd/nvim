require("config.lazy")
require('config.lualine-config')
vim.opt.number = true          -- Show absolute line number for the current line
vim.opt.relativenumber = true  -- Show relative line numbers for all other lines
vim.cmd("colorscheme pywal")
vim.o.background = "dark"
-- Oil Commands
	vim.keymap.set("n", "<leader>e", ":Oil<CR>", { desc = "Open Oil file explorer" })
	-- Define the custom command to open the "figures" directory
	vim.api.nvim_create_user_command("OilFigures", function()
	  require("oil").open("figures")
	end, { desc = "Open Oil in the figures directory" })

	-- Map <leader>i to execute the :OilFigures command
	vim.keymap.set("n", "<leader>i", ":OilFigures<CR>", { desc = "Open figures directory via Oil" })


--Obsidian Conceal level.
		vim.api.nvim_create_autocmd("FileType", {
		  pattern = "markdown",
		  callback = function()
		    vim.opt_local.conceallevel = 2
		  end,
		})



--Obsidian dailynotes
	-- Toggle state to store buffer numbers
	local toggle_state = {
	  last_daily_buf = nil,
	  last_prev_buf = nil,
	}

	-- Function to jump to the "## to-do" line once the buffer is displayed.
	local function jump_to_todo_autocmd()
	  local lnum = vim.fn.search("## to-do", "W")  -- Search without wrapping
	  if lnum > 0 then
	    vim.api.nvim_win_set_cursor(0, { lnum, 0 })
	    vim.cmd("normal! zt")  -- Scroll so that the line is at the top
	  else
	    print("Pattern '## to-do' not found!")
	  end
	  vim.cmd("nohlsearch")
	end

	-- Function to open the daily note (with offset) and jump to "## to-do"
	local function open_daily_note_to_todo(offset)
	  if offset == 0 then
	    vim.cmd("ObsidianToday")
	  else
	    vim.cmd("ObsidianToday " .. offset)
	  end
	  -- Set an autocommand to jump to "## to-do" once the buffer window is entered.
	  vim.api.nvim_create_autocmd("BufWinEnter", {
	    pattern = "*.md",
	    callback = jump_to_todo_autocmd,
	    once = true,
	  })
	end

	-- Toggle function: if we're on the daily note, jump back to the previous buffer;
	-- otherwise, store the current buffer as previous and open the daily note.
	local function toggle_daily_note(offset)
	  local current_buf = vim.api.nvim_get_current_buf()
	  if toggle_state.last_daily_buf and current_buf == toggle_state.last_daily_buf then
	    -- We're already in the daily note: switch back to the previous buffer if it exists.
	    if toggle_state.last_prev_buf and vim.api.nvim_buf_is_valid(toggle_state.last_prev_buf) then
	      vim.cmd("buffer " .. toggle_state.last_prev_buf)
	    else
	      print("No previous buffer found!")
	    end
	    return
	  end

	  -- Save the current buffer as the previous one.
	  toggle_state.last_prev_buf = current_buf

	  -- Open the desired daily note (today, tomorrow, or yesterday) and jump to "## to-do".
	  open_daily_note_to_todo(offset)

	  -- Schedule updating the last_daily_buf after the note is loaded.
	  vim.schedule(function()
	    toggle_state.last_daily_buf = vim.api.nvim_get_current_buf()
	  end)
	end

	-- Key mappings:
	vim.keymap.set("n", "<leader>oo", function()
	  toggle_daily_note(0)
	end, { noremap = true, silent = true, desc = "Toggle today's note" })

	vim.keymap.set("n", "<leader>ot", function()
	  toggle_daily_note(1)
	end, { noremap = true, silent = true, desc = "Toggle tomorrow's note" })

	vim.keymap.set("n", "<leader>oy", function()
	  toggle_daily_note(-1)
	end, { noremap = true, silent = true, desc = "Toggle yesterday's note" })





--INKSCAPE FIGURES SUPPORT
local function inkscape_create_and_replace()
  -- 1. Capture the current line content.
  local oldline = vim.api.nvim_get_current_line()
  -- Clear the current line without affecting following lines.
  vim.api.nvim_set_current_line("")

  -- Ensure VimTeX is loaded and the root directory is available.
  if not vim.b.vimtex or not vim.b.vimtex.root then
    print("VimTeX is not initialized. Open a TeX file first.")
    return
  end

  local figures_dir = vim.b.vimtex.root .. "/figures/"

  -- 2. Launch the file watcher asynchronously so Inkscape can open.
  local jobid = vim.fn.jobstart({"inkscape-figures", "watch"}, {detach = true})
  if jobid < 0 then
    vim.notify("Failed to start file watcher with jobstart. Falling back to system call.", vim.log.levels.ERROR)
    vim.fn.system("inkscape-figures watch &")
  end

  -- 3. Pause briefly (300ms) to allow the watcher/Inkscape to initialize.
  vim.wait(300, function() return true end)

  -- 4. Run the create command and capture multi-line output.
  local output = vim.fn.systemlist("inkscape-figures create \"" .. oldline .. "\" \"" .. figures_dir .. "\"")

  -- 5. Replace the current (now empty) line with the first line of output.
  if #output > 0 then
    vim.api.nvim_set_current_line(output[1])
  end

  -- 6. Append any additional lines below.
  if #output > 1 then
    vim.api.nvim_buf_set_lines(0, vim.fn.line('.'), vim.fn.line('.'), false, vim.list_slice(output, 2))
  end

  -- 7. Write the file immediately.
  vim.cmd("write")

  -- 8. Append a new empty line after the inserted snippet.
  local last_line = vim.fn.line('.') + #output - 1
  vim.api.nvim_buf_set_lines(0, last_line, last_line, false, {""})

  -- 9. Move the cursor to the new empty line (column 1) in normal mode.
  vim.api.nvim_win_set_cursor(0, {last_line + 1, 0})
end

-- Normal Mode Mapping - Edit Existing Figure
vim.keymap.set("n", "<C-f>", function()
  if vim.b.vimtex and vim.b.vimtex.root then
    vim.cmd('silent exec "!inkscape-figures edit \\"' .. vim.b.vimtex.root .. '/figures/\\" > /dev/null 2>&1 &"')
    vim.cmd("redraw!")
  else
    print("VimTeX is not initialized. Open a TeX file first.")
  end
end, { silent = true, noremap = true })

-- Insert Mode Mapping - Create & Replace Figure
vim.keymap.set("i", "<C-f>", function() inkscape_create_and_replace() end, { noremap = true })

-- END FIGURES SUPPORT
