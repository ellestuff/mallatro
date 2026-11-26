Mallatro.Resident{
	key="furry",
	res_colour = HEX("fcab66"),
	res_set = "canon",
	config = { extra = {xmult_mod = .1, xmult = 1, anim_timer = 0} },
	pos = {x=1,y=1},
	calculate = function(self,card,context)
		if context.before and #G.hand.cards > 0 then
			local pool = {}
			for _, v in ipairs(G.hand.cards) do
				if not card.furry_targeted then pool[#pool+1] = v end
			end

			local target = pseudorandom_element(pool,"mall_furry_eat")

			if target then
				target.furry_targeted = true
				SMODS.destroy_cards(target)
				--G.E_MANAGER:add_event(Event({func=function()
					card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_mod
				--return true end}))

				return {
					message = localize("k_upgrade_ex"),
					sound = "slice1"
				}
			end
		end

		if context.final_scoring_step and card.ability.extra.xmult ~= 1 then
			return {
				xmult = card.ability.extra.xmult
			}
		end 
	end,
	loc_vars = function(self, info_queue, card) return { vars = {
		card.ability.extra.xmult_mod,
		card.ability.extra.eaten,
		card.ability.extra.xmult
	}}end
}