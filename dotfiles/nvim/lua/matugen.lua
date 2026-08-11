local M = {}

function M.setup()
  require('base16-colorscheme').setup {
    base00 = '#0e141c',
    base01 = '#1a2028',
    base02 = '#252a33',
    base03 = '#8691a4',
    base04 = '#bcc7db',
    base05 = '#dde2ee',
    base06 = '#dde2ee',
    base07 = '#dde2ee',
    base08 = '#ffb4ab',
    base09 = '#a3c9fe',
    base0A = '#81d3de',
    base0B = '#4ed8e8',
    base0C = '#a3c9fe',
    base0D = '#4ed8e8',
    base0E = '#81d3de',
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
