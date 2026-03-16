local M = {}

function M.setup()
	local colors = {
		bg = "#000000",
		fg = "#abb2bf",
		white = "#ffffff",
		yellow = "#ECBE7B",
		cyan = "#008080",
		green = "#98be65",
		orange = "#FF8800",
		violet = "#a9a1e1",
		magenta = "#c678dd",
		blue = "#51afef",
		red = "#ec5f67",
	}

	local conditions = {
		buffer_not_empty = function()
			return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
		end,
		hide_in_width = function()
			return vim.fn.winwidth(0) > 80
		end,
	}

	local config = {
		options = {
			component_separators = "",
			section_separators = "",
			theme = {
				normal = { c = { fg = colors.fg, bg = colors.bg } },
				inactive = { c = { fg = colors.fg, bg = colors.bg } },
			},
		},
		sections = {
			lualine_a = {},
			lualine_b = {},
			lualine_c = {},
			lualine_x = {},
			lualine_y = {},
			lualine_z = {},
		},
		inactive_sections = {
			lualine_a = {},
			lualine_b = {},
			lualine_c = {},
			lualine_x = {},
			lualine_y = {},
			lualine_z = {},
		},
	}

	local function ins_left(component)
		table.insert(config.sections.lualine_c, component)
	end

	local function ins_right(component)
		table.insert(config.sections.lualine_x, component)
	end

	ins_left({
		function()
			return " "
		end,
		color = { fg = colors.blue },
		padding = { left = 0, right = 1 },
	})

	ins_left({
		function()
			return ""
		end,
		color = function()
			local mode_color = {
				n = colors.red,
				i = colors.green,
				v = colors.blue,
				["\22"] = colors.blue,
				V = colors.blue,
				c = colors.magenta,
				no = colors.red,
				s = colors.orange,
				S = colors.orange,
				["\19"] = colors.orange,
				ic = colors.yellow,
				R = colors.violet,
				Rv = colors.violet,
				cv = colors.red,
				ce = colors.red,
				r = colors.cyan,
				rm = colors.cyan,
				["r?"] = colors.cyan,
				["!"] = colors.red,
				t = colors.red,
			}

			return { fg = mode_color[vim.fn.mode()] }
		end,
		padding = { right = 1 },
	})

	ins_left({ "filename", cond = conditions.buffer_not_empty, color = { fg = colors.magenta, gui = "bold" } })
	ins_left({ "location" })
	ins_left({ "progress", color = { fg = colors.fg, gui = "bold" } })
	ins_left({
		"diagnostics",
		sources = { "nvim_diagnostic" },
		symbols = { error = " ", warn = " ", info = " " },
		diagnostics_color = {
			error = { fg = colors.red },
			warn = { fg = colors.yellow },
			info = { fg = colors.cyan },
		},
	})
	ins_left({
		function()
			return "%="
		end,
	})
	ins_left({
		function()
			local clients = vim.lsp.get_clients({ bufnr = 0 })

			if next(clients) == nil then
				return "No LSP"
			end

			return clients[1].name
		end,
		icon = "",
		color = { fg = colors.white, gui = "bold" },
	})

	ins_right({ "branch", icon = "", color = { fg = colors.violet, gui = "bold" } })
	ins_right({
		"diff",
		symbols = { added = " ", modified = "󰝤 ", removed = " " },
		diff_color = {
			added = { fg = colors.green },
			modified = { fg = colors.orange },
			removed = { fg = colors.red },
		},
		cond = conditions.hide_in_width,
	})
	ins_right({
		function()
			return " "
		end,
		color = { fg = colors.blue },
		padding = { left = 1 },
	})

	require("lualine").setup(config)
end

return M
