
SMODS.Sound({
    key = "music_ice", 
    path = "IceAtNight.mp3",
    pitch = 1,
    volume = 0.6,
    select_music_track = function()
        if G.STATE == G.STATES.SMODS_BOOSTER_OPENED then
            if G.pack_cards
                and G.pack_cards.cards
                and G.pack_cards.cards[1]
                and G.pack_cards.cards[1].config
                and G.pack_cards.cards[1].config.center
                and G.pack_cards.cards[1].config.center.mod
                and G.pack_cards.cards[1].config.center.mod.id 
                and G.pack_cards.cards[1].config.center.mod.id == "cjmod" then
		        return true 
            end
        end
	end,
})

SMODS.Booster{
    key = 'booster_cjmod_1',
    group_key = "k_CJMod_boosters",
    atlas = 'Booster',
    pos = { x = 0, y = 0 },
    discovered = true,
    loc_txt= {
        name = 'Pick Your Poison',
        text = { "Pick {C:attention}#1#{} card out",
                "{C:attention}#2#{} CJ Mod jokers!", },
    },
    
    draw_hand = false,
    config = {
        extra = 2,
        choose = 1, 
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.choose, card.ability.extra } }
    end,

    weight = 1,
    cost = 5,
    kind = "CJModPack",
    select_card = "jokers",
    
    create_card = function(self, card, i)
        ease_background_colour(HEX("6dfc5a"))
        return {
            set = "CJModSet",
            area = G.pack_cards,
            skip_materialize = true,
            soulable = true,
        }
    end,
}

SMODS.Booster{
    key = 'booster_cjmod_2',
    group_key = "k_CJMod_boosters",
    atlas = 'Booster',
    pos = { x = 1, y = 0 },
    discovered = true,
    loc_txt= {
        name = 'Jum Pack',
        text = { "Pick {C:attention}#1#{} card out",
             "{C:attention}#2#{} CJ Mod jokers!", },
    },
    
    draw_hand = false,
    config = {
        extra = 4,
        choose = 1, 
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.choose, card.ability.extra } }
    end,

    weight = 1,
    cost = 9,
    kind = "CJModPack",
    select_card = "jokers",
    
    create_card = function(self, card, i)
        ease_background_colour(HEX("ffac00"))
        return {
            set = "CJModSet",
            area = G.pack_cards,
            skip_materialize = true,
            soulable = true,
            key_append = "CJMod"
        }
    end,
}