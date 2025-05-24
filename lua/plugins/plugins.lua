return {
  -- Theme: Catppuccin with "mocha" flavor
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    opts = {
      flavour = "mocha",
    },
  },
  -- LazyVim (optional, for general features, with LSP and completion disabled)
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
      lsp = false,
      completion = false,
    },
  },
  { "nvim-lualine/lualine.nvim",       dependencies = { 'nvim-tree/nvim-web-devicons' } },
  { "nvim-tree/nvim-tree.lua",         dependencies = { 'nvim-tree/nvim-web-devicons' } },
  { "nvim-telescope/telescope.nvim",   dependencies = 'nvim-lua/plenary.nvim' },
  { "akinsho/toggleterm.nvim" },
  -- Treesitter for syntax
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      filesystem = {
        visible = true,
        show_hidden_count = true,
        hide_dotfiles = false,
        hide_gitignored = true,
        hide_by_name = {
          ".git",
          ".DS_Store",
        },
        never_show = {
          ".git",
          "node_modules",
        }
      }
    }
  },
  -- LSP & Completion
  { "williamboman/mason.nvim", config = true },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = 'mason.nvim',
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "terraformls", "bashls", "yamlls", "pyright" },
        automatic_installation = true,
        handlers = {
          function(server_name)
            require("lspconfig")[server_name].setup({})
          end,
          ["gopls"] = function() end,
        }
      })
    end
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")
      lspconfig.gopls.setup({ autostart = false })
    end
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = { 'hrsh7th/cmp-nvim-lsp', 'hrsh7th/cmp-buffer', 'L3MON4D3/LuaSnip' },
    config = function()
      vim.o.completeopt = "menu,menuone,noselect"
      local cmp = require("cmp")
      cmp.setup({
        sources = {
          { name = "nvim_lsp", group_index = 1, priority = 100 },
        },
        mapping = {
          ["<C-y>"] = cmp.mapping.confirm({ select = true }),
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-p>"] = cmp.mapping.select_prev_item(),
        },
        duplicates = {
          nvim_lsp = 1,
        },
        experimental = {
          ghost_text = false,
        }
      })
    end,
  },

  -- Golang
  {
    "ray-x/go.nvim",
    dependencies = { 'ray-x/guihua.lua' },
    config = function()
      require('go').setup({
        lsp_cfg = true,     -- enable lspconfig
        lsp_gofumpt = true, -- use gofumpt
      })
    end,
    ft = { "go", "gomod" }
  },

  -- Terraform, Bash, YAML, Python LSP
  -- mason will install 'terraform-ls', 'bash-language-server', 'yamlls', 'pyright'

  -- Git & Merge Conflicts
  { "tpope/vim-fugitive" },
  { "lewis6991/gitsigns.nvim", config = true },
  {
    "akinsho/git-conflict.nvim",
    config = function()
      require('git-conflict').setup({})
    end
  },
}
