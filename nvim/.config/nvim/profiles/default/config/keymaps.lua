local opts = { noremap = true, silent = true }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap

--Remap space as leader key
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', opts)

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Normal --
-- Better window navigation
keymap('n', '<C-h>', '<C-w>h', opts)
keymap('n', '<C-j>', '<C-w>j', opts)
keymap('n', '<C-k>', '<C-w>k', opts)
keymap('n', '<C-l>', '<C-w>l', opts)
keymap('n', '<leader>lq', ':copen<CR>', { desc = 'Open Quick fix list' })
-- Resize with arrows
keymap('n', '<C-Up>', ':resize -2<CR>', opts)
keymap('n', '<C-Down>', ':resize +2<CR>', opts)
keymap('n', '<C-Left>', ':vertical resize -2<CR>', opts)
keymap('n', '<C-Right>', ':vertical resize +2<CR>', opts)
keymap('n', '<tab>', ':tabnext<Return>', opts)
keymap('n', '<s-tab>', ':tabprev<Return>', opts)
-- Naviagate buffers
keymap('n', '<S-l>', ':bnext<CR>', opts)
keymap('n', '<S-h>', ':bprevious<CR>', opts)
keymap('n', '<C-x>', ':bd<CR>', opts)
keymap('n', '<C-n>', ':tabnew<new><CR>', opts)
-- Insert --
-- Press jk fast to exit insert mode
keymap('i', 'jk', '<ESC>', opts)
keymap('i', '<S-Tab>', '<C-d>', opts)
-- Spell check correct
-- Visual --
-- Stay in indent mode
keymap('i', '<F2>', '<Esc>mti<C-X>s<Esc>`tla', opts)
keymap('v', '<', '<gv', opts)
keymap('v', '>', '>gv', opts)
keymap('n', '<M-k>', ':m .-2<CR>==', { desc = 'Move line up' })
keymap('n', '<M-j>', ':m .+1<CR>==', { desc = 'Move line down' })
keymap('v', '<M-k>', ':m .-2<CR>==', { desc = 'Move line up' })
keymap('v', '<M-j>', ':m .+1<CR>==', { desc = 'Move line down' })
keymap('n', '<leader>bu', '<cmd>Telescope buffers<cr>', opts)
keymap('n', '<leader>dl', '<cmd>Telescope diagnostics<cr>', opts)
keymap('n', '<leader>o', '<cmd>Telescope current_buffer_fuzzy_find<cr>', opts)
vim.keymap.set({ 'n', 'v', 'i' }, '<C-x><C-f>', function() require('fzf-lua').complete_path() end, opts)
keymap('n', '<F1>', [[:let _s=@/ <Bar> :%s/\s\+$//e <Bar> :let @/=_s <Bar> :nohl <Bar> :unlet_s <cr>}]], { silent = true })

-- Select all
keymap('n', '<C-y>', 'gg<S-v>G', opts)
keymap('n', '<C-a>', ':%y+<CR>', opts)
-- New tab
keymap('n', 'te', ':tabedit<cr>', opts)
keymap('n', '<leader>x', '<cmd>!chmod +x %<CR>', opts)

-- vim.keymap.set('n', '<leader>qf', vim.lsp.buf.format, { remap = false })
-- All previous macros have been changed to autocmd, <F2> macro will run current file

vim.keymap.set('n', '<leader>sv', '<C-w>v', { desc = 'Split window vertically' })
-- split window vertically
vim.keymap.set('n', '<leader>sh', '<C-w>s', { desc = 'Split window horizontally' })
-- split window horizontally
vim.keymap.set('n', '<leader>se', '<C-w>=', { desc = 'Make splits equal size' }) -- make split windows equal width & height
-- close current split window
vim.keymap.set('n', '<leader>sx', '<cmd>close<CR>', { desc = 'Close current split' })

-- map leader+w to save current file in normal mode
vim.keymap.set('n', 'WW', ':w!<enter>', { noremap = true, silent = true })
vim.keymap.set('n', 'QQ', ':q!<enter>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>W', 'mzgg=G`z<cmd>w<CR>', { desc = 'Auto-indent and save' })
vim.keymap.set('n', '<leader>w', '<cmd>w<CR>')
vim.keymap.set(
  'n',
  '<leader>yp',
  ':let @+ = expand("%:p")<CR>:lua print("Copied path to: " .. vim.fn.expand("%:p"))<cr>',
  { noremap = true, silent = true, desc = 'Copy current file name and path to clipboard' }
)
vim.keymap.set('n', '<Leader>fr', [[:%s/\<<C-r><C-w>\>//g<Left><Left>]])

vim.keymap.set(
  'i',
  '<c-p>',
  function() require('telescope.builtin').registers() end,
  { remap = true, silent = false, desc = 'copy and paste register in insert mode' }
)

-- map leader+y to copy to system clipboard in normal and visual mode
vim.keymap.set({ 'n', 'v' }, '<Leader>y', '"+y', { noremap = true, silent = true })

vim.keymap.set({ 'n', 'v' }, 'wq', ':wq<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<BS>', '^', { desc = 'Move to the first character of the line' })
vim.keymap.set('n', '<leader>/', ':nohlsearch<CR>', { desc = 'Clear highlights' })
vim.keymap.set('n', '<leader>ss', ':s/', { desc = 'Search and replace' })
vim.keymap.set('n', '<leader>SS', ':%s/', { desc = 'Search and replace' })
vim.keymap.set('n', '<leader><c-s>', ':%s/\\%V', { desc = 'Search and replace' })
vim.keymap.set('n', '<leader>pa', 'ggVGp', { desc = 'Search and paste' })
vim.keymap.set('n', '<leader>rw', '*``cgn', { desc = 'replace word under the cursor' })
vim.keymap.set('n', '<leader>rW', '#``cgn', { desc = 'replace word under the cursor' })
vim.keymap.set('n', '<leader>lu', '<cmd>:Lazy update<cr>', { desc = 'update plugins' })

vim.keymap.set('x', '<leader>p', [["_dP]])
vim.keymap.set({ 'n', 'v' }, '<leader>y', [["+y]])
vim.keymap.set({ 'n', 'v' }, '<leader>d', [["_d]])

vim.keymap.set('n', '<localleader>ip', function()
  local venv = os.getenv 'VIRTUAL_ENV' or os.getenv 'CONDA_PREFIX'
  if venv ~= nil then
    -- in the form of /home/benlubas/.virtualenvs/VENV_NAME
    venv = string.match(venv, '/.+/(.+)')
    vim.cmd(('MoltenInit %s'):format(venv))
  else
    vim.cmd 'MoltenInit python3'
  end
end, { desc = 'Initialize Molten for python3', silent = true })
