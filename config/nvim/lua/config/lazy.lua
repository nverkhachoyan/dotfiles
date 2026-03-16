local uv = vim.uv or vim.loop
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not uv.fs_stat(lazypath) then
	local out = vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})

	if vim.v.shell_error ~= 0 then
		error("lazy.nvim bootstrap failed:\n" .. out)
	end
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	spec = {
		{ import = "plugins" },
	},
	checker = { enabled = false },
	change_detection = { notify = false },
})
