-- Shift and tab
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.expandtab = true

-- Colors
vim.o.termguicolors = true

-- Hide default status bar
vim.opt.laststatus = 0

-- Line numbers
vim.o.relativenumber = true
vim.o.number = true

-- Mouse support
vim.o.mouse = "a"

-- Don't show mode (it's in statusline)
vim.o.showmode = false

-- Clipboard sync
vim.schedule(function()
  vim.o.clipboard = "unnamedplus"
end)

-- Indentation
vim.o.breakindent = true

-- Undo history
vim.o.undofile = true

-- Search
vim.o.ignorecase = true
vim.o.smartcase = true

-- UI
vim.o.signcolumn = "yes"
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.o.inccommand = "split"
vim.o.scrolloff = 10
vim.o.confirm = true
