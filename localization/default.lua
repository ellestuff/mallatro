-- Text Prefix Shortcuts
local caption = '{C:elle,s:0.7,E:1}'

return {
	descriptions = {
		Other = {
			undiscovered_mall_resident = {
				name="Not Discovered",
				text={
					"Purchase or obtain",
					"this resident in an",
					"unseeded run to",
					"learn more",
				}
			}
		},
		mall_Resident = {
			-- Bio stuff :)
			undiscovered = {
				name="Not Discovered",
				res_bio = {
					"Purchase or obtain this resident",
					"in an unseeded run to learn more",
				}
			},
			undiscovered_plural = {
				name="Not Discovered",
				res_bio = {
					"Purchase or obtain these residents",
					"in an unseeded run to learn more",
				}
			},

			shame = {
				name = "{C:red}Lazy ass.",
				res_bio = {
					"Pls add a bio.",
					" ",
					"Poke Elle with a pointy stick if",
					"this appears in a release build"
				}
			},
			
			res_mall_chloe = {
				name = 'Chloe',
				text = {
					"No effect. The standard",
					"{C:attention}Balatro{} experience.",
				},
				res_bio = {
					"A completely average {C:mall_Resident}Resident{}.",
					"Didn't have the best home life",
					"and ran away after having a",
					"falling out with her {C:green}sister{}...",
					" ",
					"When she discovered {C:res_set_canon}The Mall",
					"it didn't take long for her to",
					"make up her mind."
				}
			},
			res_mall_furry = {
				name = "Furry",
				text = {
					"Destroy a {C:attention}random{} held",
					"card before scoring",
					"and gain {X:mult,C:white}X#1#{} Mult",
					"{C:inactive}(Currently {X:mult,C:white}X#3#{C:inactive} Mult)",
					"{s:.75}Scores after everything else"
				},
				res_bio = {
					"A birthday gift gone wrong.",
					"Months of prototyping to",
					"create a tail for {C:res_mall_chloe}Chloe{}...",
					" ",
					"...It just turned out a little",
					"more {C:red}sentient{} than intended."
				}
			},
			res_mall_p41 = {
				name = 'Prototype #1#41',
				text = {
					"Copy abilities of {C:attention}#2#{} random",
					"{C:attention}copyable{} Jokers, changes",
					"when {C:attention}Blind{} is selected",
					"{C:red}#3#{} Joker slot"
				},
				res_bio = {
					"The experiments to create",
					"{C:res_mall_chloe}Chloe{}'s tail were repurposed",
					"from experiments aiming to",
					"create artificial {C:mall_Resident}Residents{}.",
					" ",
					"This {C:res_mall_p41}Prototype{} marks the",
					"point when the experiments",
					"pivoted towards making a tail."
				}
			},
		}
	},
	misc = {
		dictionary = {
			k_mall_resident = "Resident",
			k_mall_visitor = "Visitor",
			b_mall_residents = "Residents",

			mall_res_set_canon = "The Mall",
			mall_prototype_activate = "Yeah~!",

			run_select_mall_residents = "Select Resident",
			run_select_mall_residents_random = "Random Resident"
		}
	}
}

