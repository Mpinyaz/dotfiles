local options = {
  backup = false, -- creates a backup file
  winblend = 30,
  clipboard = { 'unnamedplus' }, -- allows neovim to access the system clipboard
  completeopt = { 'menuone', 'noselect', 'preview' }, -- mostly just for cmp
  fileencoding = 'utf-8', -- the encoding written to a file
  -- listchars = "eol:¬,nbsp:_,tab:  ┊,trail:●,extends:>,space:·,precedes:<",
  listchars = {
    eol = '↲',
    nbsp = '_',
    tab = '  ┊',
    trail = '●',
    extends = '>',
    space = ' ',
    precedes = '<',
  },
  ignorecase = true, -- ignore case in search patterns
  exrc = false,
  -- pumheight = 10,   -- pop up menu height
  wildignore = '.git/**,.hg,.svn,*.pyc,*.o,*.out,*.jpg,*.jpeg,*.png,*.gif,*.zip,**/tmp/**,*.DS_Store,**/node_modules/**,**/bower_modules/**',
  showmode = false, -- we don't need to see things like -- INSERT -- anymore
  showcmd = true,
  syntax = 'enable',
  sessionoptions = 'buffers,curdir,folds,help,tabpages,winsize,winpos,terminal',
  showtabline = 2, -- always show tabs
  smartcase = true,
  smartindent = true, -- make indenting smarter again
  ai = true,
  splitbelow = true, -- force all horizontal splits to go below current window
  spelllang = 'en_us',
  splitright = true, -- force all vertical splits to go to the right of current window
  swapfile = false, -- creates a swapfile
  termguicolors = true, -- set term gui colors (most terminals support this)
  timeoutlen = 1000, -- time to wait for a mapped sequence to complete (in milliseconds)
  formatoptions = 'jqlnt', -- removed 'c', 'r', and 'o'
  writebackup = false, -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
  expandtab = true, -- convert tabs to spaces
  cursorline = true, -- highlight the current line
  number = true, -- set numbered lines
  relativenumber = true, -- set relative numbered lines
  incsearch = true,
  numberwidth = 4, -- set number column width to 2 {default 4}
  signcolumn = 'yes', -- always show the sign column, otherwise it would shift the text each time
  wrap = true, -- display lines as one long line
  scrolloff = 8,
  sidescrolloff = 8,
  ttyfast = true,
  title = true,
  undofile = true,
  list = true,
  autoread = true,
  backspace = { 'indent', 'eol', 'start' },
  autowrite = true,
  hidden = true,
  magic = true,
  updatetime = 500,
  conceallevel = 2,
  cmdheight = 0,
  laststatus = 0,
  fileformats = 'unix,dos,mac',
}

for k, v in pairs(options) do
  vim.opt[k] = v
end
vim.opt.iskeyword:append '-'
vim.opt.errorformat = vim.opt.errorformat - '%f|%l col %c|%m'
vim.fn.mkdir(os.getenv 'HOME' .. '/undodir', 'p')
vim.o.undodir = os.getenv 'HOME' .. '/undodir'
vim.cmd 'set whichwrap+=<,>,[,],h,l'
vim.cmd [[set iskeyword+=-]]
vim.cmd 'filetype plugin indent on'
vim.cmd 'set noswapfile'
vim.cmd [[au BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif ]]

vim.scriptencoding = 'utf-8'
vim.cmd [[let &t_Cs = "\e[4:3m"]]
vim.cmd [[let &t_Ce = "\e[4:0m"]]
vim.opt.path:append { '**' } -- Finding files - Search down into subfolders
vim.g.python3_host_prog = vim.fn.expand '~/.virtualenvs/neovim/bin/python3'
