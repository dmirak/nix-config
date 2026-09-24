vim.g.mapleader = " "
vim.keymap.set("n", "<leader>cd", vim.cmd.Ex)
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)

-- completeopt has "noselect", so the popup opens with nothing highlighted;
-- Tab selects the focused entry (or the top one, if none is focused yet) and confirms it
vim.keymap.set("i", "<Tab>", function()
	if vim.fn.pumvisible() == 1 then
		if vim.fn.complete_info({ "selected" }).selected == -1 then
			return "<C-n><C-y>"
		end
		return "<C-y>"
	end
	return "<Tab>"
end, { expr = true })

