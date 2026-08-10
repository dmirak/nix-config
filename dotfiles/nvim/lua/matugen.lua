local M = {}

function M.setup()
  require('base16-colorscheme').setup {
    base00 = '#1b1016',
    base01 = '#291c22',
    base02 = '#34262d',
    base03 = '#a78896',
    base04 = '#dfbecc',
    base05 = '#f3dde5',
    base06 = '#f3dde5',
    base07 = '#f3dde5',
    base08 = '#ffb4ab',
    base09 = '#fbb0d7',
    base0A = '#cebdfe',
    base0B = '#cebdff',
    base0C = '#fbb0d7',
    base0D = '#cebdff',
    base0E = '#cebdfe',
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
