local M = {}

function M.setup()
  require('base16-colorscheme').setup {
    base00 = '#091613',
    base01 = '#15221f',
    base02 = '#202c2a',
    base03 = '#7c9690',
    base04 = '#b1ccc5',
    base05 = '#d7e6e1',
    base06 = '#d7e6e1',
    base07 = '#d7e6e1',
    base08 = '#ffb4ab',
    base09 = '#83d5c5',
    base0A = '#b1d18a',
    base0B = '#a7d474',
    base0C = '#83d5c5',
    base0D = '#a7d474',
    base0E = '#b1d18a',
    base0F = '#93000a',
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
