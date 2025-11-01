

SMODS.Blind{
    key = "memory",
    dollars = 5,
    mult = 2,
    atlas = "Blinds",
    pos = { y = 0 },
    boss = { min = 1 },
    boss_colour = HEX("e5a45d"),
    loc_txt = {
        name = "The Goldfish",
        text = {
            "Cards drawn are flipped",
            "after 4 seconds"
        }
    },
    calculate = function(self, blind, context)
        if not blind.disabled then
            if context.hand_drawn then
                G.E_MANAGER:add_event(Event({trigger = "after", delay = 4, func = function()
                    blind:wiggle()
                    play_sound('generic1')
                    for n, x in pairs(G.hand.cards) do
                        if x.facing == 'front' then
                            x:flip()
                        end
                    end
                    return true end
                }))
                return
            end
        end
    end,
    disable = function(self)
        for i = 1, #G.hand.cards do
            if G.hand.cards[i].facing == 'back' then
                G.hand.cards[i]:flip()
            end
        end
        for _, playing_card in pairs(G.playing_cards) do
            playing_card.ability.wheel_flipped = nil
        end
    end
}

SMODS.Blind{
    key = "tough",
    dollars = 5,
    mult = 2,
    atlas = "Blinds",
    pos = { y = 1 },
    boss = { min = 2 },
    boss_colour = HEX("39a35e"),
    loc_txt = {
        name = "The Tough",
        text = {
            "Debuffs ranks A to 5"
        }
    },
    calculate = function(self, blind, context)
        if not blind.disabled then
            if context.debuff_card and context.debuff_card.area ~= G.jokers and not SMODS.has_enhancement(context.debuff_card, "m_stone") then
                if context.debuff_card:get_id() and context.debuff_card:get_id() <= 5 or context.debuff_card:get_id() == 14 then
                    return {debuff = true}
                end
            end
        end
    end,
}

SMODS.Blind{
    key = "rough",
    dollars = 5,
    mult = 2,
    atlas = "Blinds",
    pos = { y = 2 },
    boss = { min = 2 },
    boss_colour = HEX("83c837"),
    loc_txt = {
        name = "The Rough",
        text = {
            "Debuffs ranks 6 to 10"
        }
    },
    calculate = function(self, blind, context)
        if not blind.disabled then
            if context.debuff_card and context.debuff_card.area ~= G.jokers then
                if context.debuff_card:get_id() and context.debuff_card:get_id() <= 10 and context.debuff_card:get_id() > 5 then
                    return {debuff = true}
                end
            end
        end
    end,
}

SMODS.Blind{
    key = "loss",
    dollars = 5,
    mult = 2,
    atlas = "Blinds",
    pos = { y = 3 },
    boss = { min = 3 },
    boss_colour = HEX("e74ab7"),
    loc_txt = {
        name = "The Lost",
        text = {
            "If scored hand doesn't defeat blind,",
            "destroy cards in the scored hand"
        }
    },
    calculate = function(self, blind, context)
        if not blind.disabled then
            if context.after then
                blind.triggered = false
                if not overscores() then
                    local playedhand = G.play.cards
                    blind.triggered = true
                    for n, x in pairs(playedhand) do
                        G.E_MANAGER:add_event(Event({trigger = "after", delay = 0.3, func = function()
                            SMODS.destroy_cards(x, false, false)
                            blind:wiggle()
                            return true end
                        }))
                    end
                end
            end
        end
    end,
}

SMODS.Blind{
    key = "teller",
    dollars = 5,
    mult = 2,
    atlas = "Blinds",
    pos = { y = 4 },
    boss = { min = 3 },
    boss_colour = HEX("103fc3"),
    loc_txt = {
        name = "The Teller",
        text = {
            "Played cards after the 3rd",
            "are debuffed"
        }
    },
    calculate = function(self, blind, context)
        if not blind.disabled then
            if context.before then
                blind.triggered = false
                for n, x in pairs(G.play.cards) do
                    if type(n) == "number" and n > 3 then
                        if not blind.triggered then
                            blind.triggered = true
                            blind:wiggle()
                        end
                        SMODS.debuff_card(x, true, "Teller")
                    end
                end
            end
        end
    end,
    disable = function (self)
        for n, x in pairs(G.playing_cards) do
            SMODS.debuff_card(x, true, "Teller")
        end
    end,
    defeat = function (self)
        for n, x in pairs(G.playing_cards) do
            SMODS.debuff_card(x, true, "Teller")
        end
    end
}

