local opts = { noremap = true, silent = true }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap

--Remap space as leader key
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Normal --
-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Resize with arrows
keymap("n", "<C-Up>", ":resize -2<CR>", opts)
keymap("n", "<C-Down>", ":resize +2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)
keymap("n", "<tab>", ":tabnext<Return>", opts)
keymap("n", "<s-tab>", ":tabprev<Return>", opts)
-- Naviagate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)
keymap("n", "<C-x>", ":bd<CR>", opts)
keymap("n", "<C-n>", ":tabnew<new><CR>", opts)
-- Insert --
-- Press jk fast to exit insert mode
keymap("i", "jk", "<ESC>", opts)
keymap("i", "<S-Tab>", "<C-d>", opts)
-- Spell check correct
-- Visual --
-- Stay in indent mode
keymap("i", "<F2>", "<Esc>mti<C-X>s<Esc>`tla", opts)
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)
--Telescope keymaps
keymap("n", "<leader>s", "<cmd>Telescope find_files<cr>", opts)
keymap("n", "<M-k>", ":m .-2<CR>==", { desc = "Move line up" })
keymap("n", "<M-j>", ":m .+1<CR>==", { desc = "Move line down" })
keymap("v", "<M-k>", ":m .-2<CR>==", { desc = "Move line up" })
keymap("v", "<M-j>", ":m .+1<CR>==", { desc = "Move line down" })
keymap("n", "<leader>bu", "<cmd>Telescope buffers<cr>", opts)
keymap("n", "<leader>dl", "<cmd>Telescope diagnostics<cr>", opts)
keymap("n", "<leader>f", "<cmd>Telescope file_browser<cr>", opts)
keymap("n", "<leader>o", "<cmd>Telescope current_buffer_fuzzy_find<cr>", opts)
keymap(
        "n",
        "<F1>",
        [[:let _s=@/ <Bar> :%s/\s\+$//e <Bar> :let @/=_s <Bar> :nohl <Bar> :unlet_s <cr>}]],
        { silent = true }
)

-- Select all
keymap("n", "<C-y>", "gg<S-v>G", opts)
keymap("n", "<C-a>", ":%y+<CR>", opts)
-- New tab
keymap("n", "te", ":tabedit<cr>", opts)
keymap("n", "<leader>x", "<cmd>!chmod +x %<CR>", opts)

vim.keymap.set("n", "<leader>qf", vim.lsp.buf.format, { remap = false })
-- All previous macros have been changed to autocmd, <F2> macro will run current file

vim.cmd([[
augroup run_file
autocmd BufEnter *.java let @g=":w\<CR>:vsp | terminal java %\<CR>i"
autocmd BufEnter *.py let @g=":w\<CR>:vsp |terminal python %\<CR>i"
autocmd BufEnter *.asm let @g=":w\<CR> :!nasm -f elf64 -o out.o % && ld out.o -o a.out \<CR> | :vsp |terminal ./a.out\<CR>i"
autocmd BufEnter *.cpp let @g=":w\<CR> :!g++ -std=c++17 -O3 %\<CR> | :vsp |terminal ./a.out\<CR>i"
autocmd BufEnter *.c let @g=":w\<CR> :!gcc -O3 -std=c99 -Wno-deprecated-declarations -pedantic -Wall -Wextra %\<CR> | :vsp |terminal ./a.out\<CR>i"
autocmd BufEnter *.go let @g=":w\<CR> :vsp | terminal go run % \<CR>i"
autocmd BufEnter *.js let @g=":w\<CR> :vsp | terminal node % \<CR>i"
autocmd BufEnter *.rs let @g=":w\<CR> :vsp | terminal cargo run  \<CR>i"
augroup end
]])

-- map leader+w to save current file in normal mode
vim.keymap.set("n", "WW", ":w!<enter>", { noremap = true, silent = true })
vim.keymap.set("n", "QQ", ":q!<enter>", { noremap = true, silent = true })
vim.keymap.set('n', "<leader>w", "mzgg=G`z<cmd>w<CR>")
vim.keymap.set(
        "n",
        "<leader>cpf",
        ':let @+ = expand("%:p")<CR>:lua print("Copied path to: " .. vim.fn.expand("%:p"))<cr>',
        { noremap = true, silent = true, desc = "Copy current file name and path to clipboard" }
)
vim.keymap.set("n", "<Leader>fr", [[:%s/\<<C-r><C-w>\>//g<Left><Left>]])

vim.keymap.set("i", "<c-p>", function()
        require("telescope.builtin").registers()
end, { remap = true, silent = false, desc = "copy and paste register in insert mode" })

-- map leader+y to copy to system clipboard in normal and visual mode
vim.keymap.set({ "n", "v" }, "<Leader>y", '"+y', { noremap = true, silent = true })

vim.keymap.set({ "n", "v" }, "wq", ":wq<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<BS>", "^", { desc = "Move to the first character of the line" })
vim.keymap.set("n", "<leader>/", ":nohlsearch<CR>", { desc = "Clear highlights" })
vim.keymap.set("n", "<leader>ss", ":s/", { desc = "Search and replace" })
vim.keymap.set("n", "<leader>SS", ":%s/", { desc = "Search and replace" })
vim.keymap.set("n", "<leader><c-s>", ":%s/\\%V", { desc = "Search and replace" })
vim.keymap.set("n", "<leader>pa", "ggVGp", { desc = "Search and paste" })
vim.keymap.set("n", "<leader>rw", "*``cgn", { desc = "replace word under the cursor" })
vim.keymap.set("n", "<leader>rW", "#``cgn", { desc = "replace word under the cursor" })
vim.keymap.set("n", "<leader>lu", "<cmd>:Lazy update<cr>", { desc = "update plugins" })

vim.keymap.set("x", "<leader>p", [["_dP]])
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])
