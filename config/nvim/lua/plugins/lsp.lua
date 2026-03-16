return {
	{
		"neovim/nvim-lspconfig",
		dependencies = { "hrsh7th/cmp-nvim-lsp" },
		config = function()
			local lsp = require("config.lsp")
			local capabilities = lsp.capabilities()

			for server_name, server_config in pairs(lsp.servers()) do
				local ok = pcall(
					vim.lsp.config,
					server_name,
					vim.tbl_deep_extend("force", {
						capabilities = capabilities,
						on_attach = lsp.on_attach,
					}, server_config)
				)

				if ok then
					pcall(vim.lsp.enable, server_name)
				end
			end
		end,
	},
}
