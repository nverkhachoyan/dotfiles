-- Enhanced Neovim startup screen
-- Provides a beautiful dashboard with useful information and quick actions

local M = {}

-- Simple header
local header = {
  "NEOVIM",
  ""
}

-- Get theme-aware colors
local function get_colors()
  local theme_mode = vim.g.theme_mode or "dark"
  if theme_mode == "dark" then
    return {
      header = "#c678dd",  -- magenta
      info = "#51afef",    -- blue
      accent = "#98be65",  -- green
      warning = "#ECBE7B", -- yellow
      text = "#bbc2cf",    -- text
      dim = "#5c6370",     -- dimmed text
    }
  else
    return {
      header = "#9f4796",  -- magenta
      info = "#2e7de9",    -- blue
      accent = "#5d9d4e",  -- green
      warning = "#da8e1d", -- yellow
      text = "#575f66",    -- text
      dim = "#8a8a8a",     -- dimmed text
    }
  end
end

-- Get recent files
local function get_recent_files()
  local recent = {}
  local oldfiles = vim.v.oldfiles or {}
  local cwd = vim.fn.getcwd()
  local count = 0

  for _, file in ipairs(oldfiles) do
    if count >= 5 then break end
    -- Only show files in current working directory
    if vim.fn.filereadable(file) == 1 and string.find(file, cwd, 1, true) then
      local short_name = vim.fn.fnamemodify(file, ":~:.")
      if not string.match(short_name, "^%.git/") then
        table.insert(recent, short_name)
        count = count + 1
      end
    end
  end

  return recent
end

-- Get project info
local function get_project_info()
  local cwd = vim.fn.getcwd()
  local project_name = vim.fn.fnamemodify(cwd, ":t")
  local git_branch = vim.fn.system("git branch --show-current 2>/dev/null"):gsub("\n", "")
  if vim.v.shell_error ~= 0 then git_branch = "" end

  return {
    name = project_name,
    path = vim.fn.fnamemodify(cwd, ":~"),
    branch = git_branch ~= "" and git_branch or nil
  }
end

-- Create information sections
local function create_info_sections()
  local colors = get_colors()
  local project = get_project_info()
  local recent_files = get_recent_files()
  local sections = {}

  -- Project info section
  table.insert(sections, "")
  table.insert(sections, "  📁 " .. project.name)
  table.insert(sections, "     " .. project.path)
  if project.branch then
    table.insert(sections, "  🌿 " .. project.branch)
  end

  -- Recent files section
  if #recent_files > 0 then
    table.insert(sections, "")
    table.insert(sections, "  📄 Recent Files")
    for i, file in ipairs(recent_files) do
      table.insert(sections, "     " .. i .. ". " .. file)
    end
  end

  -- Quick actions section
  table.insert(sections, "")
  table.insert(sections, "  ⚡ Quick Actions")
  table.insert(sections, "     f  Find Files")
  table.insert(sections, "     g  Live Grep")
  table.insert(sections, "     r  Recent Files")
  table.insert(sections, "     c  Config")
  table.insert(sections, "     n  New File")
  table.insert(sections, "     t  File Tree")
  table.insert(sections, "     q  Quit")

  return sections
end

-- Function to create enhanced centered buffer
function M.create_centered_buffer()
  -- Create a new buffer
  local buf = vim.api.nvim_create_buf(false, true)

  -- Get editor dimensions
  local width = vim.api.nvim_get_option("columns")
  local height = vim.api.nvim_get_option("lines")

  -- Create content sections
  local info_sections = create_info_sections()
  local total_content_height = #header + #info_sections + 2 -- +2 for spacing

  -- Calculate starting positions for centering
  local start_row = math.max(1, math.floor((height - total_content_height) / 2))

  -- Find the maximum width of content for centering the block
  local max_content_width = 0
  for _, line in ipairs(header) do
    max_content_width = math.max(max_content_width, vim.fn.strdisplaywidth(line))
  end
  for _, line in ipairs(info_sections) do
    max_content_width = math.max(max_content_width, vim.fn.strdisplaywidth(line))
  end

  -- Calculate left offset to center the content block
  local content_left_offset = math.floor((width - max_content_width) / 2)

  -- Build the complete content
  local final_content = {}

  -- Add top padding
  for _ = 1, start_row do
    table.insert(final_content, "")
  end

  -- Add header (centered within the content block)
  for _, line in ipairs(header) do
    local header_padding = string.rep(" ", content_left_offset)
    table.insert(final_content, header_padding .. line)
  end

  -- Add info sections (left-aligned within the content block)
  for _, line in ipairs(info_sections) do
    local padding = string.rep(" ", content_left_offset)
    table.insert(final_content, padding .. line)
  end

  -- Set buffer content
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, final_content)

  -- Set buffer options
  vim.api.nvim_buf_set_option(buf, 'modifiable', false)
  vim.api.nvim_buf_set_option(buf, 'modified', false)
  vim.api.nvim_buf_set_option(buf, 'buftype', 'nofile')
  vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
  vim.api.nvim_buf_set_option(buf, 'filetype', 'startup')

  return buf
end

