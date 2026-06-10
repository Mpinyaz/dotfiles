return {
  cmd = {
    'clangd',
    '--background-index',
    '--suggest-missing-includes',
    '--clang-tidy',
    '--completion-style=detailed',
    '--function-arg-placeholders',
    '--header-insertion=iwyu',
  },
  root_markers = {
    '.clangd',
    '.clang-format',
    'compile_commands.json',
    'compile_flags.txt',
  },
  filetypes = { 'c', 'cpp', 'json' },
  init_options = {
    clangdFileStatus = true,
    usePlaceholders = true,
    -- Disabled unimported to prevent clangd from pulling global C++ symbols into C files
    completeUnimported = false,
    semanticHighlighting = true,
  },
  settings = {
    clangd = {
      InlayHints = {
        Designators = true,
        Enabled = true,
        ParameterNames = true,
        DeducedTypes = true,
      },
    },
  },
  -- Dynamically inject standard flags based on the active filetype
  on_new_config = function(new_config, _)
    if vim.bo.filetype == 'c' then
      new_config.init_options.fallbackFlags = { '-std=c17' }
    else
      new_config.init_options.fallbackFlags = { '-std=c++20' }
    end
  end,
  -- Properly negotiates the encoding format to prevent modern Neovim client warnings
  on_init = function(client) client.offset_encoding = 'utf-16' end,
}
