local filesystem = require("neo-tree.sources.filesystem")
return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    opts = {
      flavour = "mocha",
    },
    {
      "LazyVim/LazyVim",
      opts = {
        colorscheme = "catppuccin",
      },
    },
  },
  {
    "folke/todo-comments.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
  {
    "williamboman/mason.nvim",
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    config = function()
      require("mason").setup()

      require("mason-lspconfig").setup({
        ensure_installed = {
          "pyright",
          "lua_ls",
          "bashls",
          "yamlls",
          "gopls",
          "jsonls",
          "taplo",
          "rust_analyzer",
          "terraformls",
          "tflint",
        },
      })
      local lspconfig = require("lspconfig")
      lspconfig.pyright.setup({})
      lspconfig.lua_ls.setup({
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
          },
        },
      })
      lspconfig.terraformls.setup({})
      lspconfig.tflint.setup({})
      lspconfig.bashls.setup({})
      lspconfig.yamlls.setup({})
      lspconfig.jsonls.setup({})
      lspconfig.taplo.setup({})
      lspconfig.gopls.setup({
        settings = {
          gopls = {
            buildFlags = { "-tags=integration" },
          },
        },
      })
      lspconfig.rust_analyzer.setup({})
    end,
  },
  {
    {
      "mfussenegger/nvim-dap",
      dependencies = {
        "leoluz/nvim-dap-go",
        "mfussenegger/nvim-dap-python",
        "rcarriga/nvim-dap-ui",
        "theHamsta/nvim-dap-virtual-text",
        "nvim-neotest/nvim-nio",
      },
      config = function()
        local dap = require("dap")
        local ui = require("dapui")

        require("dapui").setup()
        require("dap-go").setup()

        require("dap-python").setup(vim.fn.expand("~") .. "/.virtualenvs/debugpy/bin/python")

        require("nvim-dap-virtual-text").setup({
          -- This just tries to mitigate the chance that I leak tokens here. Probably won't stop it from happening...
          display_callback = function(variable)
            local name = string.lower(variable.name)
            local value = string.lower(variable.value)
            if name:match("secret") or name:match("api") or value:match("secret") or value:match("api") then
              return "*****"
            end

            if #variable.value > 15 then
              return " " .. string.sub(variable.value, 1, 15) .. "... "
            end

            return " " .. variable.value
          end,
        })

        vim.keymap.set("n", "<Leader>db", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
        vim.keymap.set("n", "<Leader>gb", dap.run_to_cursor, { desc = "Run to cursor" })

        vim.fn.sign_define("DapBreakpoint", { text = "🟥", texthl = "", linehl = "", numhl = "" })
        vim.fn.sign_define("DapStopped", { text = "~>", texthl = "", linehl = "", numhl = "" })

        -- Eval var under cursor
        vim.keymap.set("n", "<Leader>?", function()
          require("dapui").eval(nil, { enter = true })
        end)

        vim.keymap.set("n", "<Leader>du", function()
          ui.close()
        end, { desc = "Close dap ui" })

        vim.keymap.set("n", "<Leader>gdi", dap.step_into, { desc = "Debug step into" })
        vim.keymap.set("n", "<Leader>gdo", dap.step_over, { desc = "Debug step over" })
        vim.keymap.set("n", "<Leader>gds", dap.continue, { desc = "Start Debug" })
        vim.keymap.set("n", "<Leader>gdr", dap.restart, { desc = "Debug restart" })

        dap.adapters.delve = {
          type = "server",
          port = "${port}",
          executable = {
            command = vim.fn.expand("~") .. "/go/bin/dlv",
            args = { "dap", "-l", "127.0.0.1:${port}" },
          },
        }

        dap.configurations.go = {
          {
            type = "delve",
            name = "Debug",
            request = "launch",
            program = "${file}",
          },
        }

        dap.listeners.before.attach.dapui_config = function()
          ui.open()
        end
        dap.listeners.before.launch.dapui_config = function()
          ui.open()
        end
        dap.listeners.before.event_terminated.dapui_config = function()
          ui.close()
        end
        dap.listeners.before.event_exited.dapui_config = function()
          ui.close()
        end
      end,
    },
  },
  {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
    keys = {
      {
        "<leader>fb",
        ":Telescope file_browser path=%:p:h%:p:h<cr>",
        desc = "Browse Files",
      },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()
      vim.keymap.set("n", "<Leader>gp", ":Gitsigns preview_hunk<CR>", { desc = "gitsigns preview_hunk" })
    end,
  },
  -- nvim v0.8.0
  {
    "kdheepak/lazygit.nvim",
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    -- optional for floating window border decoration
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
  {
    {
      "hrsh7th/nvim-cmp",
      opts = function(_, opts)
        local cmp = require("cmp")

        opts.sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "buffer" },
          { name = "path" },
          { name = "treesitter" },
        })

        return opts
      end,
    },
  },
  {
    "wfxr/protobuf.vim",
    ft = { "proto" },
  },
  {
    "neovim/nvim-lspconfig",
  },
  {
    "nvim-treesitter/nvim-treesitter-refactor",
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  {
    "nvim-treesitter/nvim-treesitter",
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
  },
  {
    "mg979/vim-visual-multi",
  },
  {
    "ray-x/go.nvim",
    dependencies = {
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("go").setup()
    end,
    event = { "CmdlineEnter" },
    ft = { "go", "gomod" },
    build = ':lua require("go.install").update_all_sync()',
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      filesystem = {
        filtered_items = {
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
  },
  {
    "sindrets/diffview.nvim",
    config = function()
      vim.keymap.set(
        "n",
        "<Leader>dvc",
        ":DiffviewClose<CR>",
        { noremap = true, silent = true, desc = "Close diffview" }
      )
      vim.keymap.set(
        "n",
        "<Leader>dvt",
        ":DiffviewToggleFiles<CR>",
        { noremap = true, silent = true, desc = "Toggle files in diffview" }
      )
      vim.keymap.set(
        "n",
        "<Leader>dvf",
        ":DiffviewFocusFiles<CR>",
        { noremap = true, silent = true, desc = "Focus files in diffview" }
      )
      vim.keymap.set(
        "n",
        "<Leader>dvr",
        ":DiffviewRefresh<CR>",
        { noremap = true, silent = true, desc = "Refresh diffview" }
      )
    end,
  },
}
