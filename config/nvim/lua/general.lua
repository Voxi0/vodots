-- Experimental Lua module loader using bytecode caching or whatever
vim.loader.enable()
local o = vim.opt

--------------------
--- Code folding ---
--------------------
o.foldenable = true
o.foldcolumn = "1"
o.foldlevel = 99
o.foldlevelstart = 99

----------------
-- Searching ---
----------------
-- Case insensitive search unless search includes an uppercase character
o.ignorecase = true
o.smartcase = true

-- Highlight search results
o.hlsearch = true

-- Show matches as you type
o.incsearch = true

---------------------
--- File handling ---
---------------------
o.backup = false
o.writebackup = false
o.swapfile = false
o.undofile = true
o.undodir = vim.fn.expand("~/.vim/undodir")
o.autoread = true
o.autowrite = false

-------------------
--- Performance ---
-------------------
-- Faster completion
o.updatetime = 300

---------------------
--- Miscellaneous ---
---------------------
-- Enable mouse support
o.mouse = "a"

-- Use system clipboard
o.clipboard:append("unnamedplus")

-- Spell checking
o.spell = true

-- We use Lualine instead so this is unnecessary
o.showmode = false

-- Ignore all of Neovim's builtin colours so they don't show up in a picker menu
o.wildignore:append({
	"default.*",
	"vim.*",
	"unokai.*",
	"blue.*",
	"darkblue.*",
	"delek.*",
	"desert.*",
	"elflord.*",
	"evening.*",
	"industry.*",
	"habamax.*",
	"koehler.*",
	"lunaperche.*",
	"morning.*",
	"murphy.*",
	"pablo.*",
	"peachpuff.*",
	"quiet.*",
	"ron.*",
	"shine.*",
	"slate.*",
	"sorbet.*",
	"retrobox.*",
	"torte.*",
	"wildcharm.*",
	"zaibatsu.*",
	"zellner.*",
	"catppuccin.*",
})

---------------------
--- Auto-commands ---
---------------------
local createAutoCmd = vim.api.nvim_create_autocmd

-- Dynamic relative numbers (like LazyVim)
createAutoCmd("InsertEnter", {
	callback = function()
		vim.opt.relativenumber = false
	end,
})
createAutoCmd("InsertLeave", {
	callback = function()
		vim.opt.relativenumber = true
	end,
})

-- Disable auto comments
createAutoCmd("FileType", {
	pattern = "*",
	callback = function()
		vim.opt_local.formatoptions:remove({ "r", "o" })
	end,
})

-- Highlight yanked text
createAutoCmd("TextYankPost", {
	callback = function()
		vim.hl.on_yank()
	end,
})

-- Wrap text in Markdown files
createAutoCmd("FileType", {
	pattern = "markdown",
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.linebreak = true
	end,
})

-- Open help page in a vertical split
createAutoCmd("FileType", {
	pattern = "help",
	callback = function()
		vim.cmd("wincmd L")
		vim.cmd("vert resize 90")
		vim.bo.bufhidden = "wipe"
		vim.keymap.set("n", "q", "<cmd>q<cr>", { buffer = true, silent = true })
	end,
})

-- Open man page in a new buffer tab or whatever
createAutoCmd("FileType", {
	pattern = "man",
	callback = function()
		vim.cmd("wincmd T")
		vim.bo.bufhidden = "wipe"
		vim.keymap.set("n", "q", "<cmd>q<cr>", { buffer = true, silent = true })
	end,
})
