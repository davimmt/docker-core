local prayers = {
  {
    "   Santo Deus, Santo Forte,",
    "        Santo Imortal,",
    "     tem piedade de nós.",
  },
  {
    "Jesus Cristo, Filho de Deus,",
    "tem piedade de mim, pecador."
  },
  {
    "   Santíssima Mãe de Deus,",
    "          salva-nos!"
  },
}

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
}

-- http://lua-users.org/wiki/MathLibraryTutorial
math.randomseed(os.time())
math.random(); math.random(); math.random()

local prayers_index = math.random(#prayers)
for i=1, #prayers[prayers_index] do
  table.insert(
    lvim.builtin.alpha.dashboard.section.header.val,
    prayers[prayers_index][i]
  )
end

table.insert(
	lvim.builtin.alpha.dashboard.section.buttons.entries,
	2,
	{ "s", "  Open Last Session", "<cmd>lua require('persistence').load()<cr>" }
)

lvim.plugins = {

	"kdheepak/lazygit.nvim",
	"f-person/git-blame.nvim",

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
