return {
  -- 🎨 1. Gruvbox Theme
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    config = function()
      require("gruvbox").setup({ transparent_mode = true, contrast = "hard" })
      vim.cmd("colorscheme gruvbox")
    end,
  },

  -- 🗂️ 2. Bufferline
  {
    'akinsho/bufferline.nvim',
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
      require("bufferline").setup{ options = { diagnostics = "nvim_lsp", show_buffer_close_icons = false, show_close_icon = false } }
    end
  },

  -- 🌳 3. File Explorer
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup { view = { width = 30 }, renderer = { group_empty = true } }
      vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', { desc = 'Toggle Explorer' })
    end,
  },

  -- 📏 4. Indent Guides
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = { indent = { char = "│" }, scope = { enabled = false } },
  },

  -- 🤖 5. Supermaven AI Autocomplete
  {
    "supermaven-inc/supermaven-nvim",
    config = function()
      require("supermaven-nvim").setup({
        keymaps = { accept_suggestion = "<Tab>", clear_suggestion = "<C-]>", accept_word = "<C-j>" },
        color = { suggestion_color = "#808080", cterm = 244 }
      })
    end,
  },

  -- 🗄️ 6. Dadbod Database UI
  {
    'kristijanhusak/vim-dadbod-ui',
    dependencies = {
      { 'tpope/vim-dadbod', lazy = true },
      { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true },
    },
    cmd = { 'DBUI', 'DBUIToggle', 'DBUIAddConnection', 'DBUIFindBuffer' },
    init = function()
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_execute_on_save = 0
    end,
  },

  -- 💻 7. ToggleTerm (The pop-up terminal)
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup({
        size = 20,
        open_mapping = [[<C-\>]], -- Press Ctrl + \ to open/close
        direction = "float",      -- Makes it a floating window
        float_opts = {
          border = "curved",      -- Gives it that smooth look from the screenshot
          winblend = 0,
        },
      })
    end
  },
}
