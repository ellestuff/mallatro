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
					"Undecided. Definitely gonna",
					"be more {C:attention}interesting{} than",
					"the old effect though..."
				},
				res_bio = {
					"A completely average {C:mall_Resident}Resident{}.",
					"Didn't have the best home life",
					"and had a falling out with her",
					"{C:green}sister{}. When she discovered",
					"{C:res_set_canon}The Mall{} it didn't take long for",
					"her to make up her mind..."
				}
			}
		}
	},
	misc = {
		dictionary = {
			k_mall_resident = "Resident",
			k_mall_visitor = "Visitor",
			b_mall_residents = "Residents",

			mall_res_set_canon = "The Mall"
		}
	}
}

