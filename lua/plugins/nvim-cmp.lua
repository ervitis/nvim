return {
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      local cmp = require("cmp")
      opts.snippet = {
        expand = function(args) end,
      }

      opts.sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "buffer" },
        { name = "path" },
        { name = "treesitter" },
      })

      opts.formatting = {
        format = function(entry, vim_item)
          vim_item.abbr = vim_item.abbr:match("[^(]+")
          return vim_item
        end,
      }
      return opts
    end,
  },
}
