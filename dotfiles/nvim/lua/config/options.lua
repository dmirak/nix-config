vim.opt.number = true
vim.opt.cursorline = true
vim.opt.relativenumber = true
vim.opt.shiftwidth = 4

vim.opt.completeopt = { "menu", "menuone", "noselect", "popup", "fuzzy" }
-- `o` routes omnifunc (the LSP, once attached) into the menu; `^5` caps each source
vim.opt.complete = { ".^5", "w^5", "b^5", "o" }
vim.o.autocomplete = true

-- scratch file for the `note` alias; no crash-recovery needed
vim.api.nvim_create_autocmd("BufReadPre", {
	pattern = vim.fn.expand("~/.notes.md"),
	callback = function()
		vim.opt_local.swapfile = false
	end,
})
