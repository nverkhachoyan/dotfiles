local M = {}

function M.capabilities()
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")

	if ok then
		capabilities = vim.tbl_deep_extend("force", capabilities, cmp_nvim_lsp.default_capabilities())
	end

	return capabilities
end

function M.on_attach(_, bufnr)
	local map = function(keys, func, desc)
		vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
	end

	map("gd", vim.lsp.buf.definition, "Go to definition")
	map("gr", vim.lsp.buf.references, "References")
	map("gi", vim.lsp.buf.implementation, "Implementation")
	map("K", vim.lsp.buf.hover, "Hover")
	map("<leader>rn", vim.lsp.buf.rename, "Rename")
	map("<leader>ca", vim.lsp.buf.code_action, "Code action")
end

function M.servers()
	return {
		clangd = {},
		gopls = {},
		lua_ls = {},
		nil_ls = {},
		ruff = {},
		rust_analyzer = {},
		ts_ls = {
			filetypes = {
				"javascript",
				"javascriptreact",
				"javascript.jsx",
				"typescript",
				"typescriptreact",
				"typescript.tsx",
			},
		},
		vale_ls = {},
	}
end

return M
