return {
  { "akinsho/bufferline.nvim", enabled = false },
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      local c = opts.sections and opts.sections.lualine_c
      if type(c) == "table" and #c > 0 then
        c[#c] = { LazyVim.lualine.pretty_path({ modified_sign = " +" }) }
      end
    end,
  },
}
