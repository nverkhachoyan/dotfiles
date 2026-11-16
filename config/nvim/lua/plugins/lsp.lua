return {
	{
		"neovim/nvim-lspconfig",
		dependencies = { "hrsh7th/cmp-nvim-lsp" },
		config = function()
			local lsp = require("config.lsp")

			vim.lsp.config("*", { capabilities = lsp.capabilities() })

			-- Keymaps go in LspAttach rather than on_attach, which would replace
			-- the on_attach nvim-lspconfig ships for some servers.
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("config_lsp", { clear = true }),
				callback = function(args)
					lsp.keymaps(args.buf)
				end,
			})

			for server_name, server_config in pairs(lsp.servers()) do
				vim.lsp.config(server_name, server_config)
				vim.lsp.enable(server_name)
			end
		end,
	},
}
