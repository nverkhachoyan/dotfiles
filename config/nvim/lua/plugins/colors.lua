return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				flavour = "frappe",
				show_end_of_buffer = false,
				default_integrations = false,
				background = {
					light = "frappe",
					dark = "frappe",
				},
				color_overrides = {
					frappe = {
						rosewater = "#f07178",
						flamingo = "#be5046",
						pink = "#c678dd",
						mauve = "#d55fde",
						red = "#e06c75",
						maroon = "#d19a66",
						peach = "#e5c07b",
						yellow = "#ebcb8b",
						green = "#98c379",
						teal = "#56b6c2",
						sky = "#82a1f1",
						sapphire = "#4fa6ed",
						blue = "#61afef",
						lavender = "#a291ff",
						text = "#abb2bf",
						subtext1 = "#979eab",
						subtext0 = "#828997",
						overlay2 = "#7c828e",
						overlay1 = "#5c6370",
						overlay0 = "#4b5263",
						surface2 = "#3e4452",
						surface1 = "#353b45",
						surface0 = "#2c323c",
						base = "#000000",
						mantle = "#21252b",
						crust = "#181a1f",
					},
				},
			})

			vim.env.BAT_THEME = "catppuccin"
			vim.cmd.colorscheme("catppuccin")
		end,
	},
}
