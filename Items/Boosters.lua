

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
    cost = 6,
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
    cost = 8,
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

SMODS.Booster{
    key = 'booster_cjmod_full',
    group_key = "k_CJMod_boosters",
    atlas = 'Booster',
    pos = { x = 2, y = 0 },
    discovered = true,
    loc_txt= {
        name = 'The Group Special',
        text = { "Pick {C:attention}#1#{} cards out from",
             "{C:attention}#2#{} of {C:red}ALL{} CJ Mod jokers!", },
    },
    
    draw_hand = false,
    config = {
        extra = 5,
        choose = 2, 
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.choose, card.ability.extra } }
    end,

    weight = 0.4,
    cost = 10,
    kind = "CJModPack",
    select_card = "jokers",
    
    create_card = function(self, card, i)
        ease_background_colour(HEX("1a202a"))
        return {
            set = "CJModSetFull",
            area = G.pack_cards,
            skip_materialize = true,
            soulable = true,
            key_append = "CJMod"
        }
    end,
}