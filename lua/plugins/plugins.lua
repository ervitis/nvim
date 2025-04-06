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
    "saghen/blink.cmp",
    version = "*",
    config = function()
      require("blink.cmp").setup({
        keymap = {
          ["<M-CR>"] = { "accept" },
          ["<C-n>"] = { "select_next" },
          ["<C-p>"] = { "select_prev" },
        },
      })
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
      "saghen/blink.cmp",
    },
    config = function()
      require("blink.cmp").setup({})

      require("mason").setup()

      local capabilities = require("blink.cmp").get_lsp_capabilities()

      require("mason-lspconfig").setup({
        automatic_installation = true,
        ensure_installed = {
          "pyright",
          "lua_ls",
          "bashls",
          "yamlls",
          "gopls",
          "jsonls",
          "taplo",
          "solargraph",
          "terraformls",
          "tflint",
        },
        handlers = {
          ["lua_ls"] = function()
            require("lspconfig").lua_ls.setup({
              capabilities = capabilities,
              settings = {
                Lua = {
                  diagnostics = {
                    globals = { "vim" },
                  },
                },
              },
            })
          end,
          ["gopls"] = function()
            require("lspconfig").gopls.setup({
              capabilities = capabilities,
              settings = {
                gopls = {
                  buildFlags = { "-tags=integration,reports" },
                  gofumpt = true,
                  analyses = {
                    unusedparams = true,
                    fillstruct = true,
                  },
                  staticcheck = false,
                  usePlaceholders = true,
                  completeUnimported = true,
                  symbolStyle = "Dynamic",
                  semanticTokens = true,
                  codelenses = {
                    gc_details = true,
                    regenerate_cgo = true,
                    generate = true,
                    test = true,
                    tidy = true,
                  },
                  hints = {
                    constantValues = true,
                    functionTypeParameters = true,
                    rangeVariableTypes = true,
                  },
                },
              },
            })
          end,
          function(server_name)
            require("lspconfig")[server_name].setup({ capabilities = capabilities })
          end,
        },
      })

      -- Keybindings
      vim.keymap.set("n", "<Leader>fs", "<Cmd>GoFillStruct<Cr>", { desc = "Fill the golang struct" })
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
          enabled = true,
          enable_commands = true,
          all_references = false,
          text_prefix = " -> ",
          separator = ", ",
          error_prefix = "x ",
          info_prefix = "[] ",
          all_frames = false,
          commented = false,
          highlight_changed_variables = true,
          highlight_new_as_changed = false,
          show_stop_reason = true,
          only_first_definition = true,
          clear_on_continue = false,
          virt_lines = false,
          virt_lines_above = false,
          virt_text_pos = false,
          filter_references_pattern = "",
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
          require("dapui").eval(nil, { enter = true, context = "", width = 40, height = 10 })
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
    "nvim-telescope/telescope.nvim",
    opts = {
      defaults = {
        hidden = true,
        file_ignore_patterns = {
          "node_modules/.*",
          "%.git/.*",
          "build/.*",
          "dist/.*",
          "yarn.lock",
          ".DS_Store",
          "%.cache/.*",
          "%.npm/.*",
        },
        vimgrep_arguments = {
          "rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
          "--hidden",
        },
      },
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
    "wfxr/protobuf.vim",
    ft = { "proto" },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "saghen/blink.cmp",
    },
    opts = {
      servers = {
        solargraph = {},
      },
    },
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
  },
  {
    "nvim-treesitter/nvim-treesitter-refactor",
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  {
    "nvim-treesitter/nvim-treesitter",
    config = function()
      require("nvim-treesitter.configs").setup({
        highlight = {
          enable = true,
        },
        ensure_installed = {
          "vimdoc",
          "luadoc",
          "vim",
          "lua",
          "markdown",
          "go",
          "python",
          "hcl",
          "yaml",
          "sql",
          "ruby",
          "toml",
        },
        sync_install = false,
        auto_install = true,
        ignore_install = {},
        modules = {},
      })
    end,
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

      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.go",
        callback = function(event)
          local params = vim.lsp.util.make_range_params(event.buf, "utf-16")
          params.context = { only = { "source.organizeImport" } }

          local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 900)

          for client_id, res in pairs(result or {}) do
            for _, r in pairs(res.result or {}) do
              if r.edit then
                local enc = (vim.lsp.get_client_by_id(client_id) or {}).offset_encoding or "utf-16"
                vim.lsp.util.apply_workspace_edit(r.edit, enc)
              end
            end
          end

          vim.lsp.buf.format({ async = false })
        end,
      })
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
  {
    "andythigpen/nvim-coverage",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      local function find_coverage_files()
        local cf = vim.fn.glob("**/coverage.out", true, true)
        if #cf > 0 then
          return cf[1]
        end
        return nil
      end

      require("coverage").setup({
        lang = {
          go = {
            coverage_file = find_coverage_files(),
          },
        },
      })

      vim.keymap.set("n", "<Leader>ccs", ":Coverage<CR>", { desc = "Show Coverage" })
      vim.keymap.set("n", "<Leader>cch", ":CoverageHide<CR>", { desc = "Hide Coverage" })
      vim.keymap.set("n", "<Leader>cct", ":CoverageToggle<CR>", { desc = "Toggle Coverage" })
    end,
  },
  {
    "jjo/vim-cue",
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        cue = { "cue_fmt" },
      },
    },
  },
}
