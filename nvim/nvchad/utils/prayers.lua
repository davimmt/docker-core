local prayers = {
	{
		"Santo Deus, Santo Forte, Santo Imortal, tem piedade de nós.",
	},

	{
		"Jesus Cristo, Filho de Deus, tem piedade de mim, pecador.",
	},

	{
		"Senhor, tem piedade.",
	},

	{
		"Santíssima Mãe de Deus, salva-nos!",
	},

	{
		"  Mais honrada que os Querubins, e incomparavelmente mais gloriosa que os Sefarins,",
		"verdadeiramente deste luz ao Deus Verbo. Verdadeira Mãe de Deus, nós te magnificamos.",
	},

	{
		"É digno, em verdade, bendizer-te, ó sempre bem-aventurada e toda-imaculada Mãe do nosso Deus.",
	},
}

-- http://lua-users.org/wiki/MathLibraryTutorial
math.randomseed(os.time())
math.random()
math.random()
math.random()

return prayers[math.random(#prayers)]
