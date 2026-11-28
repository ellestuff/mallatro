Mallatro.Resident = SMODS.Center:extend{
	unlocked = true,
	discovered = true,
	atlas = "mall_residents",
	pos = { x = 0, y = 0 },
	cost = 12,
	config = {},
	blueprint_compat = true,
	set = "mall_Resident",
	attributes = {},
	class_prefix = "res",
	required_params = { "key" },
	pre_inject_class = function(self)
		G.P_CENTER_POOLS[self.set] = {}
	end,
	set_card_type_badge = function(self, card, badges)
		if card.ability.res_active then
			local bar = create_badge("",
				G.C.BLACK, G.C.WHITE,.8)
			print(bar.nodes[1])
			bar.nodes[1].nodes = nil
			bar.nodes[1].config.card = card
			bar.nodes[1].config.shader = {
				shader = "mall_active"
			}
			badges[#badges + 1] = bar
		end

		badges[#badges + 1] = create_badge(self.res_visitor and localize(type(self.res_visitor)=="string" and self.res_visitor or 'k_mall_visitor') or localize('k_mall_resident'),
			not Mallatro.card_obscured(card) and self.res_colour or get_type_colour(card.config.center or card.config, card), G.C.WHITE,1.2)
		badges[#badges + 1] = create_badge(localize('mall_res_set_'..self.res_set),
			Mallatro.resident_sets[self.res_set].colour, G.C.WHITE,.8)
	end,
	inject = function(self)
		-- call the parent function to ensure all pools are set
		SMODS.Center.inject(self)
		G.ARGS.LOC_COLOURS[self.key] = self.res_colour
	end,
	res_colour = HEX("a86de2"),
	res_visitor = false,
	res_set = "canon",
	no_run_select = false,
	res_can_active = function(self,card)
		return card.ability.res_active <= card.ability.res_charges
	end,
	set_ability = function(self,card,initial,delay_sprites)
		if card.ability.res_active then
			card.ability.res_active.charges = card.ability.res_active.max
		end
	end
}
G.C.SET.mall_Resident = HEX("a86de2")
G.C.SECONDARY_SET.mall_Resident = HEX("cd97ef")
G.ARGS.LOC_COLOURS.mall_Resident = HEX("cd97ef")

function Mallatro.ResidentSet(t)
	Mallatro.resident_sets[t.key] = t
	Mallatro.resident_sets_ordered[#Mallatro.resident_sets+1] = t
	G.ARGS.LOC_COLOURS["res_set_"..t.key] = t.colour
end

Mallatro.ResidentSet{
	key="canon",
	colour=HEX("a86de2")
}

function Mallatro.custom_card_areas.resident(game)
	game.mall_resident_area = CardArea(
		0,0,G.CARD_W,G.jokers.T.h,
		{
			card_limit = 1,
			type = "joker",
			highlight_limit = 1,
			no_card_count = true,
			align_buttons = true,
			mall_w_space = .6,
			bg_colour = G.C.CLEAR
		}
	)
end

local gsr = Game.start_run
function Game:start_run(args, ...)
	gsr(self, args, ...)

	local cons_t = G.jokers.T
	local cons_t2 = G.consumeables.T

	self.mall_resident_area.T.x = cons_t.x
	self.mall_resident_area.T.y = cons_t.y

	cons_t.x = cons_t.x + self.mall_resident_area.T.w + 0.2
	cons_t.w = cons_t.w - self.mall_resident_area.T.w + 0.8

	cons_t2.x = cons_t2.x + 1
	cons_t2.w = cons_t2.w - 1
end

function Mallatro.custom_collection_tabs.residents()
	local tally = 0
	for _, v in pairs(G.P_CENTER_POOLS.mall_Resident) do
		tally = tally + (v.discovered and 1 or 0)
	end
	return UIBox_button{
		button = "mall_your_collection_residents",
		label = {localize("b_mall_residents")},
		count = {tally = tally, of = #G.P_CENTER_POOLS.mall_Resident},
		minw = 5,
		id = "mall_your_collection_residents"
	}
end

function Mallatro.create_UIBox_your_collection_residents()
	local pool = {}
	for k, v in pairs(G.P_CENTER_POOLS.mall_Resident) do
		if not v.no_collection then pool[#pool+1] = v end
	end

	local rows = {2,2}
	local cards_per_page = 4

	local options = {}
	for i = 1, math.ceil(#pool/cards_per_page) do
		table.insert(options, localize('k_page')..' '..tostring(i)..'/'..tostring(math.ceil(#pool/cards_per_page)))
	end

	G.your_collection = {}

	local get_collection_page = function(page, parent)
		EMPTY(G.your_collection)
		local nodes = {}
		for j = 1, #rows do
			local rowNode = {n=G.UIT.C, config = {padding = 0.15}, nodes = {}}
			for i = 1, rows[j] do
				local center = pool[(i-1)*2+j + (cards_per_page*(page - 1))]

				local c =  CardArea(
					G.ROOM.T.x + 0.2*G.ROOM.T.w/2,G.ROOM.T.h,
					G.CARD_W,
					G.CARD_H,
					{card_limit = 1, type = 'title', highlight_limit = 0, collection = true, mall_w_space = center and center.resident_collection_share and 0.3 or nil}
				)
				G.your_collection[#G.your_collection+1] = c

				local bio_lines = {}
				local bio_title = {}

				if center then
					local card = Card(c.T.x + c.T.w/2, c.T.y, G.CARD_W, G.CARD_H, G.P_CARDS.empty, center)
					
					local loc_vars = center.loc_vars and center:loc_vars({},card) or {}

					local name_key = loc_vars and loc_vars.key or center.key
					local bio_key = loc_vars and loc_vars.bio_key or center.key
					
					local disc = center.discovered
					if center.resident_collection_share then
						for _, v in ipairs(center.resident_collection_share) do
							disc = disc and G.P_CENTERS[v].discovered
						end
					end
					
					if not disc then
						name_key = "undiscovered"
						bio_key = center.resident_collection_share and "undiscovered_plural" or "undiscovered"
					elseif not (G.localization.descriptions.mall_Resident[center.key] and G.localization.descriptions.mall_Resident[center.key].res_bio) then
						name_key = "shame"
						bio_key = "shame"
					end

					local bio = {}
					localize({type="res_bio", set="mall_Resident", key=bio_key, nodes=bio, default_col=G.C.UI.TEXT_LIGHT, vars = loc_vars.vars})
					for _, line in ipairs(bio) do bio_lines[#bio_lines+1] = {n = G.UIT.R, config = {align = "cl"}, nodes = line} end
					
					local bt = {}
					localize({type = 'name', key = bio_key == "shame" and "shame" or (G.localization.descriptions.mall_Resident[bio_key].name and bio_key or name_key), set = 'mall_Resident', nodes = bio_title, vars = loc_vars.vars})
					for _, line in ipairs(bio_title) do bt[#bt+1] = {n = G.UIT.R, config = {align = "cl"}, nodes = line} end
					bio_title = bt

					c:emplace(card)

					if center.resident_collection_share then
						for _, v in ipairs(center.resident_collection_share) do
							c:emplace(Card(c.T.x + c.T.w/2, c.T.y, G.CARD_W, G.CARD_H, G.P_CARDS.empty, G.P_CENTERS[v]))
						end
					end
				end

				rowNode.nodes[#rowNode.nodes+1] =
				{n = G.UIT.R, config = {padding = 0.15, r = 0.08, hover=true, shadow=true, colour = G.C.L_BLACK}, nodes = {
					{n = G.UIT.C, config = {padding = 0.1, r = 0.08, emboss = -0.04, colour = G.C.BLACK}, nodes = {
						{n=G.UIT.O, config = {object = c}}
					}},
						{n = G.UIT.C, config = {r = 0.08, emboss = -0.04, colour = G.C.BLACK, padding = 0.1, minh=G.CARD_H, maxh=G.CARD_H}, nodes = {
							{n = G.UIT.R, config = {minw=4, maxw=4}, nodes = bio_title},
							{n = G.UIT.R, config = {minw=4, maxw=4}, nodes = bio_lines},
						}}
				}}
			end
			nodes[#nodes+1] = rowNode
		end
		INIT_COLLECTION_CARD_ALERTS()
		return UIBox({
			definition = {
				n = G.UIT.ROOT,
				config = { colour = G.C.CLEAR },
				nodes = nodes,
			},
			config = {
				major = parent,
				parent = parent,
			},
		})
	end

	G.FUNCS.SMODS_card_collection_page = function(e)
		if not e or not e.cycle_config then return end
		local parent = G.OVERLAY_MENU:get_UIE_by_ID("residents_content")
		parent.config.object:remove()
		parent.config.object = get_collection_page(e.cycle_config.current_option, parent)
		parent.UIBox:recalculate()
	end
	return create_UIBox_generic_options({
		back_func = G.ACTIVE_MOD_UI and "openModUI_"..G.ACTIVE_MOD_UI.id or 'your_collection', contents = {
			{n=G.UIT.R, config={align = "cm", r = 0.1, colour = G.C.BLACK, emboss = 0.05}, nodes={
				{
					n = G.UIT.O,
					config = {
						id = "residents_content",
						object = get_collection_page(1)
					}
				}
			}},
			(cards_per_page < #pool) and {n=G.UIT.R, config={align = "cm"}, nodes={
				create_option_cycle({options = options, w = 4.5, cycle_shoulders = true, opt_callback = 'SMODS_card_collection_page', current_option = 1, colour = G.ACTIVE_MOD_UI and (G.ACTIVE_MOD_UI.ui_config or {}).collection_option_cycle_colour or G.C.RED, no_pips = true, focus_args = {snap_to = true, nav = 'wide'}})
			}} or nil,
	}})
end

function G.FUNCS.mall_your_collection_residents(e)
	G.SETTINGS.paused = true
	G.FUNCS.overlay_menu{
		definition = Mallatro.create_UIBox_your_collection_residents(),
	}
end

local achook = CardArea.align_cards
function CardArea.align_cards(self)
	if self.config.mall_w_space then
		self.T.x = self.T.x-self.config.mall_w_space
		self.T.w = self.T.w+self.config.mall_w_space*2
		
		achook(self)
		
		self.T.x = self.T.x+self.config.mall_w_space
		self.T.w = self.T.w-self.config.mall_w_space*2
	else achook(self) end
end

-- both these hooks were given by @nh6574
-- https://github.com/nh6574/JoyousSpring/blob/5ef54fa49bbb5a4450c78294fb7b2854134f5d44/src/card_ui.lua

local init_localization_ref = init_localization
function init_localization()
	init_localization_ref()

	if G.localization.descriptions.mall_Resident then
		for _, center in pairs(G.localization.descriptions.mall_Resident) do
			if center.res_bio then
				center.res_bio_parsed = {}
				for _, line in ipairs(center.res_bio) do
					center.res_bio_parsed[#center.res_bio_parsed + 1] = loc_parse_string(line)
				end
			end
		end
	end
end

local localize_ref = localize
function localize(args, misc_cat)
	if args and not (type(args) == 'table') then
		return localize_ref(args, misc_cat)
	end

	local loc_target = nil
	if args and (args.type == 'res_bio') then
		loc_target = G.localization.descriptions[(args.set or args.node.config.center.set)]
			[args.key or args.node.config.center.key]

		if loc_target then
			for _, line in ipairs(loc_target[args.type .. "_parsed"]) do
				args.nodes[#args.nodes + 1] = SMODS.localize_box(line, args)
			end
		end
	end
	return localize_ref(args, misc_cat)
end

SMODS.RunSelectPage{
	key = "residents",
	page = 2,
	automatic_preview = true,
	generate_pool = function(self)
		local pool = {}
		for i, v in ipairs(G.P_CENTER_POOLS.mall_Resident) do
			if not v.no_run_select then pool[#pool+1] = v end
		end
		return pool
	end,
	start_run = function(self, choice)
		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			func = function()
				local c = SMODS.add_card({key = choice, skip_materialize = true, area=G.mall_resident_area})
				c:start_materialize()
				return true
			end
		}))
	end,
	random_select = true,
	type = "mall_Resident",
	no_remove = true,
	set_default = function(self, choice)
		return choice or "res_mall_chloe"
	end
}

SMODS.Shader{
	key = "mall_active",
	path = "active.fs",
	send_vars = function (element, card)
		local active = element.config.card.ability.res_active
		return {
			progress = .5,--active.charges/active.max,
			time = G.TIMERS.REAL
		}
	end
}