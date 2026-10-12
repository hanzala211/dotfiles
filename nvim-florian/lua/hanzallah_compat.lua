vim.g.mapleader = " "

local function toggle_tree()
  vim.cmd("Neotree toggle filesystem left")
end

vim.keymap.set("n", "<leader>e", toggle_tree, {
  silent = true,
  desc = "Toggle file sidebar",
})

local group = vim.api.nvim_create_augroup(
  "HanzallahSidebarShortcut",
  { clear = true }
)

vim.api.nvim_create_autocmd("LspAttach", {
  group = group,
  callback = function(event)
    vim.schedule(function()
      if vim.api.nvim_buf_is_valid(event.buf) then
        vim.keymap.set("n", "<leader>e", toggle_tree, {
          buffer = event.buf,
          silent = true,
          desc = "Toggle file sidebar",
        })
      end
    end)
  end,
})
