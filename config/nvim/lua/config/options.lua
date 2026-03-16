local options = {
	number = true,
	relativenumber = true,
	mouse = "a",
	ignorecase = true,
	smartcase = true,
	hlsearch = false,
	wrap = false,
	tabstop = 2,
	shiftwidth = 2,
	expandtab = true,
	termguicolors = true,
	clipboard = "unnamedplus",
	swapfile = false,
	splitright = true,
	splitbelow = true,
	scrolloff = 8,
}

for key, value in pairs(options) do
	vim.opt[key] = value
end
