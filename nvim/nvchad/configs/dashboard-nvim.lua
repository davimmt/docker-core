local icon = require "custom.utils.icons"
local prayer = require "custom.utils.prayers"
table.insert(icon, 1, '')
table.insert(icon, '')
table.insert(prayer, 1, '')
table.insert(prayer, 1, '')

local config = {
  require('dashboard').setup {
    theme = 'hyper',
    shortcut_type = 'number',
    change_to_vcs_root = true,
    disable_move = true,
    hide = {
      tabline = true,
      winbar  = true,
    },
    config = {
      header = icon,
      packages = { enable = false },
      disable_move = false,
      week_header = {
        enable = false,
        concat = "",
        append = {""},
      },
      shortcut = {
        { desc = '󰊳 Lazy', group = '@property', action = 'Lazy', key = 'L' },
        { desc = ' Session', group = 'Label', action = 'SessionManager load_last_session', key = 's' },
        { desc = ' Files', group = 'Label', action = 'Telescope find_files',  key = 'f', },
      },
      project = { enable = true, limit = 3, },
      mru = { limit = 5, },
      footer = prayer
    }
  }
}

return config
