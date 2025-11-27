local M = {}
function M.setup()
  local nvim_tree = require("nvim-tree")
  local map = vim.keymap.set

  -- Improved keymaps with better descriptions
  map('n', '<C-n>', ':NvimTreeToggle<CR>', { noremap = true, silent = true, desc = "Toggle NvimTree" })
  map('n', '<leader>nf', ':NvimTreeFindFile<CR>', { noremap = true, silent = true, desc = "Find current file in tree" })
  map('n', '<leader>nr', ':NvimTreeRefresh<CR>', { noremap = true, silent = true, desc = "Refresh NvimTree" })
  -- New keymap to focus the tree (without toggle)
  map('n', '<leader>nt', ':NvimTreeFocus<CR>', { noremap = true, silent = true, desc = "Focus NvimTree" })

  -- Add proper file preview
  local api = require("nvim-tree.api")
  local function preview_file()
    local node = api.tree.get_node_under_cursor()
    if node and node.absolute_path and not node.open then
      -- Open a preview window with the file
      vim.cmd("silent! pclose") -- Close any existing preview
      vim.cmd("silent! pedit " .. vim.fn.fnameescape(node.absolute_path))
    end
  end
  map('n', '<leader>np', preview_file, { noremap = true, silent = true, desc = "Preview file contents" })

  nvim_tree.setup({
    sort_by = "case_sensitive",
    view = {
      width = 30,
      adaptive_size = true, -- Change to true for dynamic width
      float = {
        enable = true,      -- Enable floating window mode
        quit_on_focus_loss = true,
        open_win_config = {
          relative = "editor",
          border = "rounded",
          width = 30,
          height = 30,
          row = 1,
          col = 1,
        },
      },
      side = "left", -- Can be changed to "right" if preferred
    },
    renderer = {
      group_empty = true,
      highlight_git = true,              -- Better git status visibility
      highlight_opened_files = "name",   -- Highlight open files
      root_folder_label = ":~:s?$?/..?", -- Better root folder display
      indent_markers = {
        enable = true,                   -- Enable indent markers for nested folders
        icons = {
          corner = "└ ",
          edge = "│ ",
          item = "│ ",
          none = "  ",
        },
      },
      icons = {
        show = {
          file = true,
          folder = true,
          folder_arrow = true,
          git = true,
        },
        glyphs = {
          default = "",
          symlink = "",
          folder = {
            arrow_closed = "",
            arrow_open = "",
            default = "",
            open = "",
            empty = "",
            empty_open = "",
            symlink = "",
            symlink_open = "",
          },
          git = {
            unstaged = "✗",
            staged = "✓",
            unmerged = "",
            renamed = "➜",
            untracked = "★",
            deleted = "",
            ignored = "◌",
          },
        },
      },
    },
    filters = {
      dotfiles = false,
      git_clean = false, -- Don't hide clean files
      custom = {
        "^.git$",
        "^node_modules$",
        "^.DS_Store$",  -- Hide macOS specific files
        "^__pycache__$" -- Hide Python cache
      },
      exclude = {       -- Files you never want to hide
        ".gitignore",
        ".env.example"
      },
    },
    git = {
      enable = true,
      ignore = false,
      timeout = 500,
    },
    diagnostics = {   -- Show LSP diagnostics in the tree
      enable = false, -- Disabled to avoid duplicate diagnostics with Trouble
      show_on_dirs = false,
      icons = {
        hint = "󰋖",
        info = "",
        warning = "",
        error = "",
      },
    },
    actions = {
      open_file = {
        quit_on_open = false, -- Keep tree open when opening files
        resize_window = true, -- Resize tree when opening files
        window_picker = {
          enable = true,
          chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
          exclude = {
            filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
            buftype = { "nofile", "terminal", "help" },
          },
        },
      },
      change_dir = {
        enable = true,
        global = false, -- Setting this to true changes cwd globally
      },
      file_popup = {    -- Preview file content
        open_win_config = {
          col = 1,
          row = 1,
          relative = "cursor",
          border = "rounded",
          style = "minimal",
        },
      },
    },
    update_focused_file = {
      enable = true,       -- Auto-focuses on the current file
      update_root = false, -- Don't change root when focusing a file outside current root
      ignore_list = {},
    },
    hijack_directories = {
      enable = true,
      auto_open = true,
    },
    system_open = { -- System file opener
      cmd = nil,
      args = {},
    },
    notify = {
      threshold = vim.log.levels.INFO, -- Notifications for operations
    },
    log = {
      enable = false,
      truncate = false,
      types = {
        all = false,
        config = false,
        copy_paste = false,
        diagnostics = false,
        git = false,
        profile = false,
      },
    },
    live_filter = { -- Quickly filter tree with /
      prefix = "[FILTER]: ",
      always_show_folders = true,
    },
  })
end

return M
