return {
  {
    "mason-org/mason.nvim",
    name = "mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "gofumpt",
        "goimports",
        "golangci-lint",
        "gopls",
      })
    end,
  },
  {
    "nvim-lspconfig",
    opts = {
      servers = {
        gopls = {
          settings = {
            gopls = {
              analyses = {
                shadow = true,
                unusedparams = true,
              },
              gofumpt = true,
              staticcheck = true,
            },
          },
        },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "go",
        "gomod",
        "gosum",
        "gowork",
      })
    end,
  },
}
