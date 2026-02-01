return {
  {
    "mason-org/mason.nvim",
    name = "mason.nvim",
    opts = {
      ensure_installed = {
        "jdtls",
        "java-debug-adapter",
        "java-test",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        jdtls = {},
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "java" })
    end,
  },
}
