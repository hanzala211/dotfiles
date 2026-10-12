local map = vim.keymap.set
local opts = { silent = true }

map("n", "<leader>fs", "<cmd>Telescope find_files<CR>", opts)
map("n", "<leader>fp", "<cmd>Telescope git_files<CR>", opts)
map("n", "<leader>fz", "<cmd>Telescope live_grep<CR>", opts)
map("n", "<leader>fo", "<cmd>Telescope oldfiles<CR>", opts)
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", opts)
map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", opts)

map("n", "<leader>e", "<cmd>NvimTreeFindFileToggle<CR>", opts)

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(event)
    vim.schedule(function()
      if not vim.api.nvim_buf_is_valid(event.buf) then
        return
      end

      for _, lhs in ipairs({ "<leader>e", "<leader>d" }) do
        pcall(vim.keymap.del, "n", lhs, { buffer = event.buf })
      end
    end)
  end,
})
