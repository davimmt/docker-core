local plugins = {
	{ "tpope/vim-fugitive", event = "VeryLazy" },
	{ "tpope/vim-surround", event = "VeryLazy" },
	{ "hashivim/vim-terraform", ft = { "tf", "terraform" } },
  {
    'Shatur/neovim-session-manager',
    event = 'VimEnter',
    config = function()
      require('session_manager').setup({
        autoload_mode = 'Disabled' -- Define what to do when Neovim is started without arguments [Disabled, CurrentDir, LastSession].
      })
    end,
  },
	{
		"kdheepak/lazygit.nvim",
    event = "VeryLazy",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
	},
	{
		"akinsho/toggleterm.nvim",
    event = "VeryLazy",
		opts = {
			open_mapping = [[<C-t>]],
		},
	},
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    },
  },
	{
		"mg979/vim-visual-multi",
		branch = "master",
		event = "VeryLazy",
		init = function()
			vim.g.VM_maps = {
				["Find Under"] = "<C-d>",
				["Find Subword Under"] = "<C-d>",
			}
		end,
	},
  {
    'glepnir/dashboard-nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    event = 'VimEnter',
    config = function()
      local icon = require "custom.utils.icons"
      local prayer = require "custom.utils.prayers"
      table.insert(icon, 1, '')
      table.insert(icon, '')
      table.insert(prayer, 1, '')
      table.insert(prayer, 1, '')
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
          disable_move = true,
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
          mru = { limit = 5, },
          footer = prayer
        }
      }
    end,
  },
  -- {
  --   "goolord/alpha-nvim",
  --   event = "VimEnter",
  --   cmd = "Alpha",
  --   config = function ()
  --     local alpha = require'alpha'
  --     local startify = require'alpha.themes.startify'
  --     local icon = require "custom.utils.icons"
  --     local prayer = require "custom.utils.prayers"
  --     startify.section.header.val = icon
  --     startify.section.top_buttons.val = {
  --       startify.button("f", "  Find files" , ":Telescope find_files<CR>"),
  --       startify.button("s", " Load Last Session" , ":SessionManager load_last_session<CR>"),
  --     }
  --     startify.section.bottom_buttons.val = {
  --       startify.button("q", "󰅚  Quit NVIM" , ":qa<CR>"),
  --     }
  --     startify.section.footer.val = {
  --       { type = "text", val = prayer },
  --     }
  --
  --     alpha.setup(startify.config)
  --   end
  --   -- opts = function()
  --   --   local icon = require "custom.utils.icons"
  --   --   local dashboard = require "alpha.themes.startify"
  --   --   dashboard.section.header.val = icon
  --   --   dashboard.section.header.opts.hl = "DashboardHeader"
  --   --
  --   --   dashboard.config.layout[1].val = 1 -- vim.fn.max { 2, vim.fn.floor(vim.fn.winheight(0) * 0.2) }
  --   --   dashboard.config.layout[3].val = 2
  --   --   dashboard.config.opts.noautocmd = true
  --   --   return dashboard
  --   -- end,
  --   -- config = function(_, opts)
  --   --   local prayer = require "custom.utils.prayers"
  --   --   require("alpha").setup(opts.config)
  --   --
  --   --   vim.api.nvim_create_autocmd("User", {
  --   --     once = true,
  --   --     callback = function()
  --   --       -- table.insert(prayer, 1, "")
  --   --       opts.section.footer.val = prayer
  --   --       pcall(vim.cmd.AlphaRedraw)
  --   --     end,
  --   --   })
  --   -- end,
  -- },
}

return plugins
