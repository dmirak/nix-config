local M = {}

function M.setup()
  require('base16-colorscheme').setup {
    base00 = '#0e141c',
    base01 = '#1b2029',
    base02 = '#252a33',
    base03 = '#8791a4',
    base04 = '#bcc7dc',
    base05 = '#dee2ef',
    base06 = '#dee2ef',
    base07 = '#dee2ef',
    base08 = '#ffb4ab',
    base09 = '#a5c8ff',
    base0A = '#81d3e0',
    base0B = '#4fd8ea',
    base0C = '#a5c8ff',
    base0D = '#4fd8ea',
    base0E = '#81d3e0',
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