SMODS.Blind{
    key = "quick",
    dollars = 6,
    mult = 1.75,
    atlas = "Blinds",
    pos = { y = 5 },
    boss = { min = 3 },
    boss_colour = HEX("1ed8a3"),
    loc_txt = {
        name = "The Quick",
        text = {
            "Lose score over time,",
            "smaller blind size"
        }
    },
    executing = true,
    started = true,
}

SMODS.Blind{
    key = "serious",
    dollars = 5,
    mult = 2,
    atlas = "Blinds",
    pos = { y = 7 },
    boss = { min = 1 },
    boss_colour = HEX("ff6bd2"),
    loc_txt = {
        name = "The Serious",
        text = {
            "Disables jokers that have",
            '"Joker" in their name'
        }
    },
    calculate = function(self, blind, context)
        if not blind.disabled then
            if context.debuff_card and context.debuff_card.area == G.jokers then
                local joker = context.debuff_card
                if not joker then return end
                if joker.loc_txt and joker.loc_txt.name then
                    if string.find(string.lower(joker.loc_txt.name), "joker") then
                        return {debuff = true}
                    end
                else 
                    local name = localize({type = 'name_text', key = joker.config.center_key, set = 'Joker'})
                    if name and type(name) == "string" and string.find(string.lower(name), "joker") then
                        return {debuff = true}
                    end
                end
            elseif context.card_added and context.card and context.card.ability and context.card.ability.set == "Joker" then
                local joker = context.debuff_card
                if not joker then return end
                if joker.loc_txt and joker.loc_txt.name then
                    if string.find(string.lower(joker.loc_txt.name), "joker") then
                        joker:debuff_card(joker, true, "SeriousBlind")
                        return
                    end
                else 
                    local name = localize({type = 'name_text', key = joker.config.center_key, set = 'Joker'})
                    if name and type(name) == "string" and string.find(string.lower(name), "joker") then
                        joker:debuff_card(joker, true, "SeriousBlind")
                        return
                    end
                end
            end
        end
    end,
    defeat = function(self)
        for _, joker in ipairs(G.jokers.cards) do
            if joker.debuff_card then
                joker:debuff_card(joker, false, "SeriousBlind")
            end
        end
    end,
    disable = function(self)
        for _, joker in ipairs(G.jokers.cards) do
            if joker.debuff_card then
                joker:debuff_card(joker, false, "SeriousBlind")
            end
        end
    end,
}

SMODS.Blind{
    key = "sour",
    dollars = 6,
    mult = 2,
    atlas = "Blinds",
    pos = { y = 8 },
    boss = { min = 1 },
    boss_colour = HEX("faff8c"),
    loc_txt = {
        name = "The Sour",
        text = {
            "Each hand played increases blind size"
        }
    },
    calculate = function(self, blind, context)
        if not blind.disabled then
            if not blind.originalsize then
                G.GAME.blind.originalsize = G.GAME.blind.chips
            end
            if context.after then
                blind.triggered = false
                G.E_MANAGER:add_event(Event({blockable = true, blocking = true, func = function()
                    if not overscores() then
                        blind.triggered = true
                        blind:wiggle()
                        G.GAME.blind.chips = G.GAME.blind.chips * 1.25
                        G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
                    end
                    return true end
                }))
            end
        end
    end,
    disable = function (self)
        local blind = G.GAME.blind
        if blind and blind.originalsize then
            blind.chips = blind.originalsize
        end
    end
}

