-- Experimental Lua module loader using bytecode caching or whatever
vim.loader.enable()

-- Use a `.editorconfig` file to figure out how indentation stuff if possible
vim.g.editorconfig = true

-- Configure Neovim's builtin file explorer
for key, value in pairs({
  netrw_liststyle = 3, -- Tree-view e.g. like `nvim-tree`
  netrw_banner = 0, -- Hide the top banner
  netrw_winsize = 25, -- Width of the split which Netrw will use
  netrw_browse_split = 0, -- Open files in the previous window
  netrw_altfile = 1, -- Keep the alternate file correct
}) do
  vim.g[key] = value
end

for key, value in pairs({
  -- Line numbering
  number = true,
  relativenumber = true,

  -- Indentation
  expandtab = true, -- Spaces instead of tabs
  shiftwidth = 4, -- Number of spaces to use for each step of autoindent
  tabstop = 4, -- Number of spaces in a tab
  softtabstop = 4, -- Controls how `<Tab>` and `<BS>` behave in Insert mode
  autoindent = true, -- Copies the current line’s indentation when you start a new line.
  smartindent = false,
  cindent = false,

  -- Code folding
  foldenable = true,
  foldlevel = 99, -- Keep all folds open by default when entering a file
  foldlevelstart = 99,
  foldcolumn = "1", -- Small 1 column margin for fold icons

  -- Disable text wrapping
  wrap = false,

  -- Searching
  ignorecase = true,
  smartcase = true, -- Case insensitive search until it includes an uppercase character
  incsearch = true,

  -- File handling
  backup = false,
  writebackup = false,
  swapfile = false,
  undofile = true,
  undodir = vim.fn.expand("~/.nvim/undodir"),
  autoread = true,
  autowrite = false,

  -- Misc
  clipboard = "unnamedplus", -- Use system clipboard
  spell = true, -- Spellchecking
  mouse = "a", -- Enable full mouse support
  updatetime = 250, -- How long Neovim waits during activity before certain events fire
}) do
  vim.opt[key] = value
end
