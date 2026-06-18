return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  dependencies = { 'amansingh-afk/milli.nvim' },
  keys = {
    {
      '<leader>lg',
      function() Snacks.lazygit() end,
      desc = 'Lazygit',
    },
    {
      '<leader>gh',
      function() Snacks.picker.gh_issue { state = 'all' } end,
      desc = 'GitHub Issues',
    },
    {
      '<leader>gl',
      function() Snacks.lazygit.log() end,
      desc = 'Lazygit Log (cwd)',
    },
    {
      '<leader>nh',
      function() Snacks.notifier.show_history() end,
      desc = 'Notification History',
    },
    {
      '<Leader>nd',
      function() Snacks.notifier.hide() end,
      desc = 'Dismiss All Notifications',
    },
    {
      '<leader>gb',
      function() Snacks.gitbrowse() end,
      desc = 'Git Browse',
    },
    {
      '<leader>gB',
      function() Snacks.git.blame_line() end,
      desc = 'Git Blame Line',
    },
    {
      '<leader>k',
      function() Snacks.picker.keymaps() end,
      desc = 'Keymaps',
    },
    {
      '<leader>fR',
      function() Snacks.rename.rename_file() end,
      desc = 'Rename File',
    },
    {
      ']]',
      function() Snacks.words.jump(vim.v.count1) end,
      desc = 'Next Reference',
    },
    {
      '[[',
      function() Snacks.words.jump(-vim.v.count1) end,
      desc = 'Prev Reference',
    },
    { '<leader>.', function() Snacks.scratch() end, desc = 'Toggle Scratch Buffer' },
  },
  ---@type snacks.Config
  opts = function()
    local splash = require('milli').load { splash = 'skulltwo' }
    return {
      dashboard = {
        enabled = true,
        preset = {
          -- FIXED HERE: Now properly targets strings instead of a nested table
          header = table.concat(splash.frames[1], '\n'),
        },
        sections = {
          { section = 'header', padding = 1 },
          { section = 'keys', gap = 1, padding = 1 },
          { section = 'startup' },
        },
      },
      gh = { enabled = true },
      lazygit = { enabled = true },
      bigfile = { enabled = true },
      notifier = { enabled = true, timeout = 5000, style = 'fancy', top_down = false },
      toggle = { enabled = true },
      terminal = { enabled = true },
      scratch = { enabled = true },

      styles = {
        notification = {
          wo = { wrap = true },
        },
      },
      scroll = {
        animate = {
          duration = { step = 15, total = 250 },
          easing = 'linear',
        },
        filter = function(buf) return vim.g.snacks_scroll ~= false and vim.b[buf].snacks_scroll ~= false end,
      },
    }
  end,
  config = function(_, opts)
    require('snacks').setup(opts)
    require('milli').snacks { splash = 'skulltwo', loop = true }

    vim.keymap.set(
      { 'n', 't' },
      '<leader>ld',
      function()
        Snacks.terminal.toggle('lazydocker', {
          win = {
            position = 'float',
            border = 'rounded',
            width = 0.9,
            height = 0.9,
          },
        })
      end,
      { desc = 'Lazydocker (Snacks)' }
    )

    vim.keymap.set(
      { 'n', 't' },
      '<C-\\>',
      function()
        Snacks.terminal.toggle(nil, {
          win = {
            position = 'float',
            border = 'rounded',
          },
        })
      end,
      { desc = 'Toggle Terminal' }
    )

    vim.api.nvim_create_user_command('Gbrowse', function() Snacks.gitbrowse() end, {})
    vim.api.nvim_create_user_command('Gitbranch', function() Snacks.gitbrowse.open { what = 'branch' } end, { desc = 'Open branch in origin git site' })

    vim.api.nvim_create_user_command('Gitrepo', function() Snacks.gitbrowse.open { what = 'repo' } end, { desc = 'Open repo root in origin git site' })
    vim.notify = Snacks.notifier

    ---@type table<number, {token:lsp.ProgressToken, msg:string, done:boolean}[]>
    local progress = vim.defaulttable()
    vim.api.nvim_create_autocmd('LspProgress', {
      callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        local value = ev.data.params.value
        if not client or type(value) ~= 'table' then return end
        local p = progress[client.id]

        for i = 1, #p + 1 do
          if i == #p + 1 or p[i].token == ev.data.params.token then
            p[i] = {
              token = ev.data.params.token,
              msg = ('[%3d%%] %s%s'):format(
                value.kind == 'end' and 100 or value.percentage or 100,
                value.title or '',
                value.message and (' **%s**'):format(value.message) or ''
              ),
              done = value.kind == 'end',
            }
            break
          end
        end

        local msg = {}
        progress[client.id] = vim.tbl_filter(function(v) return table.insert(msg, v.msg) or not v.done end, p)

        local spinner = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' }
        vim.notify(table.concat(msg, '\n'), 'info', {
          id = 'lsp_progress',
          title = client.name,
          opts = function(notif) notif.icon = #progress[client.id] == 0 and ' ' or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1] end,
        })
      end,
    })
  end,
}
