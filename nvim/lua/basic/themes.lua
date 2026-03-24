return{
  {
    "catppuccin/nvim",
    lazy = true,
    commit = "a778841", -- 这里使用最新的commit 而不是使用 stable
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavour = "auto", -- latte, frappe, macchiato, mocha
      transparent = true,
      background = { -- :h background
        light = "latte",
        dark = "mocha",
      },
      transparent_background = true, -- disables setting the background color.
      float = {
        transparent = true, -- enable transparent floating windows
        solid = false, -- use solid styling for floating windows, see |winborder|
      },
    },
  },
    -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  }
}
-- return {
--   {
--     "folke/tokyonight.nvim",
--     opts = {
--       style = "night",
--       lualine_bold = true,
--       transparent = true,
--       styles = {
--         sidebars = "transparent",
--         floats = "transparent",
--       },
--     },
--   },
-- }
