return {
	{
		"stevearc/conform.nvim",
		config = function()
			require("conform").setup({
				format_on_save = {
					timeout_ms = 500,
					lsp_format = "fallback",
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

			lint.linters_by_ft = {}

			-- Vale fails without a config, so it only runs on markdown under a
			-- project .vale.ini or when a global one exists.
			local function vale_config(bufnr)
				local project = vim.fs.find({ ".vale.ini", "_vale.ini" }, {
					upward = true,
					path = vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr)),
				})[1]
				if project then
					return project
				end

				for _, path in ipairs({
					vim.env.VALE_CONFIG_PATH,
					(vim.env.XDG_CONFIG_HOME or vim.fn.expand("~/.config")) .. "/vale/.vale.ini",
					vim.fn.expand("~/Library/Application Support/vale/.vale.ini"),
					vim.fn.expand("~/.vale.ini"),
				}) do
					if path and vim.uv.fs_stat(path) then
						return path
					end
				end
			end

			vim.api.nvim_create_autocmd("BufWritePost", {
				callback = function(args)
					lint.try_lint()

					if vim.bo[args.buf].filetype == "markdown" then
						local config = vale_config(args.buf)
						if config then
							lint.try_lint("vale", { cwd = vim.fs.dirname(config) })
						end
					end
				end,
			})
		end,
	},
}
