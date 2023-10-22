
local opt = { noremap = true, silent = true }
local keymaps = vim.keymap
-- local wk = require("which-key")
-- set keycut of spilt windows and switch windows
keymaps.set("n", "<C-l>", "<C-w>l", opt)
keymaps.set("n", "<C-h>", "<C-w>h", opt)
keymaps.set("n", "<C-j>", "<C-w>j", opt)
keymaps.set("n", "<C-k>", "<C-w>k", opt)
keymaps.set("n", "<leader>v", "<C-w>v", opt)
keymaps.set("n", "<leader>s", "<C-w>s", opt)
-- wk.register()
-- map jk and kj to <Esc>
keymaps.set("i", "jk", "<Esc>", opt)
keymaps.set("i", "kj", "<Esc>", opt)
-- easily 
keymaps.set("n", "j", [[v:count ? 'j' : 'gj']], { noremap = true, expr = true})
keymaps.set("n", "k", [[v:count ? 'k' : 'gk']], { noremap = true, expr = true})
-- Lazy
keymaps.set("n", "<leader>l", ":Lazy<CR>", opt)
-- bufferline Tab switch
keymaps.set("n", "H", ":BufferLineCyclePrev<CR>", opt)
keymaps.set("n", "L", ":BufferLineCycleNext<CR>", opt)