SMODS.Blind{
    key = "wee",
    dollars = 4,
    mult = 1.5,
    atlas = "Blinds",
    pos = { y = 9 },
    boss = { min = 1 },
    boss_colour = HEX("a1a1a1"),
    loc_txt = {
        name = "Wee Blind",
        text = {
            "-2 Hands, -1 Discards",
            "Smaller blind size"
        }
    },
    calculate = function(self, blind, context)
        if not blind.disabled then
            if context.setting_blind then
                local handst = G.GAME.round_resets.hands
                local discst = G.GAME.round_resets.discards

                local totalhand = handst - 2
                local totaldisc = math.max(0, discst - 1)

                local deduct1 = 2
                local deduct2 = 1

                while totalhand <= 0 and deduct1 > 0 do
                    deduct1 = deduct1 - 1
                    totalhand = handst - deduct1
                end

                blind.hands_sub = deduct1
                blind.discards_sub = deduct2
                ease_hands_played(-deduct1)
                ease_discard(-deduct2)
            end
        end
    end,
    disable = function (self)
        local blind = G.GAME.blind
        if blind and blind.discards_sub and blind.hands_sub then
            ease_hands_played(blind.hands_sub)
            ease_discard(blind.discards_sub)
        end
    end
}

SMODS.Blind{
    key = "hater",
    dollars = 8,
    mult = 1.75,
    atlas = "Blinds",
    pos = { y = 10 },
    boss = { min = 2 },
    boss_colour = HEX("b86bff"),
    loc_txt = {
        name = "The Hater",
        text = {
            "All jokers debuffed until",
            "a {}#1#{} is played,",
            "smaller blind size"
        }
    },
    loc_vars = function (self)
        return { vars = { localize(G.GAME.current_round.least_played_poker_hand, "poker_hands") } }
    end,
    collection_loc_vars = function(self)
        return { vars = { "the least played hand" } }
    end,
    calculate = function(self, blind, context)
        if not blind.disabled then
            if context.setting_blind then
                local jokers = G.jokers.cards
                for n, x in pairs(jokers) do
                    if x then
                        SMODS.debuff_card(x, true, "HaterDebuff")
                    end
                end
            elseif context.before then
                if context.scoring_name == localize(G.GAME.current_round.least_played_poker_hand, "poker_hands") then
                    blind:disable()
                    blind:wiggle()
                    local jokers = G.jokers.cards
                    for n, x in pairs(jokers) do
                        if x then
                            SMODS.debuff_card(x, false, "HaterDebuff")
                        end
                    end
                end
            end
        end
    end,
    disable = function (self)
        local jokers = G.jokers.cards
        for n, x in pairs(jokers) do
            if x then
                SMODS.debuff_card(x, false, "HaterDebuff")
            end
        end
    end,
    defeat = function (self)
        local jokers = G.jokers.cards
        for n, x in pairs(jokers) do
            if x then
                SMODS.debuff_card(x, false, "HaterDebuff")
            end
        end
    end,
}

SMODS.Blind{
    key = "treasure",
    dollars = 12,
    mult = 5,
    atlas = "Blinds",
    pos = { y = 11 },
    boss = { min = 4 },
    boss_colour = HEX("ffe537"),
    loc_txt = {
        name = "The Treasure",
        text = {
            "Every hand played reduces",
            "blind payout",
            "Larger blind size"
        }
    },
    calculate = function(self, blind, context)
        if not blind.disabled then
            if context.after then
                blind.triggered = false
                G.E_MANAGER:add_event(Event({func = function()
                    if not overscores() then
                        blind.triggered = true
                        blind:wiggle()
                        blind.dollars = math.max(0, blind.dollars - 3)
                        if blind.dollars <= 0 then
                            G.GAME.current_round.dollars_to_be_earned = "You get NOTHING!"
                        else
                            G.GAME.current_round.dollars_to_be_earned = string.rep("$", blind.dollars)
                        end
                        
                    end
                    return true end
                }))
            end
        end
    end,
    disable = function (self)
        local blind = G.GAME.blind
        blind.dollars = 12
        G.GAME.current_round.dollars_to_be_earned = string.rep("$", blind.dollars)
    end
}