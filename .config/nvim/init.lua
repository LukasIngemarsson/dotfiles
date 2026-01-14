-- Set leader keys FIRST
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true

-- Load core configuration
require("options")
require("keymaps")
require("lazy_bootstrap")
require("lazy_plugins")
