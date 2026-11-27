Mallatro.overlay_shops = {
	shops = {},
}

function Mallatro.OverlayShop(t)
	Mallatro.overlay_shops.shops[t.key] = t
end

-- Init game hook - initialize game variables
local igo_hook = Game.init_game_object
function Game:init_game_object()
	local g = igo_hook(self)

	g.mall_overlay_shops = {}
	for k, v in pairs(Mallatro.overlay_shops) do
		local t = {
			reset_on_open = true,
			first_open = true,
			data = {}
		}

		for k2,v2 in pairs(v.run_data or {}) do
			t[k2] = v2
		end

		g.mall_overlay_shops[k] = t
	end
	return g
end