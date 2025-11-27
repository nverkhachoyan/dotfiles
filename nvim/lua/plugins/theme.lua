local M = {}

-- Global variable to track current theme mode
vim.g.theme_mode = vim.g.theme_mode or "dark" -- Default to dark theme

function M.setup()
  require("catppuccin").setup({
    flavour = vim.g.theme_mode == "dark" and "mocha" or "latte",
    background = {
      light = "latte",
      dark = "mocha",
    },
    transparent_background = vim.g.theme_mode == "dark", -- Only transparent in dark mode
    color_overrides = {
      mocha = { -- Dark theme overrides
        base = "#202328",
        text = "#bbc2cf",
        blue = "#51afef",
        red = "#ec5f67",
        green = "#98be65",
        yellow = "#ECBE7B",
        magenta = "#c678dd",
      },
      latte = { -- Light theme overrides
        base = "#F6FFF8",
        text = "#575f66",
        blue = "#2e7de9",
        red = "#f14c4c",
        green = "#5d9d4e",
        yellow = "#da8e1d",
        magenta = "#9f4796",
      },
    },
  })
  vim.cmd.colorscheme "catppuccin"
end

-- Function to toggle between light and dark themes
function M.toggle_theme()
  vim.g.theme_mode = vim.g.theme_mode == "dark" and "light" or "dark"
  M.setup() -- Reapply theme settings
  
  -- Notify the user about the current theme
  local message = "Theme switched to " .. vim.g.theme_mode .. " mode"
  vim.notify(message, vim.log.levels.INFO)
end

return M
