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
		"Jesus Cristo, Filho de Deus,",
		"tem piedade de mim, pecador.",
	},
	{
		"   Santíssima Mãe de Deus,",
		"          salva-nos!",
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
		end,
	},
}
