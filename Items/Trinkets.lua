
--[[
CJMod.Trinket = SMODS.Joker:extend{
    unlocked = true,
    discovered = false,
    config = {},
    set = "Trinket",
    class_prefix = "trk",
    required_params = {"key", "atlas", "pos", "cost"},

    cost = 1,

    pre_inject_class = function(self)
        G.P_CENTER_POOLS[self.set] = {}
    end,

    add_to_deck = function(self, card)
        return
    end,

    remove_from_deck = function (self, card, from_debuff)
        return
    end,

    calculate = function(self, card, context)
        return
    end,

    set_card_type_badge = function(self, card, badges)
        local display_info = {"Trinket"} 
        if self.badges_info and next(self.badges_info) then
            for _, v in pairs(self.badges_info) do
                local localized = localize(v)
                if localized ~= "ERROR" then
                    display_info[#display_info+1] = localized
                else
                    display_info[#display_info+1] = v
                end
            end
        end
        badges[#badges+1] = create_badge(display_info, HEX("fc5353"), G.C.WHITE)
    end,

    display_size = { w = 66, h = 66 },

    generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
        SMODS.Center.generate_ui(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    end
}

CJMod.process_loc_text = function()
    G.localization.descriptions.Trinket = {}
end

CJMod.Trinket{
    key = "CJMod_gold",
    pos = { x = 0, y = 0 },
    atlas = "Trinkets",
    config = { extra = { dollars = 2 }},
    cost = 6,
    loc_txt = {
        name = "Reddit Gold",
        text = {
            "{C:money}+#1#${} blind payout"
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.dollars } }
    end,
    add_to_deck = function(self, card)
        G.GAME.blind_payout = (G.GAME.blind_payout or 0) + card.ability.extra.dollars
    end,
    remove_from_deck = function(self, card)
        G.GAME.blind_payout = (G.GAME.blind_payout or 0) - card.ability.extra.dollars
    end,
    pools = { ["Trinket"] = true },
}

CJMod.Trinket{
    key = "CJMod_reversi",
    pos = { x = 1, y = 0 },
    atlas = "Trinkets",
    config = { extra = { }},
    cost = 6,
    loc_txt = {
        name = "Reversi",
        text = {
            "Swaps current's hand {C:mult}mult and {C:chips}chips{}",
            "before scoring"
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.dollars } }
    end,
    calculate = function(self, card, context)
        if context.before then
            card:juice_up(0.2)
            temp = mult
            mult = hand_chips
            hand_chips = temp
        end
    end,
    pools = { ["Trinket"] = true },
}

--[[
CJMod.Trinket{
    key = "CJMod_gold",
    pos = { x = 0, y = 0 },
    atlas = "Trinkets",
    config = { extra = { dollars = 2 }},
    cost = 6,
    loc_txt = {
        name = "Reddit Gold",
        text = {
            "{C:money}+#1#${} blind payout"
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.dollars } }
    end,
    calculate = function(self, card, context)
        if context.modify_hand
    end,
    pools = { ["Trinket"] = true },
}]]--