-- Add syntax highlighting for startup buffer
local function setup_startup_highlights()
  local colors = get_colors()

  -- Define highlight groups
  vim.api.nvim_set_hl(0, 'StartupHeader', { fg = colors.header, bold = true })
  vim.api.nvim_set_hl(0, 'StartupInfo', { fg = colors.info })
  vim.api.nvim_set_hl(0, 'StartupAccent', { fg = colors.accent })
  vim.api.nvim_set_hl(0, 'StartupText', { fg = colors.text })
  vim.api.nvim_set_hl(0, 'StartupDim', { fg = colors.dim })
  vim.api.nvim_set_hl(0, 'StartupWarning', { fg = colors.warning })
end

-- Apply syntax highlighting to buffer
local function apply_highlights(buf)
  local ns = vim.api.nvim_create_namespace('startup')
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

  for i, line in ipairs(lines) do
    -- Highlight simple header (NEOVIM text)
    if string.match(line, "NEOVIM") then
      vim.api.nvim_buf_add_highlight(buf, ns, 'StartupHeader', i - 1, 0, -1)
      -- Highlight section headers (with emojis)
    elseif string.match(line, "📁") or string.match(line, "🌿") or string.match(line, "📄") or string.match(line, "⚡") then
      vim.api.nvim_buf_add_highlight(buf, ns, 'StartupAccent', i - 1, 0, -1)
      -- Highlight numbered items and shortcuts
    elseif string.match(line, "^%s+%d+%.") or string.match(line, "^%s+%a%s+") then
      vim.api.nvim_buf_add_highlight(buf, ns, 'StartupInfo', i - 1, 0, -1)
      -- Highlight file paths
    elseif string.match(line, "/") and not string.match(line, "📁") then
      vim.api.nvim_buf_add_highlight(buf, ns, 'StartupDim', i - 1, 0, -1)
    end
  end
end

-- Enhanced function to open the startup screen
function M.open_startup_screen()
  -- Create and display the buffer
  local buf = M.create_centered_buffer()
  vim.api.nvim_set_current_buf(buf)

  -- Setup highlighting
  setup_startup_highlights()
  apply_highlights(buf)

  -- Hide UI elements for clean look
  vim.opt.number = false
  vim.opt.relativenumber = false
  vim.opt.ruler = false
  vim.opt.laststatus = 0
  vim.opt.showcmd = false
  vim.opt.showmode = false
  vim.opt.fillchars = { eob = " " }
  vim.opt.cursorline = false

  -- Add autocmd to restore UI elements when leaving this buffer
  vim.api.nvim_create_autocmd("BufLeave", {
    buffer = buf,
    callback = function()
      vim.opt.number = true
      vim.opt.relativenumber = true
      vim.opt.ruler = true
      vim.opt.laststatus = 2
      vim.opt.showcmd = true
      vim.opt.showmode = true
      vim.opt.fillchars = { eob = "~" }
      vim.opt.cursorline = true
    end,
    once = true
  })

  -- Enhanced keymaps for quick actions
  local opts = { noremap = true, silent = true, buffer = buf }

  -- Basic navigation
  vim.keymap.set('n', 'q', ':q<CR>', opts)
  vim.keymap.set('n', '<Esc>', ':q<CR>', opts)
  vim.keymap.set('n', '<CR>', ':enew<CR>', opts)

  -- Quick actions matching the display
  vim.keymap.set('n', 'f', function()
    require('telescope.builtin').find_files()
  end, vim.tbl_extend('force', opts, { desc = 'Find files' }))

  vim.keymap.set('n', 'g', function()
    require('telescope.builtin').live_grep()
  end, vim.tbl_extend('force', opts, { desc = 'Live grep' }))

  vim.keymap.set('n', 'r', function()
    require('telescope.builtin').oldfiles()
  end, vim.tbl_extend('force', opts, { desc = 'Recent files' }))

  vim.keymap.set('n', 'c', function()
    vim.cmd('cd ' .. vim.fn.stdpath('config'))
    require('telescope.builtin').find_files()
  end, vim.tbl_extend('force', opts, { desc = 'Config files' }))

  vim.keymap.set('n', 'n', ':enew<CR>', vim.tbl_extend('force', opts, { desc = 'New file' }))

  vim.keymap.set('n', 't', ':NvimTreeToggle<CR>', vim.tbl_extend('force', opts, { desc = 'Toggle file tree' }))

  -- Number keys for recent files (1-5)
  local recent_files = get_recent_files()
  for i, file in ipairs(recent_files) do
    if i <= 9 then
      vim.keymap.set('n', tostring(i), function()
        vim.cmd('edit ' .. vim.fn.fnameescape(file))
      end, vim.tbl_extend('force', opts, { desc = 'Open ' .. file }))
    end
  end

  -- Theme toggle
  vim.keymap.set('n', 'T', function()
    require('plugins.theme').toggle_theme()
    -- Refresh the startup screen with new colors
    vim.defer_fn(function()
      if vim.api.nvim_buf_is_valid(buf) then
        setup_startup_highlights()
        apply_highlights(buf)
      end
    end, 100)
  end, vim.tbl_extend('force', opts, { desc = 'Toggle theme' }))
end

return M
