vim.opt.number = true
vim.opt.cursorline = true
vim.opt.relativenumber = true
vim.opt.shiftwidth = 4

-- scratch file for the `note` alias; no crash-recovery needed
vim.api.nvim_create_autocmd("BufReadPre", {
	pattern = vim.fn.expand("~/.notes.md"),
	callback = function()
		vim.opt_local.swapfile = false
	end,
})
