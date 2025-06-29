return {
  -- Theme: Catppuccin with "mocha" flavor
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    opts = {
      flavour = "frappe",
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
  { "nvim-lualine/lualine.nvim", dependencies = { "nvim-tree/nvim-web-devicons" } },
  { "nvim-tree/nvim-tree.lua", dependencies = { "nvim-tree/nvim-web-devicons" } },
  { "nvim-telescope/telescope.nvim", dependencies = "nvim-lua/plenary.nvim" },
  { "akinsho/toggleterm.nvim" },
  -- Treesitter for syntax
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "lua" },
        highlight = { enable = true },
      })
    end,
  },
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
        },
      },
    },
  },
  -- LSP & Completion
  { "williamboman/mason.nvim", config = true },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = "mason.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "terraformls", "bashls", "yamlls", "pyright" },
        automatic_installation = true,
        handlers = {
          function(server_name)
            if server_name ~= "zls" and server_name ~= "gopls" then
              require("lspconfig")[server_name].setup({})
            end
          end,
        },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
      end
      local lspconfig = require("lspconfig")
      local on_attach = function(client, bufnr)
        local keymap = vim.keymap.set
        local opts = { buffer = bufnr }

        vim.api.nvim_create_autocmd("BufWritePre", {
          buffer = bufnr,
          callback = function()
            vim.lsp.buf.format({ async = false })
            if client.name ~= "zls" then
              vim.lsp.buf.code_action({ context = { only = { "source.organizeImports" } }, apply = true })
            end
          end,
        })

        keymap("n", "<C-d>", vim.lsp.buf.definition, { desc = "Go to definition", unpack(opts) })
        keymap("n", "<C-e>", vim.lsp.buf.declaration, { desc = "Go to declaration", unpack(opts) })
        keymap("n", "<C-i>", vim.lsp.buf.implementation, { desc = "Go to implementation", unpack(opts) })
        keymap("n", "<C-r>", vim.lsp.buf.references, { desc = "Show references", unpack(opts) })
        keymap("n", "<C-p>", vim.lsp.buf.hover, { desc = "Peek definition", unpack(opts) })
      end

      lspconfig.gopls.setup({
        settings = {
          gopls = {
            gofumpt = true,
            staticcheck = true,
            analyses = {
              unusedparams = true,
            },
            hints = {
              assignVariableTypes = true,
              compositeLiteralFields = true,
              constantValues = true,
              functionTypeParameters = true,
              parameterNames = true,
              rangeVariableTypes = true,
            },
          },
        },
        on_attach = on_attach,
      })

      lspconfig.zls.setup({
        settings = {
          zls = {
            enable_inlay_hints = true,
            enable_snippets = true,
            warn_style = true,
            verbose = true,
            zig_exe_path = "/opt/homebrew/bin/zig",
          },
        },
        on_attach = on_attach,
      })

      lspconfig.pyright.setup({
        settings = {
          python = {
            venvPath = ".",
            venv = ".venv",
          },
        },
        on_attach = on_attach,
      })
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-buffer", "L3MON4D3/LuaSnip" },
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
        },
      })
    end,
  },

  -- multicursor
  {
    "jake-stewart/multicursor.nvim",
    event = "VeryLazy",
    config = function()
      local mc = require("multicursor-nvim")
      mc.setup()

      local set = vim.keymap.set

      set("n", "<A-S-leftmouse>", mc.handleMouse, { desc = "Add cursor with Alt+Shift+Click" })
      set("n", "<A-S-leftdrag>", mc.handleMouseDrag, { desc = "Drag with Alt+Shift+Click" })
      set("n", "<A-S-leftrelease>", mc.handleMouseRelease, { desc = "Release with Alt+Shift+Click" })

      set({ "n", "x" }, "<M-g>", function()
        mc.matchAddCursor(1)
      end, { desc = "Add cursor to next match (IntelliJ Cmd+G)" })

      set({ "n", "x" }, "<M-S-g>", function()
        mc.deleteCursor()
      end, { desc = "Remove last cursor (IntelliJ Option+Shift+G)" })

      set({ "n", "x" }, "<M-S-Up>", function()
        mc.lineAddCursor(-1)
      end, { desc = "Add cursor above" })
      set({ "n", "x" }, "<M-S-Down>", function()
        mc.lineAddCursor(1)
      end, { desc = "Add cursor below" })

      set({ "n", "x" }, "<leader>s", function()
        mc.matchSkipCursor(1)
      end, { desc = "Skip next match" })

      set({ "n", "x" }, "<leader>q", mc.toggleCursor, { desc = "Toggle cursors" })

      mc.addKeymapLayer(function(layerSet)
        layerSet({ "n", "x" }, "<Left>", mc.prevCursor, { desc = "Select previous cursor" })
        layerSet({ "n", "x" }, "<Right>", mc.nextCursor, { desc = "Select next cursor" })
        layerSet("n", "<Esc>", function()
          if not mc.cursorsEnabled() then
            mc.enableCursors()
          else
            mc.clearCursors()
          end
        end, { desc = "Clear cursors" })
      end)

      local hl = vim.api.nvim_set_hl
      hl(0, "MultiCursorCursor", { reverse = true })
      hl(0, "MultiCursorVisual", { link = "Visual" })
      hl(0, "MultiCursorSign", { link = "SignColumn" })
      hl(0, "MultiCursorMatchPreview", { link = "Search" })
      hl(0, "MultiCursorDisabledCursor", { reverse = true })
      hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
      hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
    end,
  },

  -- Which-key
  {
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup()
    end,
  },

  -- Golang
  {
    "ray-x/go.nvim",
    dependencies = { "ray-x/guihua.lua" },
    config = function()
      require("go").setup({
        lsp_cfg = false, -- enable lspconfig
        lsp_gofumpt = true, -- use gofumpt
      })
    end,
    ft = { "go", "gomod" },
  },

  -- zig
  {
    "ziglang/zig.vim",
  },

  -- Terraform, Bash, YAML, Python LSP
  -- mason will install 'terraform-ls', 'bash-language-server', 'yamlls', 'pyright'

  -- Git & Merge Conflicts
  { "tpope/vim-fugitive" },
  { "lewis6991/gitsigns.nvim", config = true },
  {
    "akinsho/git-conflict.nvim",
    config = function()
      require("git-conflict").setup({})
    end,
  },
}
