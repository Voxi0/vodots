o = vim.opt

--------------
-- Visuals ---
--------------
o.termguicolors = true

-- Line numbering
o.number = true
o.relativenumber = true

-- Keep 10 lines above/below the cursor and 8 columns left/right of the cursor
o.scrolloff = 12
o.sidescrolloff = 8

-- No text wrapping around the screen
o.wrap = false

-- Hide the command line when not being used
o.cmdheight = 0
o.showcmd = false
o.showmode = false
o.ruler = false

-- Always show signcolumn so the text doesn't shift whenever you start/stop typing
o.signcolumn = "yes"

-- Window borders
o.winborder = "rounded"
