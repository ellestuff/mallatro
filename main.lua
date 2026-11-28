Mallatro = {
	data = SMODS.current_mod,
	card_obscured = function(card)
		return not card.config.center.discovered and (card.ability.consumeable or card.config.center.unlocked) and not card.bypass_discovery_center
	end,
	custom_card_areas = {},
	custom_collection_tabs = {},
	resident_sets = {},
	resident_sets_ordered = {},
	
	get_by_sortid = function(id) -- copied from entropy lol
		for i, v in pairs(G.jokers.cards) do
			if v.sort_id == id then return v end
		end
	end,
	should_skip_shop = function()
		return #SMODS.find_card('res_mall_rebecca')>0 -- becca's currently shelved but this is for when she gets into the game properly
	end
}

SMODS.Atlas{
	key="residents",
	path="residents.png",
	px=71, py=95
}

for _, v in ipairs{ -- Lib
	"resident",
	--"overlay_shop"
} do
	assert(SMODS.load_file("lib/"..v..".lua"))()
end

for _, v in ipairs{ -- Residents
	"chloe",
	"furry",
	"41",
	"cheshire"
} do
	assert(SMODS.load_file("residents/"..v..".lua"))()
end

Mallatro.data.custom_card_areas = function(game)
	for _,v in pairs(Mallatro.custom_card_areas) do
		v(game)
	end
end

Mallatro.data.custom_collection_tabs = function()
	local tabs = {}
	for _,v in pairs(Mallatro.custom_collection_tabs) do
		tabs[#tabs+1] = v()
	end
	return tabs
end
