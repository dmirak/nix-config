local M = {}

function M.setup()
  require('base16-colorscheme').setup {
    base00 = '#161529',
    base01 = '#242244',
    base02 = '#201f3d',
    base03 = '#636277',
    base04 = '#afafb6',
    base05 = '#f2f2f3',
    base06 = '#f2f2f3',
    base07 = '#f2f2f3',
    base08 = '#fd4663',
    base09 = '#cc66a5',
    base0A = '#feac71',
    base0B = '#6e67e4',
    base0C = '#e996c9',
    base0D = '#9893ec',
    base0E = '#feb580',
    base0F = '#900017',
  }

  -- transparency: strip backgrounds after the base16 colorscheme applies
  vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
  vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
  vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
  vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none" })
end

local signal = vim.uv.new_signal()
signal:start('sigusr1', vim.schedule_wrap(function()
  package.loaded['matugen'] = nil
  require('matugen').setup()
end))

return M
