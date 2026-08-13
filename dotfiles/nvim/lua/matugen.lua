local M = {}

function M.setup()
  require('base16-colorscheme').setup {
    base00 = '#291a14',
    base01 = '#452c21',
    base02 = '#3e271e',
    base03 = '#74655f',
    base04 = '#b6b1af',
    base05 = '#f3f2f2',
    base06 = '#f3f2f2',
    base07 = '#f3f2f2',
    base08 = '#ca3d04',
    base09 = '#c3fb37',
    base0A = '#fbd137',
    base0B = '#fc8150',
    base0C = '#dafc82',
    base0D = '#fda582',
    base0E = '#fce282',
    base0F = '#4c1600',
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
