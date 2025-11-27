local M = {}

function M.setup()
  require('nvim-treesitter.configs').setup({
    ensure_installed = {
      "lua",
      "javascript",
      "typescript",
      "rust",
      "c_sharp",
      "gdscript",
      "go",
      "python"
    },
    highlight = {
      enable = true,
    },
  })
end

return M
