return {
  { "nvim-mini/mini.base16", lazy = false, priority = 1000 },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = function()
        local ok = pcall(dofile, vim.fn.stdpath("config") .. "/matugen-colors.lua")
        if not ok then
          vim.cmd.colorscheme("tokyonight")
        end
      end,
    },
  },
}
