Mallatro = {
	data = SMODS.current_mod,
	card_obscured = function(card)
		return not card.config.center.discovered and (card.ability.consumeable or card.config.center.unlocked) and not card.bypass_discovery_center
	end,
	custom_card_areas = {},
	custom_collection_tabs = {},
	resident_sets = {},
	resident_sets_ordered = {}
}

SMODS.Atlas{
	key="residents",
	path="residents.png",
	px=71, py=95
}

assert(SMODS.load_file("resident.lua"))()
assert(SMODS.load_file("residents/chloe.lua"))()

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