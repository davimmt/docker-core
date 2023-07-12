local cross = {
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

local prayers = {

	{
		"   Santo Deus, Santo Forte,",
		"        Santo Imortal,",
		"     tem piedade de nós.",
	},

	{
		" Jesus Cristo, Filho de Deus,",
		" tem piedade de mim, pecador.",
	},

	{
		"     Senhor, tem piedade.",
	},

	{
		"   Santíssima Mãe de Deus,",
		"          salva-nos!",
	},

	{
		"     É digno, em verdade,",
		"         bendizer-te,",
		"   ó sempre bem-aventurada",
		"       e toda-imaculada",
		"      Mãe do nosso Deus.",
	},
}

-- http://lua-users.org/wiki/MathLibraryTutorial
math.randomseed(os.time())
math.random()
math.random()
math.random()

local prayers_index = math.random(#prayers)
for i = 1, #prayers[prayers_index] do
	table.insert(cross, prayers[prayers_index][i])
end

return {
	{
		"goolord/alpha-nvim",
		opts = function(_, opts)
			opts.section.header.val = cross
			opts.config.layout[3].val = 2
		end,
	},
	-- TODO: find out how to center text below dashboard (prayers) independently
	-- {
	-- 	"goolord/alpha-nvim",
	-- 	requires = { "nvim-tree/nvim-web-devicons" },
	-- 	config = function()
	-- 		local alpha = require("alpha")
	-- 		local dashboard = require("alpha.themes.dashboard")
	--
	-- 		-- dashboard.section.header.opts.position.val = "left"
	--
	-- 		dashboard.section.buttons.val = {
	-- 			dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
	-- 			dashboard.button("q", "  Quit NVIM", ":qa<CR>"),
	-- 		}
	--
	-- 		table.insert(dashboard.section.buttons.entries,
	-- 			dashboard.button("f", "F  Quit NVIM", ":qa<CR>"),
	-- 		)
	--
	-- 		alpha.setup(dashboard.config)
	-- 	end,
	-- },
}
