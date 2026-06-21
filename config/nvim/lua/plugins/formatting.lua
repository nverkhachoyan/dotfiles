return {
	{
		"stevearc/conform.nvim",
		config = function()
			require("conform").setup({
				format_on_save = {
					timeout_ms = 500,
					lsp_fallback = true,
				},
				formatters_by_ft = {
					lua = { "stylua" },
					python = { "ruff_format" },
					javascript = { "prettier" },
					typescript = { "prettier" },
					rust = { "rustfmt" },
					go = { "gofmt" },
					c = { "clang-format" },
					cpp = { "clang-format" },
					["_"] = { "trim_whitespace" },
				},
			})
		end,
	},
	{
		"mfussenegger/nvim-lint",
		config = function()
			local lint = require("lint")

			lint.linters_by_ft = {
				markdown = { "vale" },
			}

			vim.api.nvim_create_autocmd("BufWritePost", {
				callback = function()
					lint.try_lint()
				end,
			})
		end,
	},
}
