return {
  "nvim-treesitter/nvim-treesitter-refactor",
  config = function()
    require("nvim-treesitter.configs").setup({
      auto_install = true,
      refactor = {
        highlight_definitions = {
          enable = true,
        },
        navigation = {
          enable = true,
          keymaps = {
            goto_definitions = "<Leader>gtd",
            list_definition = "<Leader>lds",
            list_definitions_toc = "<Leader>ldt",
            goto_next_usage = "<Leader>gtn",
            goto_previous_usage = "<Leader>gtp",
          },
        },
      },
    })
  end,
}
