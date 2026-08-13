local createAutocmd = vim.api.nvim_create_autocmd

-- Autostart Treesitter for syntax highlighting if current buffer is valid language or whatever
createAutocmd("FileType", {
  callback = function(args)
    if pcall(vim.treesitter.start, args.buf) then
      vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})

-- Disable auto comments
createAutocmd("FileType", {
  callback = function()
    vim.opt_local.formatoptions:remove({ "r", "o" })
  end,
})

-- Dynamic relative numbers
createAutocmd("InsertEnter", {
  callback = function()
    vim.opt.relativenumber = false
  end,
})
createAutocmd("InsertLeave", {
  callback = function()
    vim.opt.relativenumber = true
  end,
})

-- Highlight yanked text
createAutocmd("TextYankPost", {
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Wrap text in Markdown files
createAutocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
  end,
})
