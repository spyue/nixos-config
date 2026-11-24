return {
  -- Language servers for HTML and CSS, plus Emmet
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        html = {},
        cssls = {},
        emmet_language_server = {},
      },
    },
  },

  -- Syntax highlighting for web languages
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "html", "css", "javascript" },
    },
  },
}
