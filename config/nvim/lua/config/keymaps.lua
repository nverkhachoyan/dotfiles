local map = vim.keymap.set

map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

map("n", "<leader>w", "<cmd>w<cr>", { desc = "Save" })
map("n", "<leader>wa", "<cmd>wa<cr>", { desc = "Save all" })
map("n", "<leader>qq", "<cmd>q<cr>", { desc = "Quit" })

map("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostics" })
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
map("n", "<leader>dl", vim.diagnostic.setloclist, { desc = "Diagnostics list" })
map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Workspace diagnostics" })
map("n", "<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Document diagnostics" })
map("n", "<leader>xl", "<cmd>Trouble lsp toggle<cr>", { desc = "LSP references/definitions" })
map("n", "<leader>xq", "<cmd>Trouble quickfix toggle<cr>", { desc = "Quickfix list" })

map("n", "<leader>f", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
map("n", "<leader>g", "<cmd>Telescope live_grep<cr>", { desc = "Live grep" })
map("n", "<leader>b", "<cmd>Telescope buffers<cr>", { desc = "Buffers" })

map("n", "<C-n>", "<cmd>NvimTreeToggle<cr>", { desc = "Toggle file tree" })
map("n", "<leader>nc", "<cmd>NvimTreeCollapse<cr>", { desc = "Collapse tree" })
map("n", "<leader>ne", function()
	local api = require("nvim-tree.api")
	api.tree.collapse_all()
	api.tree.find_file({ open = false, focus = false })
end, { desc = "Collapse keep buffers" })

map("n", "<leader>tn", function()
	vim.opt.relativenumber = not vim.opt.relativenumber:get()
end, { desc = "Toggle relative numbers" })
