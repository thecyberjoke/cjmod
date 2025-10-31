
SMODS.Atlas {
    key = "seals",
    path = "Seals.png",
    px = 71,
    py = 96
}

SMODS.Seal {
    name = "venom",
    key = "venom",
    badge_colour = HEX("83ef65"),
	config = { extra = { xchips = 1.5, venomcount = 1} },
    loc_txt = {
        label = 'Venom Seal',
        name = 'Venom Seal',
        text = {
            '{C:white,X:chips}X#1#{} Chips',
            'Self destructs after {C:attention}#2#{} plays'
        }
    },

    sound = { sound = 'CJMod_hiss', per = 1.2, vol = 0.6 },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.seal.extra.xchips, card.ability.seal.extra.venomcount } }
    end,
    atlas = "seals",
    pos = {x = 0, y = 0},

    calculate = function(self, card, context)
        
        if context.main_scoring and context.cardarea == G.play then
            local found = false
            for n, x in pairs(G.jokers.cards) do
                if x and x.config and x.config.center_key == "j_CJMod_violetjoker" then
                    found = true
                    break
                end
            end
            if not found then
                card.ability.seal.extra.venomcount = card.ability.seal.extra.venomcount - 1
                if card.ability.seal.extra.venomcount <= 0 then
                    card.venombreak = true
                end
                return {xchips = card.ability.seal.extra.xchips, message = "Dissolving...", message_colour = G.C.GREEN}
            else
                return {xchips = card.ability.seal.extra.xchips}
            end
        elseif context.destroying_card and context.destroying_card == card then
            if card.venombreak then
                return {remove = true, message = "Dissolved!", message_colour = G.C.GREEN}
            end
        end
    end,
}

--[[SMODS.Seal {
    name = "aqua",
    key = "aqua",
    badge_colour = HEX("53e3f2"),
	config = {},
    loc_txt = {
        label = 'Aqua Seal',
        name = 'Aqua Seal',
        text = {
            "Clones itself {C:attention}twice{} when destroyed",
            "{C:inactive}(Will not retain seal){}"
        }
    },

    sound = { sound = 'generic1', per = 1, vol = 0.4 },

    atlas = "seals",
    pos = {x = 1, y = 0},

    calculate = function(self, card, context)
        
        if context.remove_playing_cards then
            print("!")
            print(context.destroying_card == card)
            for i = 1, 2 do
                local crd = copy_card(card)
                crd:set_seal(nil, true, true)
                G.hand:emplace(crd)
                table.insert(G.playing_cards, crd)
                G.E_MANAGER:add_event(Event({
                func = function()
                    crd:start_materialize({ G.C.SECONDARY_SET.Enhanced })
                    G.hand:emplace(crd)
                    return true
                end
                }))
            end
        end
    end,
}]]

SMODS.Seal {
    name = "power",
    key = "power",
    badge_colour = HEX("ff9163"),
	config = { extra = { xmult = 1.75 }},
    loc_txt = {
        label = 'Power Seal',
        name = 'Power Seal',
        text = {
            "{X:mult,C:white}X#1#{} Mult",
            "Enhancements get removed after scoring"
        }
    },

    sound = { sound = 'generic1', per = 1, vol = 1 },

    atlas = "seals",
    pos = {x = 2, y = 0},

    loc_vars = function(self, info_queue)
        return { vars = { self.config.extra.xmult } }
    end,

    calculate = function(self, card, context)
        if context.main_scoring and context.cardarea == G.play then
            return {xmult = self.config.extra.xmult}
        elseif context.after and context.cardarea == G.play then
            if card.config.center_key ~= "c_base" then
                local percent = 1.15
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.15,
                    func = function()
                        play_sound('card1', percent)
                        card:flip()
                        return true
                    end
                }))
                delay(0.25)

                card:set_ability("c_base", nil, true)

                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.15,
                    func = function()
                        card:flip()
                        return true
                    end
                }))
            end
        end
    end,
}