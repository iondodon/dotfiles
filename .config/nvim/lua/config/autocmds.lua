-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

local transparent_group = vim.api.nvim_create_augroup("transparent_background", { clear = true })
vim.api.nvim_create_autocmd({ "ColorScheme", "VimEnter" }, {
  group = transparent_group,
  callback = function()
    local hl = vim.api.nvim_set_hl
    hl(0, "Normal", { bg = "NONE" })
    hl(0, "NormalNC", { bg = "NONE" })
    hl(0, "NormalFloat", { bg = "NONE" })
    hl(0, "FloatBorder", { bg = "NONE" })
    hl(0, "SignColumn", { bg = "NONE" })
    hl(0, "FoldColumn", { bg = "NONE" })
    hl(0, "EndOfBuffer", { bg = "NONE" })
  end,
})
