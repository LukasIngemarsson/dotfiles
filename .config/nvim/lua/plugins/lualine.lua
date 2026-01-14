return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  init = function()
    vim.opt.cmdheight = 0
  end,
  config = function()
    local theme = require("lualine.themes.auto")

    for _, mode in pairs(theme) do
      if mode.c then
        mode.c.bg = "NONE"
      end
      if mode.x then
        mode.x.bg = "NONE"
      end
      if mode.y then
        mode.y.bg = "NONE"
      end
    end

    require("lualine").setup({
      options = {
        theme = theme,
        globalstatus = true,
        component_separators = "|",
        section_separators = "",
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { "filename" },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    })
  end,
}
