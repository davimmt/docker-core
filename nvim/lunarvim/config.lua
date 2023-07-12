lvim.builtin.alpha.dashboard.section.header.val = {
	"",
	"",
	"",
	"",
	"",
	"             ███",
	"           ███████",
	"             ███",
	"             ███",
	"  ██         ███         ██",
	"█████████████████████████████",
	"  ██         ███         ██",
	"             ███",
	"             ███",
	"             ███",
	"             ███",
	"             ███",
	"             ███",
	"             ███",
	"             ███",
	"             ███",
	"           ███████",
	"             ███",
	"",
	"   Santo Deus, Santo Forte,",
	"        Santo Imortal,",
	"     tem piedade de nós.",
}

table.insert(
	lvim.builtin.alpha.dashboard.section.buttons.entries,
	2,
	{ "s", "  Open Last Session", "<cmd>lua require('persistence').load()<cr>" }
)

lvim.plugins = {

	"kdheepak/lazygit.nvim",
	"f-person/git-blame.nvim",
	"Shatur/neovim-session-manager",

	{
		"folke/persistence.nvim",
		event = "BufReadPre", -- this will only start session saving when an actual file was opened
		opts = {
			dir = vim.fn.expand(vim.fn.stdpath("state") .. "/sessions/"),
			options = { "buffers", "curdir", "tabpages", "winsize" },
		},
	},

	{
		"mg979/vim-visual-multi",
		branch = "master",
		init = function()
			vim.g.VM_maps = {
				["Find Under"] = "<C-d>",
				["Find Subword Under"] = "<C-d>",
			}
		end,
	},

	{
		"folke/flash.nvim",
		event = "VeryLazy",
		opts = {},
		keys = {
			{
				"s",
				mode = { "n", "x", "o" },
				function()
					require("flash").jump({
						search = {
							forward = true,
							wrap = false,
							multi_window = false,
							mode = function(str)
								return "\\<" .. str
							end,
						},
					})
				end,
				desc = "Flash",
			},
			{
				"S",
				mode = { "n", "o", "x" },
				function()
					require("flash").treesitter()
				end,
				desc = "Flash Treesitter",
			},
			{
				"r",
				mode = "o",
				function()
					require("flash").remote()
				end,
				desc = "Remote Flash",
			},
			{
				"R",
				mode = { "o", "x" },
				function()
					require("flash").treesitter_search()
				end,
				desc = "Flash Treesitter Search",
			},
			{
				"<c-s>",
				mode = { "c" },
				function()
					require("flash").toggle()
				end,
				desc = "Toggle Flash Search",
			},
		},
	},
}

-- Close with Q
lvim.lsp.buffer_mappings.normal_mode["Q"] = nil
lvim.keys.normal_mode["Q"] = ":q!<CR>"

-- Terminal
lvim.builtin.terminal.open_mapping = "<c-t>"
lvim.builtin.which_key.mappings["t"] = {
	name = "Terminal",
	v = { "<cmd>ToggleTerm size=80 direction=vertical<cr>", "Vertical Terminal" },
	h = { "<cmd>ToggleTerm size=10 direction=horizontal<cr>", "Horizontal Terminal" },
	f = { "<cmd>ToggleTerm direction=float<cr>", "Floating Terminal" },
}
