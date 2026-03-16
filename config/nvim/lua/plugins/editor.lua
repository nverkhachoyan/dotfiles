return {
	{
		"nvim-tree/nvim-web-devicons",
		lazy = true,
	},
	{
		"nvim-tree/nvim-tree.lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("nvim-tree").setup({
				hijack_cursor = true,
				sync_root_with_cwd = true,
				update_focused_file = {
					enable = true,
					update_root = false,
				},
				renderer = {
					group_empty = true,
				},
				view = {
					width = 36,
				},
			})
		end,
	},
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
			},
			"nvim-telescope/telescope-ui-select.nvim",
		},
		config = function()
			local telescope = require("telescope")

			telescope.setup({
				extensions = {
					fzf = {
						fuzzy = true,
						override_generic_sorter = true,
						override_file_sorter = true,
						case_mode = "smart_case",
					},
					["ui-select"] = require("telescope.themes").get_dropdown({}),
				},
			})

			pcall(telescope.load_extension, "fzf")
			pcall(telescope.load_extension, "ui-select")
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter").setup({})

			vim.api.nvim_create_autocmd("FileType", {
				callback = function()
					pcall(vim.treesitter.start)
					pcall(function()
						vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
					end)
				end,
			})
		end,
	},
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {},
	},
	{
		"windwp/nvim-autopairs",
		opts = {},
	},
	{
		"kylechui/nvim-surround",
		opts = {},
	},
	{
		"RRethy/vim-illuminate",
		config = function()
			require("illuminate").configure({})
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("config.lualine").setup()
		end,
	},
}
