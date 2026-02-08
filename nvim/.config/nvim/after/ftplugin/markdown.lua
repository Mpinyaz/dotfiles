if vim.b.quarto_activated then return end
vim.b.quarto_activated = true

require('quarto').activate()
