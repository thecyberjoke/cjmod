SMODS.Joker {
    key = "groupjoker",
    pos = { x = 0, y = 0 },
    rarity = 1,
    atlas = "main",
    config = { extra = { mult = 4, xchips = 0.3 } },

    cost = 6,
    blueprint_compat = true,
    loc_txt = {
        name = "The Group",
        text = {
            "Get {C:mult}#1#{} Mult and {X:chips,C:white}X1.3{}",
            "for every CJ Mod Joker you have",
            "{C:inactive}(Excluding itself){}",
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, card.ability.extra.xchips } }
    end,
    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main then
            local times = 0
            for n, x in pairs(G.jokers.cards) do
                if x.original_mod == SMODS.current_mod and x ~= card then
                    times = times + 1
                end
            end
            if times > 0 then
                return { mult = card.ability.extra.mult * times, xchips = 1 + (times * card.ability.extra.xchips) }
            end
        end
    end,
    pools = { ["CJModSet"] = true, ["CJModSetFull"] = true },
}

SMODS.Joker {
    key = "luajoker",
    pos = { x = 1, y = 0 },
    rarity = 1,
    atlas = "main",
    config = { extra = { mult = 5 } },
    cost = 6,
    blueprint_compat = true,
    loc_txt = {
        name = "Lua Object",
        text = {
            "Everytime a hand is played,",
            "Lose {C:attention}25%{} of your current money",
            "and get {X:mult,C:white}+#1#{} mult per cash lost.",
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local cash = G.GAME.dollars
            if cash >= 5 then
                local calculated = math.ceil(cash / 5)
                return { mult = card.ability.extra.mult * calculated, dollars = -calculated }
            else
                return { message = "Too broke!" }
            end
        end
    end,
    pools = { ["CJModSet"] = true, ["CJModSetFull"] = true },
}

SMODS.Joker {
    key = "qoljoker",
    pos = { x = 2, y = 0 },
    rarity = 2,
    atlas = "main",
    blueprint_compat = true,
    config = { extra = { X_mult = 15, X_chips = 75, odds = 15 } },
    cost = 6,

    loc_txt = {
        name = "Quality Of Life",
        text = {
            "Either gives {X:mult,C:white}+#1#{} mult",
            "Or {X:chips,C:white}+#2#{} chips",
            "{C:green}#3# in #4# chance{} to {C:mult}self destruct",
        }
    },
    loc_vars = function(self, info_queue, card)
        local nom, denom = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, "QOLDestruct")
        return { vars = { card.ability.extra.X_mult, card.ability.extra.X_chips, nom, denom } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local val = pseudorandom("Poopoo", 1, 2)
            if SMODS.pseudorandom_probability(card, "QOLDestruct", 1, card.ability.extra.odds) then
                SMODS.destroy_cards(card)
                return { message = "Terraria has encountered a fatal error and has crashed.", remove = true }
            elseif val == 2 then
                return { chips = card.ability.extra.X_chips }
            else
                return { mult = card.ability.extra.X_mult }
            end
        end
    end,
    pools = { ["CJModSet"] = true, ["CJModSetFull"] = true },
}

SMODS.Joker {
    key = "cyberjoker",
    pos = { x = 3, y = 0 },
    rarity = "CJMod_stupid",
    atlas = "main",
    blueprint_compat = false,
    config = { extra = { mult = 4 } },
    cost = 6,
    loc_txt = {
        name = "cyberjoker",
        text = {
            "Directly calculates the current",
            "{X:chips,C:white}chips{} and {X:mult,C:white}mult{},",
            "and sets the {X:chips,C:white}chips{} as the result, and {X:mult,C:white}mult{} to 1."
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = {} }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local currentchips = hand_chips
            local currentmult = mult

            return { chips = (currentchips * currentmult) - currentchips, mult = -currentmult + 1 }
        end
    end,
    pools = { ["CJModSetFull"] = true },
}

SMODS.Joker {
    key = "abyssesconvention",
    pos = { x = 4, y = 0 },
    rarity = 1,
    atlas = "main",
    blueprint_compat = true,
    config = { extra = { mult = 7, chip = 40, type = "Pair" } },
    cost = 6,
    loc_txt = {
        name = "Abysses' Convention",
        text = {
            "If played hand is a pair or better,",
            "Add {X:mult,C:white}+#1#{} mult",
            "Otherwise, add {X:chips,C:white}+#2#{} chips"
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, card.ability.extra.chip, card.ability.extra.antimult, localize(card.ability.extra.type, 'poker_hands') } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            if next(context.poker_hands[card.ability.extra.type]) then
                return { mult = card.ability.extra.mult }
            else
                return { chips = card.ability.extra.chip }
            end
        end
    end,
    pools = { ["CJModSet"] = true, ["CJModSetFull"] = true },
}

SMODS.Joker {
    key = "squishy",
    pos = { x = 0, y = 1 },
    rarity = 2,
    atlas = "main",
    config = { extra = { size = 2, hasactivated = false } },
    cost = 6,
    blueprint_compat = false,
    loc_txt = {
        name = "Squishy Assistance",
        text = {
            "{C:dark_edition}+#1#{} hand size on",
            "first {C:chips}hand{} of round"
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.size } }
    end,
    calculate = function(self, card, context)
        if context.setting_blind then
            G.hand:change_size(card.ability.extra.size)
            card.ability.extra.hasactivated = true
            return {message = "Size up!", message_colour = G.C.CHIPS}
        elseif context.before and card.ability.extra.hasactivated then
            card.ability.extra.hasactivated = false
            G.hand:change_size(-card.ability.extra.size)
            return {message = "Size down!", message_colour = G.C.CHIPS}
        end
    end,
    pools = { ["CJModSet"] = true, ["CJModSetFull"] = true },
}

SMODS.Joker {
    key = "finaljoker",
    pos = { x = 1, y = 1 },
    rarity = 2,
    atlas = "main",
    blueprint_compat = true,
    config = { extra = { currentXmult = 1, Xmultincrease = 0.1 } },
    cost = 8,
    loc_txt = {
        name = "Final Phase",
        text = {
            "If the played hand has less than 5 cards,",
            "Upgrades itself by {X:mult,C:white}X#3#{}.",
            "On last hand, debuff {C:mult}every{} card in hand.",
            "{C:inactive}(Currently {X:mult,C:white}X#2#{}){}"
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.cardamount, card.ability.extra.currentXmult, card.ability.extra.Xmultincrease } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            if #G.play.cards < 5 then
                card.ability.extra.currentXmult = card.ability.extra.currentXmult + card.ability.extra.Xmultincrease
                return { message = "Upgraded!", colour = G.C.RED, xmult = card.ability.extra.currentXmult }
            else
                return { xmult = card.ability.extra.currentXmult }
            end
        elseif context.after and not context.blueprint_card then
            if G.GAME.current_round.hands_left <= 1 and not overscores() then
                for k, v in pairs(G.hand.cards) do
                    G.E_MANAGER:add_event(Event({
                        trigger = "after",
                        delay = 0.2,
                        func = function()
                            SMODS.debuff_card(v, true, "finaljoker")
                            play_sound('tarot1')
                            card:juice_up(0.3, 0.5)
                            return true
                        end
                    }))
                end
                return { message = "Fuck you." }
            end
        elseif context.end_of_round and context.main_eval then
            for k, v in pairs(G.playing_cards) do
                SMODS.debuff_card(v, false, "finaljoker")
            end
        end
    end,
    pools = { ["CJModSet"] = true, ["CJModSetFull"] = true },
}

SMODS.Joker {
    key = "stormjoker",
    pos = { x = 2, y = 1 },
    rarity = 3,
    atlas = "main",
    config = { extra = { Xmult = 1.4, collectedscore = 0, collectedmult = 0, canstore = true } },
    cost = 12,
    blueprint_compat = false,
    loc_txt = {
        name = "Thunder and Lightning",
        text = {
            "Applies an {X:mult,C:white}X#1#{} mult,",
            "and stores the hand score and mult for later.",
            "If it has score or mult stored, apply it to the next hand.",
            "{C:inactive}(Stored score and mult: {C:chips}#2#{C:inactive}, {C:mult}#3#{C:inactive}){}",
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult, card.ability.extra.collectedscore, card.ability.extra.collectedmult, card.ability.extra.canstore } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            if (card.ability.extra.collectedscore > 0 or card.ability.extra.collectedmult > 0) then
                card.ability.extra.canstore = true
                return {
                    chips = card.ability.extra.collectedscore,
                    mult = card.ability.extra.collectedmult,
                    xmult = card
                        .ability.extra.Xmult
                }
            else
                return { xmult = card.ability.extra.Xmult }
            end
        elseif context.final_scoring_step and G.GAME.current_round.hands_left > 1 and card.ability.extra.canstore and card.ability.extra.collectedscore <= 0 then
            if G.GAME.current_round.hands_left <= 0 then
                return { message = "Nope!" }
            end
            local cchips = math.ceil(hand_chips)
            local cmult = math.ceil(mult)

            card.ability.extra.collectedscore = cchips
            card.ability.extra.collectedmult = cmult
            card.ability.extra.canstore = false
            return { message = "Stored!", chips = -hand_chips, mult = -mult + 1 }
        elseif context.end_of_round and context.main_eval then
            if not card.ability.extra.canstore then
                card.ability.extra.collectedscore = 0
                card.ability.extra.collectedmult = 0
            end
            card.ability.extra.canstore = true
        elseif context.after and card.ability.extra.canstore and (card.ability.extra.collectedscore > 0 or card.ability.extra.collectedmult > 0) then
            card.ability.extra.collectedscore = 0
            card.ability.extra.collectedmult = 0
        end
    end,
    pools = { ["CJModSet"] = true, ["CJModSetFull"] = true },
}
SMODS.Joker {
    key = "basedjoker",
    pos = { x = 3, y = 1 },
    rarity = "CJMod_stupid",
    atlas = "main",
    config = { extra = { mult = 15, chips = 45 } },
    cost = 12,
    blueprint_compat = true,
    loc_txt = {
        name = "BasedAgentLmao",
        text = {
            "For every pair in hand,",
            "Get {C:mult}#1#{} mult and {C:chips}#2#{} chips.",
            "Gain extra if there's a three/four/five of a kind."
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, card.ability.extra.chips } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local cardsgot = {}
            for k, v in pairs(G.hand.cards) do
                if cardsgot[v.base.value] then
                    table.insert(cardsgot[v.base.value], #cardsgot[v.base.value])
                else
                    cardsgot[v.base.value] = { 0 }
                end
            end

            local times = 0

            for z, x in pairs(cardsgot) do
                if #x >= 2 then
                    times = times + (#x - 1)
                end
            end

            if times > 0 then
                return { chips = card.ability.extra.chips * times, mult = card.ability.extra.mult * times }
            end
        end
    end,
    pools = { ["CJModSetFull"] = true },
}

SMODS.Joker {
    key = "lerifejoker",
    pos = { x = 0, y = 2 },
    rarity = "CJMod_stupid",
    atlas = "main",
    config = { mod_conv = 'm_wild' },
    cost = 12,
    loc_txt = {
        name = "LeRiFe",
        text = {
            "If the played hand is a flush,",
            "enhance played cards into wilds",
            "after it scores."
        }
    },
    blueprint_compat = false,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS[card.ability.mod_conv]
        return { vars = { localize { type = "name_text", set = "Enhanced", key = card.ability.mod_conv } } }
    end,
    calculate = function(self, card, context)
        if context.after and context.cardarea == G.jokers then
            if string.find(context.scoring_name, "Flush") then
                local flushed = false
                for n, c in pairs(context.scoring_hand) do
                    if not c.debuff and not c.vampired and not SMODS.has_enhancement(c, "m_wild") then
                        flushed = true
                        G.E_MANAGER:add_event(Event({
                            trigger = "after",
                            delay = 0.25,
                            func = function()
                                c:set_ability("m_wild", nil, true)
                                play_sound('generic1')
                                card:juice_up(0.3, 0.5)
                                c:juice_up(0.3, 0.5)
                                c:flip()
                                return true
                            end
                        }))
                        G.E_MANAGER:add_event(Event({
                            trigger = "after",
                            delay = 0.25,
                            func = function()
                                card:juice_up(0.3, 0.5)
                                c:flip()
                                play_sound('generic1')
                                return true
                            end
                        }))
                    end
                end
                if flushed then
                    return { message = "wild" }
                end
            end
        end
    end,
    pools = { ["CJModSetFull"] = true },
}

SMODS.Joker {
    key = "wormjoker",
    pos = { x = 4, y = 1 },
    rarity = "CJMod_stupid",
    atlas = "main",
    config = { extra = { jack = 8, king = 1.1, queen = 1, currentjack = 0, currentking = 0, currentqueen = 0 }, },
    cost = 12,
    loc_txt = {
        name = "Bob the Bobbit",
        text = {
            "{C:mult}+#1#{} Mult every Jack,",
            "{X:mult,C:white}X#2#{} Mult every King",
            "{C:money}#3#${} every 2 Queens",
            "in your {C:chips}full deck{}",
            "{C:inactive}(Currently {C:mult}#4#{C:inactive}, {X:mult,C:white}X#5#{C:inactive}, {C:money}#6#${C:inactive})"

        }
    },
    blueprint_compat = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.jack, card.ability.extra.king, card.ability.extra.queen, card.ability.extra.currentjack, card.ability.extra.currentking, card.ability.extra.currentqueen } }
    end,
    calculate = function(self, card, context)
        if G.playing_cards then
            local tjacks = 0
            local tqueens = 0
            local tkings = 0
            for n, x in pairs(G.playing_cards) do
                if x and x.get_id and not SMODS.has_enhancement(x, "m_stone") then
                    if x:get_id() == 11 then
                        tjacks = tjacks + 1
                    elseif x:get_id() == 12 then
                        tqueens = tqueens + 1
                    elseif x:get_id() == 13 then
                        tkings = tkings + 1
                    end
                end
            end
            card.ability.extra.currentjack = card.ability.extra.jack * tjacks
            card.ability.extra.currentqueen = math.ceil(tqueens / 2)
            card.ability.extra.currentking = 1 + (((card.ability.extra.king) - 1) * tkings)
        end
        
        if context.joker_main and G.playing_cards then
            local tab = {}
            local jacks = 0
            local kings = 0
            local queens = 0
            for n, x in ipairs(G.playing_cards) do
                if not SMODS.has_enhancement(x, "m_stone") then
                    if x:get_id() == 11 then
                        jacks = jacks + 1
                    elseif x:get_id() == 13 then
                        kings = kings + 1
                    end
                end
            end

            if jacks > 0 then
                tab["mult"] = card.ability.extra.jack * jacks
            end
            if kings > 0 then
                tab["xmult"] = 1 + (((card.ability.extra.king) - 1) * kings)
            end
            return tab
        end
    end,
    calc_dollar_bonus = function(self, card)
        local queens = 0
        if not G.playing_cards then return end
        for n, x in ipairs(G.playing_cards) do
            if not SMODS.has_enhancement(x, "m_stone") then
                if x:get_id() == 12 then
                    queens = queens + 1
                end
            end
        end
        if queens > 1 then
            return math.ceil(queens / 2)
        end
    end,
    pools = { ["CJModSetFull"] = true },
}

SMODS.Joker {
    key = "multjoker",
    pos = { x = 3, y = 2 },
    rarity = 3,
    atlas = "main",
    config = { extra = { increase = 0.75, default = 1.75, current = 1.75 } },
    cost = 8,
    blueprint_compat = true,
    loc_txt = {
        name = "STRONG Aura",
        text = {
            "If the played hand's score is less than",
            "the blind's required score, set it to 0",
            "and this joker gains {C:white,X:mult}X#1#{} mult",
            "only for the current round.",
            "{C:inactive}(Currently {C:white,X:mult}X#3#{C:inactive} mult.){}"
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.increase, card.ability.extra.default, card.ability.extra.current } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return { xmult = card.ability.extra.current }
        elseif context.final_scoring_step then
            if not overscores() then
                card.ability.extra.current = card.ability.extra.current + card.ability.extra.increase
                ease_chips(0)
                hand_chips = 0
                mult = 0
                return { message = "Upgraded!" }
            end
        elseif context.end_of_round and context.main_eval then
            card.ability.extra.current = card.ability.extra.default
            return { message = "Reset!" }
        end
    end,
    pools = { ["CJModSet"] = true, ["CJModSetFull"] = true },
}

SMODS.Joker {
    key = "autismjoker",
    pos = { x = 1, y = 2 },
    rarity = "CJMod_stupid",
    atlas = "main",
    config = { extra = { givemoney = false, overshot = 0, max = 20 } },
    cost = 12,
    blueprint_compat = false,
    loc_txt = {
        name = "Indie Autism",
        text = {
            "If the current score (not total)",
            "is more than the blind's required score,",
            "get {C:money}5${} * Overkill Percentage.",
            "{C:inactive}(Maximum {C:money}#3#${}.){}"
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, card.ability.extra.chips, card.ability.extra.max } }
    end,
    calculate = function(self, card, context)
        if context.final_scoring_step then
            card.ability.extra.overshot = 0
            if G.GAME.blind.chips <= hand_chips * mult then
                card.ability.extra.givemoney = true
                card.ability.extra.overshot = hand_chips * mult
            end
        end
    end,
    calc_dollar_bonus = function(self, card)
        if card.ability.extra.givemoney then
            card.ability.extra.givemoney = false
            return math.min(math.floor(5 * (card.ability.extra.overshot / G.GAME.blind.chips)), card.ability.extra.max)
        end
    end,
    pools = { ["CJModSetFull"] = true },
}

SMODS.Joker {
    key = "exponentjoker",
    pos = { x = 2, y = 2 },
    rarity = "CJMod_stupid",
    atlas = "main",
    config = { extra = { min = 0.1, max = 2, current = 1 } },
    blueprint_compat = true,
    cost = 9,
    loc_txt = {
        name = "Exponential Joker",
        text = {
            "After every hand played,",
            "swaps to a random value between {C:green}#1#{} and {C:green}#2#{},",
            "and then does {C:mult}mult{}^{C:green}value{}.",
            "{C:inactive}(Current value: {C:green}#3#{C:inactive}){}",
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.min, card.ability.extra.max, card.ability.extra.current } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local result = math.pow(mult, card.ability.extra.current)
            return { mult = math.max(math.floor(result - mult), (-mult + 1)) }
        elseif context.final_scoring_step and context.cardarea == G.jokers then
            card.ability.extra.current = pseudorandom("The Thing", card.ability.extra.min * 100,
                card.ability.extra.max * 100) / 100
            return { message = "Changed!" }
        end
    end,
    pools = { ["CJModSet"] = true },
}

SMODS.Joker {
    key = "edgejoker",
    pos = { x = 0, y = 3 },
    rarity = 2,
    atlas = "main",
    config = { extra = { value = 1.25, current = 1 } },
    blueprint_compat = false,
    cost = 9,
    loc_txt = {
        name = "On The Edge",
        text = {
            "Lose all your hands but one.",
            "Get {X:mult,C:white}X#1#{} for each hand lost,",
            "Plus {C:attention}1${} for every 2 hands lost.",
            "{C:inactive}(Currently {X:mult,C:white}X#2#{}){}"
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.value, card.ability.extra.current } }
    end,
    calculate = function(self, card, context)
        if context.setting_blind and context.cardarea == G.jokers then
            local result = G.GAME.current_round.hands_left - 1
            local cash = math.ceil(result * 1.5)
            card.ability.extra.current = math.max(card.ability.extra.value * result, 1)
            G.GAME.current_round.hands_left = 1
            return { message = "Upgraded!", dollars = math.max(0, cash) }
        elseif context.joker_main then
            return { xmult = card.ability.extra.current }
        elseif context.end_of_round and context.main_eval then
            card.ability.extra.current = 1
            return { message = "Reset!" }
        end
    end,
    pools = { ["CJModSet"] = true, ["CJModSetFull"] = true },
}

SMODS.Joker {
    key = "colorjoker",
    pos = { x = 1, y = 3 },
    rarity = 2,
    atlas = "main",
    config = { extra = { heart = 3, diamond = 1.15, club = 20, spade = 1.1 } },

    blueprint_compat = true,
    cost = 5,
    loc_txt = {
        name = "Color Theory",
        text = {
            "{C:chips}+#3#{} Chips when scoring {C:clubs}clubs{},",
            "{C:mult}+#1#{} Mult when scoring {C:hearts}hearts{},",
            "{X:mult,C:white}X#2#{} when scoring {C:diamonds}diamonds{},",
            "{X:chips,C:white}X#4#{} when scoring {C:spades}spades{}"
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.heart, card.ability.extra.diamond, card.ability.extra.club, card.ability.extra.spade } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card and not context.other_card.debuff and not SMODS.has_enhancement(context.other_card, "m_stone") then
            if context.other_card.base.suit == "Diamonds" then
                return { xmult = card.ability.extra.diamond }
            elseif context.other_card.base.suit == "Hearts" then
                return { mult = card.ability.extra.heart }
            elseif context.other_card.base.suit == "Clubs" then
                return { chips = card.ability.extra.club }
            else
                return { xchips = card.ability.extra.spade }
            end
        end
    end,
    pools = { ["CJModSet"] = true, ["CJModSetFull"] = true },
}

SMODS.Joker {
    key = "geminijoker",
    pos = { x = 2, y = 3 },
    rarity = 2,
    atlas = "main",
    config = { extra = { mult = 6, type = "Pair", candupe = true }, mod_conv = 'j_CJMod_twinjoker' },

    blueprint_compat = true,
    cost = 8,
    loc_txt = {
        name = "Gemini",
        text = {
            "{C:mult}+#1# Mult{} if hand contains a {C:mult}pair{}",
            "{C:attention}When sold{}, create 2 {C:green}Gemini Twins{}, one {C:dark_edition}negative{}"
        }
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS[card.ability.mod_conv]
        return { vars = { card.ability.extra.mult, localize { type = "name_text", set = "Enhanced", key = card.ability.mod_conv } } }
    end,
    calculate = function(self, card, context)
        if context.joker_main and next(context.poker_hands["Pair"]) then
            return { mult = card.ability.extra.mult }
        elseif context.selling_self and not context.blueprint_card and card.ability.extra.candupe then
            card.ability.extra.candupe = false
            G.E_MANAGER:add_event(Event({
                trigger = "after",
                delay = 0.3,
                func = (function()
                    SMODS.add_card({ key = "j_CJMod_twinjoker", edition = "e_negative" })
                    play_sound('timpani')
                    return true
                end)
            }))
            G.E_MANAGER:add_event(Event({
                trigger = "after",
                delay = 0.3,
                func = (function()
                    if G.jokers then
                        G.jokers.config.card_limit = G.jokers.config.card_limit + 1
                    end
                    if card.edition then
                        SMODS.add_card({ key = "j_CJMod_twinjoker", edition = "e_" .. card.edition.type })
                    else
                        SMODS.add_card({ key = "j_CJMod_twinjoker" })
                    end

                    play_sound('timpani')

                    G.jokers.config.card_limit = G.jokers.config.card_limit - 1
                    return true
                end)
            }))
            return nil, true
        end
    end,
    pools = { ["CJModSet"] = true, ["CJModSetFull"] = true, ["CJModChess"] = true },
}

SMODS.Joker {
    key = "twinjoker",
    pos = { x = 3, y = 3 },
    rarity = 1,
    atlas = "main",
    config = { extra = { xmult = 1.25, type = "Pair" } },

    blueprint_compat = true,
    cost = 1,
    loc_txt = {
        name = "Gemini Twin",
        text = {
            "{X:mult,C:white}X#1#{} Mult if hand",
            "contains a {C:mult}pair{}",
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main and next(context.poker_hands["Pair"]) then
            return { xmult = card.ability.extra.xmult }
        end
    end,
    in_pool = function(self, args)
        return false
    end,
}

SMODS.Joker {
    key = "gjoker",
    pos = { x = 4, y = 3 },
    rarity = "CJMod_stupid",
    atlas = "main",
    config = { extra = { times = 1, exhaust = 4, max = 4 } },

    blueprint_compat = false,
    cost = 8,
    loc_txt = {
        name = "g",
        text = {
            "Retrigger jokers that have",
            "a {C:mult}'g'{} in their name #1# time",
            "up to #2# times per played hand"
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.times, card.ability.extra.exhaust } }
    end,
    calculate = function(self, card, context)
        if context.retrigger_joker_check and context.other_card then
            local jokertotrigger = context.other_card
            if not jokertotrigger then return end
            if jokertotrigger ~= card and jokertotrigger.config and jokertotrigger.config.center and (jokertotrigger.config.blueprint_compat == nil or jokertotrigger.config.blueprint_compat) and card.ability.extra.exhaust > 0 then
                if jokertotrigger.loc_txt and jokertotrigger.loc_txt.name then
                    if jokertotrigger.loc_txt.name == "g" then return end
                    if string.find(string.lower(jokertotrigger.loc_txt.name), "g") then
                        card.ability.extra.exhaust = card.ability.extra.exhaust - 1
                        return { repetitions = card.ability.extra.times }
                    end
                else
                    local name = localize({ type = 'name_text', key = jokertotrigger.config.center_key, set = 'Joker' })
                    if name and type(name) == "string" and string.find(string.lower(name), "g") then
                        card.ability.extra.exhaust = card.ability.extra.exhaust - 1
                        return { repetitions = card.ability.extra.times, message = "g", message_colour = G.C.CHIPS }
                    end
                end
            end
        elseif context.before then
            card.ability.extra.exhaust = card.ability.extra.max
        end
    end,
    pools = { ["CJModSet"] = true, ["CJModSetFull"] = true },
}

SMODS.Joker {
    key = "gorgonjoker",
    pos = { x = 0, y = 4 },
    rarity = 2,
    atlas = "main",
    config = { mod_conv = 'm_stone' },

    blueprint_compat = true,
    cost = 7,
    loc_txt = {
        name = "Gorgon Mask",
        text = {
            "All played face cards",
            "are turned into stone",
            "cards if they score"
        }
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS[card.ability.mod_conv]
        return { vars = { localize { type = "name_text", set = "Enhanced", key = card.ability.mod_conv } } }
    end,
    calculate = function(self, card, context)
        if context.before and not context.blueprint_card then
            local faces = 0
            for _, scored_card in ipairs(context.scoring_hand) do
                if scored_card:is_face() then
                    faces = faces + 1
                    scored_card:set_ability('m_stone', nil, true)
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            scored_card:juice_up()
                            return true
                        end
                    }))
                end
            end
            if faces > 0 then
                return {
                    message = "Petrified!",
                    colour = G.C.GREY
                }
            end
        end
    end,
    pools = { ["CJModSet"] = true, ["CJModSetFull"] = true },
}

SMODS.Joker {
    key = "snakejoker",
    pos = { x = 1, y = 4 },
    rarity = 2,
    atlas = "main",
    config = { mod_conv = 'CJMod_venom', chips = 40, increase = 3, firstdiscard = true },

    blueprint_compat = false,
    cost = 5,
    loc_txt = {
        name = "Envenomer",
        text = {
            "Applies a {C:green}Venom Seal{}",
            "to first {C:mult}discarded{} hand",
            "and gains {C:chips}+#3#{} chips for each card {C:mult}discarded{}",
            "{C:chips}+#2#{} Chips when playing a card with",
            "a {C:green}Venom Seal{}"
        }
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_SEALS[card.ability.mod_conv]
        return { vars = { card.ability.mod_conv, card.ability.chips, card.ability.increase } }
    end,
    calculate = function(self, card, context)
        if context.first_hand_drawn then
            local eval = function() return G.GAME.current_round.discards_used == 0 and not G.RESET_JIGGLES end
            juice_card_until(card, eval, true)
        elseif context.pre_discard and not context.blueprint and G.GAME.current_round.discards_used <= 0 then
            local count = 0
            for n, x in pairs(context.full_hand) do
                if x:get_seal(true) ~= "CJMod_venom" then
                    card.ability.chips = card.ability.chips + card.ability.increase
                    G.E_MANAGER:add_event(Event({
                        trigger = "after",
                        delay = 0.075,
                        func = function()
                            card:juice_up()
                            x:set_seal("CJMod_venom", nil, true)
                            play_sound("generic1", math.random(10, 15)*0.1)
                            return true
                        end
                    }))
                    count = count + 1
                    delay(0.5)
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.2,
                        func = function()
                            G.hand:unhighlight_all()
                            return true
                        end
                    }))
                end
            end
            if count > 0 then
                return { message = "Upgraded!", message_colour = G.C.green }
            end
        elseif context.individual and context.cardarea == G.play then
            if context.other_card:get_seal(false) == "CJMod_venom" then
                return { chips = card.ability.chips }
            end
        end
    end,
    pools = { ["CJModSet"] = true, ["CJModSetFull"] = true },
}

SMODS.Joker {
    key = "ascapedjoker",
    pos = { x = 2, y = 4 },
    rarity = "CJMod_stupid",
    atlas = "main",
    config = { extra = { max = 8 } },

    cost = 10,
    blueprint_compat = false,
    loc_txt = {
        name = "Ascaped",
        text = {
            "On {C:mult}boss blinds,{}",
            "{C:attention}fill hand{} with cards with random",
            "seals and enhancements",
            "{C:attention}1 / 3 of the cards{} have a random edition"
        }
    },
    calculate = function(self, card, context)
        if context.setting_blind and not context.blueprint and context.blind.boss then
            for i = 1, G.hand.config.card_limit do
                local _card = SMODS.create_card { set = "Base", seal = SMODS.poll_seal({ guaranteed = true, type_key = 'ascaped' }), area = G.discard }
                _card:set_ability(SMODS.poll_enhancement({ guaranteed = true }))
                G.E_MANAGER:add_event(Event({
                    func = function()
                        if i > math.floor((G.hand.config.card_limit * 2) / 3) then
                            _card:set_edition(poll_edition(nil, true, false, true))
                        end
                        G.playing_card = (G.playing_card and G.playing_card + 1) or 1
                        _card.playing_card = G.playing_card
                        table.insert(G.playing_cards, _card)
                        return true
                    end
                }))

                G.E_MANAGER:add_event(Event({
                    func = function()
                        G.hand:emplace(_card)
                        _card:start_materialize()
                        G.GAME.blind:debuff_card(_card)
                        G.hand:sort()
                        card:juice_up()
                        SMODS.calculate_context({ playing_card_added = true, cards = { _card } })
                        save_run()
                        return true
                    end
                }))
                delay(0.5)
            end
            return { message = "Added!", message_colour = G.C.GREEN }
        end
    end,
    pools = { ["CJModSetFull"] = true },
}

SMODS.Joker {
    key = "hivejoker",
    pos = { x = 3, y = 4 },
    rarity = 2,
    atlas = "main",
    config = { extra = { xmult = 1.05, chips = 10, chipsinc = 10, xmultinc = 0.05 } },

    blueprint_compat = true,
    cost = 5,
    loc_txt = {
        name = "Hivemind",
        text = {
            "If played hand has {C:attention}atleast 3 Jacks{},",
            "convert a card in play or hand to a Jack, if possible",
            "{C:white,X:mult}X#1#{} Mult and {C:chips}+#2#{} Chips when",
            "scoring a Jack, and increases by {C:white,X:mult}X#4#{} and {C:chips}#3#{} chips",
            "{C:attention}for the current played hand{}"
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult, card.ability.extra.chips, card.ability.extra.chipsinc, card.ability.extra.xmultinc } }
    end,
    calculate = function(self, card, context)
        if context.before then
            local hand = G.play.cards
            local jacks = 0
            for n, x in pairs(hand) do
                if x:get_id() == 11 then
                    jacks = jacks + 1
                    if jacks >= 3 then
                        break
                    end
                end
            end
            if jacks >= 3 then
                local hand2 = G.hand.cards
                local superhand = { unpack(hand), unpack(hand2) }

                local nonjacks = {}

                card:juice_up()

                delay(0.3)

                for n, x in pairs(superhand) do
                    if x:get_id() ~= 11 and x.config.center_key ~= "m_stone" then
                        table.insert(nonjacks, x)
                    end
                end

                local toturn = nonjacks[pseudorandom("JackTransform", 1, #nonjacks)]
                if toturn then
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.15,
                        func = function()
                            play_sound('card1')
                            toturn:flip()
                            return true
                        end
                    }))

                    G.E_MANAGER:add_event(Event({
                        func = function()
                            assert(SMODS.change_base(toturn, nil, "Jack"))
                            return true
                        end
                    }))

                    delay(0.5)

                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.15,
                        func = function()
                            toturn:flip()
                            play_sound('tarot2', percent, 0.6)
                            toturn:juice_up(0.3, 0.3)
                            return true
                        end
                    }))
                end
            end
        elseif context.individual and context.other_card and context.cardarea == G.play then
            if context.other_card:get_id() == 11 and context.other_card.config.center_key ~= "m_stone" then
                local current1 = math.abs(card.ability.extra.chips)
                local current2 = math.abs(card.ability.extra.xmult)
                card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chipsinc
                card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmultinc
                return {
                    chips = current1,
                    xmult = current2,
                    message = "Upgraded!",
                    message_colour = G.C.ETERNAL
                }
            end
        elseif context.after then
            card.ability.extra.chips = 10
            card.ability.extra.xmult = 1.05
        end
    end,
    pools = { ["CJModSet"] = true, ["CJModSetFull"] = true },
}

SMODS.Joker {
    key = "atlasjoker",
    pos = { x = 4, y = 4 },
    rarity = 1,
    atlas = "main",
    config = { extra = { chips = 75 } },
    cost = 5,
    blueprint_compat = true,
    loc_txt = {
        name = "Bad Atlas",
        text = {
            "{C:chips}+#1#{} Chips if {C:chips}Chips{}",
            "is a multiple of {C:attention}2{} when triggered"
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            if hand_chips % 3 == 0 then
                return { chips = card.ability.extra.chips }
            end
        end
    end,
    pools = { ["CJModSet"] = true, ["CJModSetFull"] = true },
}

SMODS.Joker {
    key = "dejavujoker",
    pos = { x = 0, y = 5 },
    rarity = 3,
    atlas = "main",
    config = { mod_conv = 'Red', extra = { repeats = 2, otherrepeats = 1, size = 1 } },

    cost = 8,
    blueprint_compat = true,
    loc_txt = {
        name = "Deja Joker",
        text = {
            "Retriggers {C:red}Red Seals{}",
            "{C:attention}#2#{} times",
            "Retriggers other seals {C:attention}#3#{} time",
            "{C:red}-#3#{} hand size"
        }
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_SEALS[card.ability.mod_conv]
        return { vars = { card.ability.mod_conv, card.ability.extra.repeats, card.ability.extra.size } }
    end,
    add_to_deck = function(self, card, from_debuff)
        G.hand:change_size(-card.ability.extra.size)
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.hand:change_size(card.ability.extra.size)
    end,
    calculate = function(self, card, context)
        if context.repetition and context.cardarea then
            local crd = context.other_card
            if crd and crd:get_seal(false) == "Red" then
                return { repetitions = card.ability.extra.repeats }
            elseif crd and crd:get_seal(false) then
                return { repetitions = card.ability.extra.otherrepeats }
            end
        end
    end,
    pools = { ["CJModSet"] = true, ["CJModSetFull"] = true },
}

SMODS.Joker {
    key = "rockjoker",
    pos = { x = 2, y = 5 },
    rarity = 1,
    atlas = "main",
    config = { extra = { money = 5, sell = 8, obtained = false } },

    cost = 0,
    blueprint_compat = false,
    loc_txt = {
        name = "Blockage",
        text = {
            "Costs {C:attention}nothing{}",
            "Gives {C:attention}#1#${} when obtained,",
            "costs {C:attention}#2#${} to sell"
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.money, card.ability.extra.sell } }
    end,
    set_ability = function (self, card, initial, delay_sprites)
        card.ability.couponed = true
        card:set_cost()
    end,
    add_to_deck = function(self, card)
        if card and not card.ability.extra.obtained then
            card.ability.extra.obtained = true
            ease_dollars(card.ability.extra.money, true)
            card:juice_up()
            card.ability.extra_value = -(card.ability.extra.sell + card.sell_cost)
            card:set_cost()
        end
    end,
    pools = { ["CJModSet"] = true, ["CJModSetFull"] = true },
}

SMODS.Joker {
    key = "vipjoker",
    pos = { x = 3, y = 5 },
    rarity = 1,
    atlas = "main",
    config = { extra = { cost = 4 } },

    cost = 3,
    blueprint_compat = false,
    loc_txt = {
        name = "VIP Card",
        text = {
            "When the last {C:red}discard{} is used",
            "and you have {C:attention#1#${} or more,",
            "spend {C:attention}#1#${} and get an additional",
            "{C:red}discard{}"
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.cost } }
    end,
    calculate = function(self, card, context)
        if context.pre_discard and G.GAME.current_round.discards_left <= 1 then
            if G.GAME.dollars >= card.ability.extra.cost then
                ease_dollars(-card.ability.extra.cost, true)
                ease_discard(1, true)
                card:juice_up(0.3, 0.5)
                return { message = -card.ability.extra.cost .. "$", message_colour = G.C.RED }
            end
        end
    end,
    pools = { ["CJModSet"] = true, ["CJModSetFull"] = true },
}

SMODS.Joker {
    key = "violetjoker",
    pos = { x = 4, y = 5 },
    rarity = 3,
    atlas = "main",
    config = { mod_conv = 'CJMod_venom', extra = { first = false } },

    cost = 9,
    blueprint_compat = false,
    loc_txt = {
        name = "Everlasting Violet",
        text = {
            "Prevents {C:green}Venom Seals{} from decaying",
            "Applies a {C:green}Venom Seal{} to the first card scored",
            "in the playing hand which doesn't have a seal"
        }
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_SEALS[card.ability.mod_conv]
        return { vars = { card.ability.mod_conv } }
    end,
    calculate = function(self, card, context)
        if context.before then
            card.ability.extra.first = true
        elseif context.individual and context.other_card and card.ability.extra.first and context.cardarea == G.play then
            local crd = context.other_card
            if crd and not crd:get_seal(true) then
                card.ability.extra.first = false
                card:juice_up(0.3, 0.5)
                play_sound("generic1")
                crd:juice_up()
                crd:set_seal("CJMod_venom", nil, true)
            end
        end
    end,
    pools = { ["CJModSet"] = true, ["CJModSetFull"] = true },
}

SMODS.Joker {
    key = "exejoker",
    pos = { x = 0, y = 6 },
    rarity = 1,
    atlas = "main",
    config = { extra = { chips = 20, gain = 20 } },

    cost = 6,
    blueprint_compat = true,
    loc_txt = {
        name = "Joker.EXE",
        text = {
            "Destroys the Joker with the least {C:value}sell value{}",
            "and gains {C:chips}#2#{} Chips for every {C:attention}${} of value",
            "it had before destruction",
            "{C:inactive}(Currently {C:chips}#1#{C:inactive} Chips)"
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips, card.ability.extra.gain } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return { chips = card.ability.extra.chips }
        elseif context.setting_blind and not context.blueprint_card then
            local jokers = G.jokers.cards
            local candestroy = {}

            for n, x in pairs(jokers) do
                if not SMODS.is_eternal(x) and x.config and x.config.center_key ~= card.config.center_key then
                    table.insert(candestroy, x)
                end
            end

            if #candestroy > 0 then
                local values = {}
                local cheapest = math.huge
                for n, x in pairs(candestroy) do
                    if x.sell_cost < cheapest then
                        cheapest = x.sell_cost
                    end
                end

                local selected = {}
                for n, x in pairs(jokers) do
                    if x.sell_cost == cheapest then
                        table.insert(selected, x)
                    end
                end

                local selectedjoker = selected[pseudorandom("EXESelection", 1, #selected)]
                if selectedjoker then
                    G.E_MANAGER:add_event(Event({
                        trigger = "after",
                        delay = 0.2,
                        func = function()
                            card.ability.extra.chips = card.ability.extra.chips +
                                (selectedjoker.sell_cost * card.ability.extra.gain)
                            play_sound("slice1")
                            selectedjoker:juice_up(0.3, 0.5)
                            SMODS.destroy_cards(selectedjoker, false, false, false)
                            card:juice_up(0.5, 0.7)
                            return true
                        end
                    }))
                    return { message = "Upgraded!", message_colour = G.C.RED }
                end
            end
        end
    end,
    pools = { ["CJModSet"] = true, ["CJModSetFull"] = true },
}

SMODS.Joker {
    key = "schooljoker",
    pos = { x = 1, y = 6 },
    rarity = 2,
    atlas = "main",
    config = { extra = { enabled = "Active" }, mod_conv = "tag_garbage" },

    cost = 9,
    blueprint_compat = false,
    loc_txt = {
        name = "Boredom Sketch",
        text = {
            "Skipping a blind gives a",
            "guaranteed {C:green}Garbage Tag{}",
            "Can activate again after beating a blind",
            "{C:inactive}(Currently #1#){}"
        }
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_TAGS[card.ability.mod_conv]
        return { vars = { card.ability.extra.enabled } }
    end,
    calculate = function(self, card, context)
        if context.skip_blind and card.ability.extra.enabled == "Active" then
            G.E_MANAGER:add_event(Event({
                func = (function()
                    add_tag(Tag(card.ability.mod_conv))
                    play_sound('generic1', 0.9 + math.random() * 0.1, 0.8)
                    play_sound('holo1', 1.2 + math.random() * 0.1, 0.4)
                    return true
                end)
            }))
            card.ability.extra.enabled = "Inactive"
        elseif context.blind_defeated then
            card.ability.extra.enabled = "Active"
        end
    end,
    pools = { ["CJModSet"] = true, ["CJModSetFull"] = true },
}

SMODS.Joker {
    key = "tpjoker",
    pos = { x = 2, y = 6 },
    rarity = 1,
    atlas = "main",
    config = { extra = { chips = 40, odds = 2, candupe = false } },
    eternal_compat = false,
    cost = 9,
    blueprint_compat = false,
    loc_txt = {
        name = "Expendable Paper",
        text = {
            "{C:chips}+#1#{} Chips",
            "{C:green}#2# in #3#{} chance to {C:red}self destruct{} at start of blind",
            "If {C:red}self destruct{} fails, generates a {C:dark_edition}negative{}",
            "copy of itself"
        }
    },
    loc_vars = function(self, info_queue, card)
        local nom, denom = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, "TPDestruct")
        info_queue[#info_queue + 1] = G.P_CENTERS["e_negative"]
        return { vars = { card.ability.extra.chips, nom, denom } }
    end,
    calculate = function(self, card, context)
        card.sell_cost = 0
        card:set_cost()
        if context.setting_blind then
            if not card.ability.extra.candupe and card.edition and card.edition.key == "e_negative" then
                card.ability.extra.candupe = true
                return
            else
                card.ability.extra.candupe = true
            end
            card.ability.extra.candupe = false
            if SMODS.pseudorandom_probability(card, "FinnaBlowUp", 1, card.ability.extra.odds, "TPDestruct") then
                SMODS.destroy_cards(card, false, false, false)
            else
                SMODS.add_card({ key = "j_CJMod_tpjoker", edition = "e_negative" })
            end
        elseif context.joker_main then
            return { chips = card.ability.extra.chips }
        elseif context.ending_shop then
            card.ability.extra.candupe = true
        elseif context.skip_blind then
            card.ability.extra.candupe = true
        end
    end,
    pools = { ["CJModSet"] = true, ["CJModSetFull"] = true },
}

SMODS.Joker {
    key = "envyjoker",
    pos = { x = 3, y = 6 },
    rarity = 2,
    atlas = "main",
    config = { extra = { current = "", name = "None" } },

    cost = 7,
    blueprint_compat = false,
    loc_txt = {
        name = "Envy",
        text = {
            "When sold, creates a copy of",
            "the last Joker you sold with a random",
            "non-{C:dark_edition}negative{} edition",
            "{C:inactive}(Except Envy){}",
            "{C:inactive}(Current: #1#)"
        }
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS["e_negative"]
        return { vars = { card.ability.extra.name } }
    end,
    calculate = function(self, card, context)
        if context.selling_self and not context.blueprint_card then
            local current = card.ability.extra.current
            if current then
                SMODS.add_card({ key = card.ability.extra.current, edition = poll_edition(nil, true, true, true) })
            end
            play_sound("timpani")
        elseif context.selling_card and context.cardarea == G.jokers and context.card and context.card.config and context.card.config.center_key ~= card.config.center_key then
            if context.card.config and string.find(context.card.config.center_key, "c_") == 1 then
                return nil, true
            end
            if context.card.loc_txt and context.card.loc_txt.name then
                card.ability.extra.name = context.card.loc_txt.name
            else
                local name = localize({ type = 'name_text', key = context.card.config.center_key, set = 'Joker' })
                card.ability.extra.name = name
            end
            card.ability.extra.current = context.card.config.center_key
            return { message = "Copied!", message_colour = G.C.BLACK }
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        card.ability.extra_value = -(card.sell_cost) + 1
        card:set_cost()
    end,
    pools = { ["CJModSet"] = true, ["CJModSetFull"] = true, ["CJModChess"] = true },
}

SMODS.Joker {
    key = "pawnjoker",
    pos = { x = 4, y = 6 },
    rarity = 2,
    atlas = "main",
    config = { extra = { chips = 30, left = 6 } },

    cost = 5,
    blueprint_compat = false,
    loc_txt = {
        name = "Pawn",
        text = {
            "{C:chips}+#1#{} Chips",
            "After {C:attention}#2#{} triggers,",
            "Transform into a {C:green}random{}",
            "chess-related Joker"
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips, card.ability.extra.left } }
    end,
    calculate = function(self, card, context)
        if context.joker_main and not context.blueprint_card then
            card.ability.extra.left = card.ability.extra.left - 1
            return {
                chips = card.ability.extra.chips,
                message = card.ability.extra.left .. " Left!",
                message_colour = G
                    .C.BLACK
            }
        elseif context.after then
            if card.ability.extra.left <= 0 then
                G.E_MANAGER:add_event(Event({
                    func = (function()
                        local newcard = nil
                        if card.edition then
                            newcard = SMODS.add_card({ set = "CJModChess", edition = "e_" .. card.edition.type })
                        else
                            newcard = SMODS.add_card({ set = "CJModChess", poll_edition(nil, nil, false, false) })
                        end
                        SMODS.destroy_cards(card, false, false, false)
                        play_sound("timpani")
                        return true
                    end)
                }))
                return { message = "Promoted!", message_colour = G.C.BLACK }
            end
        end
    end,
    pools = { ["CJModSet"] = true, ["CJModSetFull"] = true },
}

-- chess battle advanced
SMODS.Joker {
    key = "greedjoker",
    pos = { x = 0, y = 7 },
    rarity = 1,
    atlas = "main",
    config = { extra = { xmult = 1.6, cost = 2, payback = 5 } },

    cost = 7,
    blueprint_compat = true,
    loc_txt = {
        name = "Greed",
        text = {
            "{C:dark_edition}+1{} Joker Slot",
            "{X:mult,C:white}X#1#{} Mult",
            "Each trigger costs {C:attention}#2#${}",
            "If price cannot be afforded,",
            "destroys itself and gives {C:yellow}#3#${}"
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult, card.ability.extra.cost, card.ability.extra.payback } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            if card.ability.extra.cost + G.GAME.bankrupt_at <= G.GAME.dollars then
                return { xmult = card.ability.extra.xmult, dollars = -card.ability.extra.cost }
            else
                SMODS.destroy_cards(card, false, false, false)
                return { dollars = card.ability.extra.payback }
            end
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        G.jokers.config.card_limit = G.jokers.config.card_limit + 1
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.jokers.config.card_limit = G.jokers.config.card_limit - 1
    end,
    pools = { ["CJModSet"] = true, ["CJModSetFull"] = true, ["CJModChess"] = true },
}

SMODS.Joker {
    key = "moonjoker",
    pos = { x = 1, y = 7 },
    rarity = 2,
    atlas = "main",
    config = { extra = { xchips = 1.4, cost = 4, blindcounter = 0, type = "Straight" } },

    cost = 9,
    blueprint_compat = true,
    loc_txt = {
        name = "Moon Fox",
        text = {
            "{X:chips,C:white}X#1#{} Chips if hand",
            "contains a Straight",
            "If sold while its' sell cost is {C:attention}#2#{} or more,",
            "creates a copy of itself with {C:attention}#2#{} less value",
            "Gains {C:attention}1${} sell cost every",
            "2 blinds defeated",
            "{C:inactive}(Currently {C:attention}#3#{C:inactive}){}"
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xchips, card.ability.extra.cost, card.ability.extra.blindcounter } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            if next(context.poker_hands[card.ability.extra.type]) then
                return { xchips = card.ability.extra.xchips }
            end
        elseif context.selling_self and not context.blueprint_card then
            if card.sell_cost >= card.ability.extra.cost then
                G.E_MANAGER:add_event(Event({
                    trigger = "after",
                    delay = 0.3,
                    func = (function()
                        local newcard = nil
                        if card.edition then
                            newcard = SMODS.add_card({ key = card.config.center_key, edition = "e_" .. card.edition.type })
                        else
                            newcard = SMODS.add_card({ key = card.config.center_key })
                        end
                        newcard.ability.extra_value = newcard.ability.extra_value - card.ability.extra.cost
                        newcard:set_cost()
                        play_sound("timpani")
                        return true
                    end)
                }))
            end
        elseif context.blind_defeated then
            card.ability.extra.blindcounter = card.ability.extra.blindcounter + 1
            if card.ability.extra.blindcounter >= 2 then
                card.ability.extra_value = card.ability.extra_value + 1
                card:set_cost()
                return { message = "Value up!" }
            end
        end
    end,
    pools = { ["CJModSet"] = true, ["CJModSetFull"] = true, ["CJModChess"] = true },
}

SMODS.Joker {
    key = "queenjoker",
    pos = { x = 2, y = 7 },
    rarity = "CJMod_stupid",
    atlas = "main",
    config = { extra = { xmult = 5, type = "High Card" } },

    cost = 25,
    blueprint_compat = true,
    loc_txt = {
        name = "Queen",
        text = {
            "{X:mult,C:white}X#1#{} Mult",
            "If played hand is a High Card"
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            if context.scoring_name == localize(card.ability.extra.type, 'poker_hands') then
                return { xmult = card.ability.extra.xmult }
            end
        end
    end,
    pools = { ["CJModSet"] = true, ["CJModSetFull"] = true, ["CJModChess"] = true },
}

SMODS.Joker {
    key = "patiencejoker",
    pos = { x = 3, y = 7 },
    rarity = 1,
    atlas = "main",
    config = { extra = { xmult = 1.5, remaining = 4, default = 4 } },

    cost = 9,
    blueprint_compat = true,
    loc_txt = {
        name = "Patience",
        text = {
            "After {C:attention}#2#{} discards,",
            "Becomes {C:green}active{}",
            "If active, {X:mult,C:white}X#1#{} Mult",
            "{C:inactive}(Resets after boss blind){}"
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult, card.ability.extra.remaining, card.ability.extra.default } }
    end,
    calculate = function(self, card, context)
        if context.joker_main and card.ability.extra.remaining <= 0 then
            return { xmult = card.ability.extra.xmult }
        elseif context.pre_discard and not context.blueprint_card and card.ability.extra.remaining > 0 then
            card.ability.extra.remaining = math.max(0, card.ability.extra.remaining - 1)
            if card.ability.extra.remaining <= 0 then
                G.E_MANAGER:add_event(Event({
                    func = (function()
                        play_sound('generic1', 0.9 + math.random() * 0.1, 0.8)
                        play_sound('holo1', 1.2 + math.random() * 0.1, 0.4)
                        return true
                    end)
                }))
                card:juice_up(0.5, 0.8)
                return { message = "Activated!" }
            else
                return { message = card.ability.extra.remaining .. " Left!" }
            end
        elseif context.end_of_round and context.beat_boss and context.cardarea == G.jokers then
            card.ability.extra.remaining = card.ability.extra.default
            return { message = "Reset!" }
        end
    end,
    pools = { ["CJModSet"] = true, ["CJModSetFull"] = true, ["CJModChess"] = true },
}

SMODS.Joker {
    key = "knightjoker",
    pos = { x = 4, y = 7 },
    rarity = 1,
    atlas = "main",
    config = { extra = { [1] = 20, [2] = 50, [3] = 125, [4] = 200, CJMod_stupid = 300, currentchips = 20 } },

    cost = 7,
    blueprint_compat = true,
    loc_txt = {
        name = "Knight",
        text = {
            "Gives {C:chips}+Chips{} based on",
            "the rarity of the Jokers around it",
            "If it's the only Joker, {C:chips}+#1#{} Chips",
            "{C:inactive}(Current chips: {C:chips}#5#{C:inactive}){}"
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra[1], card.ability.extra[2], card.ability.extra[3], card.ability.extra[4], card.ability.extra.currentchips } }
    end,
    calculate = function(self, card, context)
        local startpos = find(G.jokers.cards, card)
        if startpos and #G.jokers.cards > 1 then
            local chips = 0
            local leftpos = startpos - 1
            local rightpos = startpos + 1
            if G.jokers.cards[leftpos] then
                local leftjoker = G.jokers.cards[leftpos]
                if leftjoker.config and leftjoker.config.center and leftjoker.config.center.rarity and card.ability.extra[leftjoker.config.center.rarity] then
                    chips = chips + card.ability.extra[leftjoker.config.center.rarity]
                end
            end
            if G.jokers.cards[rightpos] then
                local rightjoker = G.jokers.cards[rightpos]
                if rightjoker.config and rightjoker.config.center and rightjoker.config.center.rarity and card.ability.extra[rightjoker.config.center.rarity] then
                    chips = chips + card.ability.extra[rightjoker.config.center.rarity]
                end
            end
            if chips > 0 then
                card.ability.extra.currentchips = chips
            end
        elseif #G.jokers.cards <= 1 then
            card.ability.extra.currentchips = 20
        end
        if context.joker_main then
            return { chips = card.ability.extra.currentchips }
        end
    end,
    pools = { ["CJModSet"] = true, ["CJModSetFull"] = true, ["CJModChess"] = true },
}

SMODS.Joker {
    key = "starjoker",
    pos = { x = 0, y = 8 },
    rarity = 2,
    atlas = "main",
    config = { extra = { min = 5, upgrades = 0 } },

    cost = 8,
    blueprint_compat = false,
    loc_txt = {
        name = "Stargazer",
        text = {
            "If you have atleast {C:attention}#1#{} upgraded hands",
            "create a {C:dark_edition}Black Hole{} on boss blinds",
            "Otherwise, create a {C:attention}Planet Card{}",
            "{C:inactive}(Must have room){}",
            "{C:inactive}(Current upgrades: {C:red}#2#{C:inactive}){}"
        }
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS["c_black_hole"]
        return { vars = { card.ability.extra.min, card.ability.extra.upgrades } }
    end,
    calculate = function(self, card, context)
        local hands = G.GAME.hands
        local upgrades = {}
        for n, x in pairs(hands) do
            if x.level > 1 then
                table.insert(upgrades, n)
            end
        end
        card.ability.extra.upgrades = #upgrades
        if context.setting_blind and G.GAME.blind.boss then
            if G.consumeables.config.card_limit <= #G.consumeables.cards then
                return
            else
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    func = function()
                        play_sound("timpani")
                        card:juice_up(0.3, 0.5)
                        if #upgrades >= card.ability.extra.min then
                            SMODS.add_card { key = "c_black_hole" }
                        else
                            SMODS.add_card { set = "Planet" }
                        end
                        return true
                    end
                }))

                return { message = "Lookie!" }
            end
        end
    end,
    pools = { ["CJModSet"] = true, ["CJModSetFull"] = true },
}

SMODS.Joker {
    key = "elfjoker",
    pos = { x = 1, y = 8 },
    rarity = 3,
    atlas = "main",
    config = { extra = {} },

    cost = 15,
    blueprint_compat = false,
    loc_txt = {
        name = "ytmpv elf",
        text = {
            "Sell this Joker to create a",
            "random {C:dark_edition}Polychrome{} Joker"
        }
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS["e_polychrome"]
        return { vars = {} }
    end,
    add_to_deck = function(self, card, from_debuff)
        card.ability.extra_value = card.ability.extra_value - 9
        card:set_cost()
    end,
    calculate = function(self, card, context)
        if context.selling_self then
            G.FUNCS.overlay_menu {
                definition = create_UIBox_custom_video1("elf", "fuck yeah"),
                config = { no_esc = true }
            }
            SMODS.add_card({ set = "Joker", edition = "e_polychrome" })
        end
    end,
    pools = { ["CJModSet"] = true, ["CJModSetFull"] = true },
}

SMODS.Joker {
    key = "shitstormjoker",
    pos = { x = 2, y = 8 },
    rarity = 3,
    atlas = "main",
    config = { extra = {} },

    cost = 10,
    blueprint_compat = true,
    loc_txt = {
        name = "Brainstorm",
        text = {
            "Copies the ability",
            "of leftmost {C:attention}Joker{}"
        }
    },
    no_collection = true,
    no_mod_badge = true,
    loc_vars = function(self, info_queue, card)
        if card.area and card.area == G.jokers then
            local compatible = G.jokers.cards[1] and G.jokers.cards[1] ~= card and
                G.jokers.cards[1].config.center.blueprint_compat
            local main_end = {
                {
                    n = G.UIT.C,
                    config = { align = "bm", minh = 0.4 },
                    nodes = {
                        {
                            n = G.UIT.C,
                            config = { ref_table = card, align = "m", colour = compatible and mix_colours(G.C.GREEN, G.C.JOKER_GREY, 0.8) or mix_colours(G.C.RED, G.C.JOKER_GREY, 0.8), r = 0.05, padding = 0.06 },
                            nodes = {
                                { n = G.UIT.T, config = { text = ' ' .. localize('k_' .. (compatible and 'compatible' or 'incompatible')) .. ' ', colour = G.C.UI.TEXT_LIGHT, scale = 0.32 * 0.8 } },
                            }
                        }
                    }
                }
            }
            return { main_end = main_end }
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        SMODS.destroy_cards(card, true, true, true)
        G.FUNCS.overlay_menu {
            definition = create_UIBox_custom_video1("fart", "wtf?"),
            config = { no_esc = true }
        }
    end,
}

SMODS.Joker {
    key = "balalajoker",
    pos = { x = 0, y = 9 },
    rarity = 1,
    atlas = "main",
    config = { extra = { mult = 3, supermult = 10 } },

    cost = 4,
    blueprint_compat = true,
    loc_txt = {
        name = "Knockoff Joker",
        text = {
            "{C:mult}+#1#{} Mult",
            "{C:mult}+#2#{} Mult instead if",
            "you have a Regular Joker"
        }
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS["j_joker"]
        return { vars = { card.ability.extra.mult, card.ability.extra.supermult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local jokers = G.jokers.cards
            for n, x in pairs(jokers) do
                if x.config and x.config.center_key == "j_joker" then
                    return { mult = card.ability.extra.supermult }
                end
            end
            return { mult = card.ability.extra.mult }
        end
    end,
    pools = { ["CJModSet"] = true, ["CJModSetFull"] = true, }
}

SMODS.Joker {
    key = "him",
    pos = { x = 1, y = 9 },
    rarity = 1,
    atlas = "main",
    config = { extra = { mult = 10 } },

    cost = 5,
    blueprint_compat = true,
    loc_txt = {
        name = "Him",
        text = {
            "{C:mult}+#1#{} Mult for",
            "each {C:blue}Food Joker{} you have"
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local times = 0
            local jokers = G.jokers.cards
            for n, x in pairs(jokers) do
                if x.config and x.config.center_key and (x.config.center.pools or {}).food or x.food then
                    times = times + 1
                end
            end
            if times > 0 then
                return { mult = card.ability.extra.mult * times }
            end
        end
    end,
    pools = { ["CJModSet"] = true, ["CJModSetFull"] = true, }
}

SMODS.Joker {
    key = "sddfg",
    pos = { x = 2, y = 9 },
    rarity = 1,
    atlas = "main",
    config = { extra = { mult = 20, type = "Full House" } },

    cost = 5,
    blueprint_compat = true,
    loc_txt = {
        name = "hasidfguahgfjokeasdr",
        text = {
            "sapdo32ajf{C:mult}mult{}saod",
            "osdai{C:mult}#1#{}sodjawi12ddwa",
            "apkjdwè+à{C:attention}full{}dwoak",
            "wd{C:attention}house{}dwasaw'oa?sdx"
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            if next(context.poker_hands[card.ability.extra.type]) then
                return { mult = card.ability.extra.mult }
            end
        end
    end,
    pools = { ["CJModSet"] = true, ["CJModSetFull"] = true, }
}

SMODS.Joker {
    key = "all1joker",
    pos = { x = 3, y = 8 },
    rarity = 2,
    atlas = "main",
    config = { extra = {} },

    cost = 6,
    blueprint_compat = false,
    loc_txt = {
        name = "Welp! All 1s",
        text = {
            "Reduces all {C:attention}listed{} {C:green}probabilities{}",
            "{C:inactive}(ex: {C:green}1 in 4{C:inactive} -> {C:green}1 in 6{C:inactive})"
        }
    },
    calculate = function(self, card, context)
        if context.mod_probability and not context.blueprint then
            return {
                denominator = math.max(context.denominator, math.floor(context.denominator * 1.5))
            }
        end
    end,
    pools = { ["CJModSet"] = true, ["CJModSetFull"] = true, }
}

SMODS.Joker {
    key = "customjoker",
    pos = { x = 4, y = 8 },
    rarity = 1,
    atlas = "main",
    config = {},

    cost = 6,
    blueprint_compat = true,
    loc_txt = {
        name = "Custom Card",
        text = {
            "At the start of the blind,",
            "create a card with a random",
            "{C:dark_edition}enhancement{}"
        }
    },
    calculate = function(self, card, context)
        if context.setting_blind and not context.blueprint then
            local _card = SMODS.create_card { set = "Base", area = G.discard }
            _card:set_ability(SMODS.poll_enhancement({ guaranteed = true }))
            G.E_MANAGER:add_event(Event({
                func = function()
                    G.playing_card = (G.playing_card and G.playing_card + 1) or 1
                    _card.playing_card = G.playing_card
                    table.insert(G.playing_cards, _card)
                    return true
                end
            }))

            G.E_MANAGER:add_event(Event({
                func = function()
                    G.hand:emplace(_card)
                    _card:start_materialize()
                    G.GAME.blind:debuff_card(_card)
                    G.hand:sort()
                    card:juice_up()
                    SMODS.calculate_context({ playing_card_added = true, cards = { _card } })
                    save_run()
                    return true
                end
            }))
            delay(0.5)
            return { message = "Added!" }
        end
    end,
    pools = { ["CJModSet"] = true, ["CJModSetFull"] = true },
}

SMODS.Joker {
    key = "macaron",
    pos = { x = 3, y = 9 },
    rarity = 1,
    atlas = "main",
    config = { extra = { cash = 2, cashleft = 16 } },

    cost = 6,
    eternal_compat = false,
    blueprint_compat = false,
    loc_txt = {
        name = "Macaron",
        text = {
            "{C:attention}+#1#${} when entering the Shop",
            "or opening a {C:purple}booster pack{}",
            "After giving {C:attention}#2#${}, automatically",
            "sells itself"
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.cash, card.ability.extra.cashleft } }
    end,
    add_to_deck = function(self, card, from_debuff)
        card.ability.extra_value = 2 - card.sell_cost
        card:set_cost()
    end,
    calculate = function(self, card, context)
        if context.starting_shop or context.open_booster then
            card.ability.extra.cashleft = card.ability.extra.cashleft - card.ability.extra.cash
            if card.ability.extra.cashleft <= 0 then
                G.E_MANAGER:add_event(Event({
                    func = (function()
                        card:sell_card()
                        return true
                    end)
                }))
                return { message = "Sold Out!", message_colour = G.C.YELLOW, dollars = card.ability.extra.cash }
            else
                return { dollars = card.ability.extra.cash }
            end
        end
    end,
    pools = { ["CJModSet"] = true, ["CJModSetFull"] = true },
}

SMODS.Joker {
    key = "purpurjoker",
    pos = { x = 4, y = 9 },
    rarity = 1,
    atlas = "main",
    config = { extra = { chips = 40 } },

    cost = 6,
    blueprint_compat = true,
    loc_txt = {
        name = "Purpur Joker",
        text = {
            "{C:chips}+#1#{} Chips when the",
            "Joker to its left triggers"
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips } }
    end,
    calculate = function(self, card, context)
        if context.post_trigger and context.other_card and G.GAME.blind and not context.end_of_round and not context.blind_defeated and not context.after and not context.discard and not context.pre_discard and not context.destroying_card and not context.drawing_cards and not context.hand_drawn and not context.first_hand_drawn and not context.selling_card and not context.using_consumeable then
            if G.STATE ~= G.STATES.HAND_PLAYED then return end
            local joker = context.other_card
            local pos = find(G.jokers.cards, card)
            local otherpos = find(G.jokers.cards, joker)
            if otherpos == pos + 1 then
                return { chips = card.ability.extra.chips, message_card = card }
            end
        end
    end,
    pools = { ["CJModSet"] = true, ["CJModSetFull"] = true, }
}

SMODS.Joker {
    key = "crimsonjoker",
    pos = { x = 0, y = 10 },
    rarity = 1,
    atlas = "main",
    config = { extra = { mult = 2 } },

    cost = 6,
    blueprint_compat = true,
    loc_txt = {
        name = "Crimson Joker",
        text = {
            "{C:mult}+#1#{} Mult when the",
            "Joker to its right triggers"
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.post_trigger and context.other_card and G.GAME.blind and not context.end_of_round and not context.blind_defeated and not context.after and not context.discard and not context.pre_discard and not context.destroying_card and not context.drawing_cards and not context.hand_drawn and not context.first_hand_drawn and not context.selling_card and not context.using_consumeable then
            if G.STATE ~= G.STATES.HAND_PLAYED then return end
            local joker = context.other_card
            local pos = find(G.jokers.cards, card)
            local otherpos = find(G.jokers.cards, joker)
            if otherpos == pos - 1 then
                return { mult = card.ability.extra.mult, message_card = card }
            end
        end
    end,
    pools = { ["CJModSet"] = true, ["CJModSetFull"] = true, }
}

SMODS.Joker {
    key = "nftjoker",
    pos = { x = 1, y = 10 },
    rarity = 1,
    atlas = "main",
    config = { extra = { min = 2, max = 5 } },

    cost = 10,
    blueprint_compat = false,
    loc_txt = {
        name = "NFJ",
        text = {
            "{C:green}#3# in #4#{} chance to",
            "set its {C:attention}sell value{} to {C:red}0${} and {C:red}debuff{}",
            "Otherwise, gain {C:attention}#1#-#2#${} of value",
            "Triggers after defeating a blind"
        }
    },
    loc_vars = function(self, info_queue, card)
        local nom, denom = SMODS.get_probability_vars(card, 1, 8, "NFTRugPull")
        return { vars = { card.ability.extra.min, card.ability.extra.max, nom, denom } }
    end,
    calculate = function(self, card, context)
        if context.blind_defeated then
            if SMODS.pseudorandom_probability(card, "ThisShitGonnaDebuffLmao", 1, 10, "NFTRugPull") then
                card.ability.extra_value = -(card.sell_cost)
                card:set_cost()
                SMODS.debuff_card(card, true, "FailedNFT")
                return {
                    message = "Rug Pulled!",
                    colour = G.C.RED
                }
            else
                card.ability.extra_value = card.ability.extra_value +
                    pseudorandom("CryptoBroGain", card.ability.extra.min, card.ability.extra.max)
                card:set_cost()
                return {
                    message = "Value up!",
                    colour = G.C.MONEY
                }
            end
        end
    end,
    pools = { ["CJModSet"] = true, ["CJModSetFull"] = true, }
}

SMODS.Joker {
    key = "wafflejoker",
    pos = { x = 3, y = 10 },
    rarity = 1,
    atlas = "main",
    config = { extra = { mult = 2, chips = 20, multinc = 1, chipsinc = 10, mostused = "High Card" } },

    cost = 6,
    blueprint_compat = true,
    eternal_compat = false,
    loc_txt = {
        name = "Waffle",
        text = {
            "{C:mult}+#1#{} Mult and {C:chips}+#2#{} Chips",
            "Increases by {C:mult}+#3#{} and {C:chips}+#4#{} for",
            "each {C:planet}Planet{} used",
            "{C:mult}-#3#{} and {C:chips}-#4#{} when",
            "playing most played hand",
            "{C:inactive}(Current most used: #5#){}"
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, card.ability.extra.chips, card.ability.extra.multinc, card.ability.extra.chipsinc, card.ability.extra.mostused } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                chips = card.ability.extra.chips,
                mult = card.ability.extra.mult,
                card.ability.extra.multinc,
                card
                    .ability.extra.chipsinc
            }
        elseif context.using_consumeable and context.consumeable then
            local consum = context.consumeable
            if consum and consum.ability and consum.ability.set then
                if consum.ability.set == "Planet" then
                    card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.multinc
                    card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chipsinc

                    return { message = "Upgraded!", message_colour = G.C.ORANGE }
                end
            end
        elseif context.after then
            if localize(G.GAME.current_round.most_played_poker_hand, "poker_hands") == localize(context.scoring_name, "poker_hands") then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        card.ability.extra.mult = card.ability.extra.mult - card.ability.extra.multinc
                        card.ability.extra.chips = card.ability.extra.chips - card.ability.extra.chipsinc
                        return true
                    end
                }))

                if card.ability.extra.mult <= 0 then
                    SMODS.destroy_cards(card, true, true, true)
                    return { message = "Rotten!", message_colour = G.C.ORANGE }
                end
            end
        elseif context.end_of_round then
            card.ability.extra.mostused = localize(G.GAME.current_round.most_played_poker_hand, "poker_hands")
        end
    end,
    pools = { ["CJModSet"] = true, ["CJModSetFull"] = true, }
}

SMODS.Joker {
    key = "medaljoker",
    pos = { x = 2, y = 10 },
    rarity = 2,
    atlas = "main",
    config = { extra = { xmult = 1.75, odds = 3 } },

    cost = 7,
    blueprint_compat = true,
    loc_txt = {
        name = "Champion Medal",
        text = {
            "{X:mult,C:white}X#1#{} Mult",
            "{C:green}#2# in #3#{} chance to",
            "replace the {C:money}Big Blind{} with",
            "a {C:red}Boss Blind{} after",
            "beating the current {C:red}ante{}"
        }
    },
    loc_vars = function(self, info_queue, card)
        local nom, denom = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, "Champion")
        return { vars = { card.ability.extra.xmult, nom, denom } }
    end,
    calculate = function(self, card, context)
        if context.beat_boss and not context.blueprint_card and context.cardarea == G.jokers then
            local result = SMODS.pseudorandom_probability(card, "GetTheOddsUp", 1, card.ability.extra.odds, "Champion")
            if result then
                G.GAME.round_resets.blind_choices.Big = get_new_boss()
                play_sound('holo1', 1.2 + math.random() * 0.1, 0.4)
                return { message = "Stakes up!", message_colour = G.C.PURPLE }
            else
                G.GAME.round_resets.blind_choices.Big = "bl_big"
            end
        elseif context.joker_main then
            return { xmult = card.ability.extra.xmult }
        end
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.GAME.round_resets.blind_choices.Big = "bl_big"
    end,
    pools = { ["CJModSet"] = true, ["CJModSetFull"] = true, }
}

SMODS.Joker {
    key = "freakyjoker",
    pos = { x = 4, y = 10 },
    rarity = 1,
    atlas = "main",
    config = { extra = { mult = 15 } },

    cost = 5,
    blueprint_compat = true,
    loc_txt = {
        name = "{f:CJMod_papyrus}Freaky Joker",
        text = {
            "{f:CJMod_papyrus}i'm a freak, just hit me up",
            "{f:CJMod_papyrus}if ur up for it...",
            "{C:mult,f:CJMod_papyrus}+#1#{f:CJMod_papyrus} Mult if",
            "{f:CJMod_papyrus}played hand contains a {C:chips,f:CJMod_papyrus}6{f:CJMod_papyrus} and {C:chips,f:CJMod_papyrus}9{}",
            "{f:CJMod_papyrus}or a {C:chips,f:CJMod_papyrus}4{f:CJMod_papyrus} and {C:chips,f:CJMod_papyrus}2{}"
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local cards = G.play.cards
            local has6 = false
            local has9 = false
            local has4 = false
            local has2 = false
            for n, x in pairs(cards) do
                if x and x.get_id and x.config and x.config.center_key ~= "m_stone" then
                    local id = x:get_id()
                    if id == 6 then
                        has6 = true
                        if has9 then
                            break
                        end
                    elseif id == 9 then
                        has9 = true
                        if has6 then
                            break
                        end
                    elseif id == 4 then
                        has4 = true
                        if has2 then
                            break
                        end
                    elseif id == 2 then
                        has2 = true
                        if has4 then
                            break
                        end
                    end
                end
            end

            if has6 and has9 or has4 and has2 then
                return { mult = card.ability.extra.mult }
            end
        end
    end,
    pools = { ["CJModSet"] = true, ["CJModSetFull"] = true, }
}

SMODS.Joker {
    key = "codejoker",
    pos = { x = 0, y = 11 },
    rarity = 1,
    atlas = "main",
    config = { extra = { chips = 15 } },

    cost = 5,
    blueprint_compat = true,
    loc_txt = {
        name = "Rookie Coder",
        text = {
            "{C:chips}+#1#{} Chips X {C:attention}Rounds{}",
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return { chips = card.ability.extra.chips * G.GAME.round }
        end
    end,
    pools = { ["CJModSet"] = true, ["CJModSetFull"] = true, }
}

SMODS.Joker {
    key = "cookjoker",
    pos = { x = 1, y = 11 },
    rarity = "CJMod_stupid",
    atlas = "main",
    config = { extra = { cost = 5 } },

    cost = 10,
    blueprint_compat = false,
    loc_txt = {
        name = "Cook Joker",
        text = {
            "Creates a {C:dark_edition}negative{} random {C:chips}Food Joker{}",
            "after defeating the {C:red}Boss Blind{}",
            "at the cost of {C:money}#1#${}",
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.cost } }
    end,
    calculate = function(self, card, context)
        if context.end_of_round and context.beat_boss and context.cardarea == G.jokers then
            if G.GAME.dollars > card.ability.extra.cost + G.GAME.bankrupt_at and #G.jokers.cards < G.jokers.config.card_limit then
                local newcard = SMODS.add_card({
                    set = "food",
                    area = context.area,
                    key_append = "CJMod_stereotype",
                    edition = "e_negative"
                })
                G.jokers:emplace(newcard)
                newcard.ability.extra_value = -(newcard.sell_cost + 3)
                newcard:set_cost()
                return { dollars = -card.ability.extra.cost }
            end
        end
    end,
    pools = { ["CJModSet"] = true, ["CJModSetFull"] = true, }
}

SMODS.Joker {
    key = "canvas",
    pos = { x = 2, y = 11 },
    rarity = 2,
    atlas = "main",
    cost = 8,
    blueprint_compat = false,
    eternal_compat = false,
    loc_txt = {
        name = "Empty Canvas",
        text = {
            "Only if i had {C:edition,T:j_CJMod_pencil}something{} so",
            "i can draw..."
        }
    },
    add_to_deck = function(self, card, from_debuff)
        for n, x in pairs(G.jokers.cards) do
            if x.config and x.config.center_key == "j_CJMod_pencil" then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('holo1')
                        SMODS.destroy_cards(card, true, true, true)
                        SMODS.destroy_cards(x, true, true, true)
                        SMODS.add_card({ set = "Joker", rarity = "CJMod_stupid" })
                        return true
                    end
                }))
                break
            end
        end
    end,
    pools = { ["CJModSet"] = true, ["CJModSetFull"] = true, }
}

SMODS.Joker {
    key = "pencil",
    pos = { x = 3, y = 11 },
    rarity = 2,
    atlas = "main",
    cost = 8,
    blueprint_compat = false,
    eternal_compat = false,
    loc_txt = {
        name = "Creative Flow",
        text = {
            "I can't do anything with this",
            "if i don't have something {C:edition,T:j_CJMod_canvas}to draw on{}..."
        }
    },
    add_to_deck = function(self, card, from_debuff)
        for n, x in pairs(G.jokers.cards) do
            if x.config and x.config.center_key == "j_CJMod_canvas" then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('holo1')
                        SMODS.destroy_cards(card, true, true, true)
                        SMODS.destroy_cards(x, true, true, true)
                        SMODS.add_card({ set = "Joker", rarity = "CJMod_stupid" })
                        return true
                    end
                }))
                break
            end
        end
    end,
    pools = { ["CJModSet"] = true, ["CJModSetFull"] = true, }
}

SMODS.Joker {
    key = "pencil",
    pos = { x = 3, y = 11 },
    rarity = 2,
    atlas = "main",
    cost = 8,
    blueprint_compat = false,
    eternal_compat = false,
    loc_txt = {
        name = "Creative Flow",
        text = {
            "I can't do anything with this",
            "if i don't have something {C:edition,T:j_CJMod_canvas}to draw on{}..."
        }
    },
    add_to_deck = function(self, card, from_debuff)
        for n, x in pairs(G.jokers.cards) do
            if x.config and x.config.center_key == "j_CJMod_canvas" then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('holo1')
                        SMODS.destroy_cards(card, true, true, true)
                        SMODS.destroy_cards(x, true, true, true)
                        SMODS.add_card({ set = "Joker", rarity = "CJMod_stupid" })
                        return true
                    end
                }))
                break
            end
        end
    end,
    pools = { ["CJModSet"] = true, ["CJModSetFull"] = true, }
}

SMODS.Joker {
    key = "demoncore",
    pos = { x = 4, y = 11 },
    rarity = "CJMod_stupid",
    atlas = "main",
    cost = 14,
    config = { extra = { xmult = 1.5, debuffleft = false, debuffright = false } },
    blueprint_compat = true,
    loc_txt = {
        name = "Demon Core",
        text = {
            "If any Joker next to this Joker triggers",
            "{X:mult,C:white}X#1#{} Mult, and {C:red}debuff{} it after scoring",
            "{C:red}Debuff{} wears off {C:attention}after defeating the blind{}"
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult } }
    end,
    calculate = function(self, card, context)
        if context.post_trigger and context.other_card and context.cardarea == G.jokers then
            local otherjoker = context.other_card
            local pos = find(G.jokers.cards, card)
            local otherpos = find(G.jokers.cards, otherjoker)
            if pos and otherpos then
                if otherpos == pos + 1 then
                    card.ability.extra.debuffright = true
                    return { xmult = card.ability.extra.xmult, message_card = card }
                elseif otherpos == pos - 1 then
                    card.ability.extra.debuffleft = true
                    return { xmult = card.ability.extra.xmult, message_card = card }
                end
            end
        elseif context.after then
            if card.ability.extra.debuffleft then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        local pos = find(G.jokers.cards, card)
                        local otherpos = pos - 1
                        if G.jokers.cards[otherpos] then
                            SMODS.debuff_card(G.jokers.cards[otherpos], true, "DemonCoreDebuff")
                        end
                        return true
                    end
                }))
            end
            if card.ability.extra.debuffright then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        local pos = find(G.jokers.cards, card)
                        local otherpos = pos + 1
                        if G.jokers.cards[otherpos] then
                            SMODS.debuff_card(G.jokers.cards[otherpos], true, "DemonCoreDebuff")
                        end
                        return true
                    end
                }))
            end
            if card.ability.extra.debuffleft or card.ability.extra.debuffright then
                card.ability.extra.debuffleft = false
                card.ability.extra.debuffright = false
                return { message = "Debuffed!", message_colour = G.C.RED }
            end
        elseif context.blind_defeated then
            for n, x in pairs(G.jokers.cards) do
                SMODS.debuff_card(x, false, "DemonCoreDebuff")
            end
            card.ability.extra.debuffleft = false
            card.ability.extra.debuffright = false
            return { message = "Rebuffed!", message_colour = G.C.RED }
        end
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.E_MANAGER:add_event(Event({
            func = function()
                for n, x in pairs(G.jokers.cards) do
                    SMODS.debuff_card(x, false, "DemonCoreDebuff")
                end
                return true
            end
        }))
    end,
    pools = { ["CJModSet"] = true, ["CJModSetFull"] = true, }
}

SMODS.Joker {
    key = "jokerjoker",
    pos = { x = 0, y = 12 },
    rarity = 1,
    atlas = "main",
    config = { extra = { cash = 3 } },

    cost = 5,
    blueprint_compat = true,
    loc_txt = {
        name = "string",
        text = {
            "Get {C:money}$#1#{} at the",
            "end of the round",
            "for each Joker that you have",
            'that has "Joker" in their name'
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.cash } }
    end,
    calc_dollar_bonus = function(self, card)
        local times = 0
        for n, x in pairs(G.jokers.cards) do
            if x.loc_txt and x.loc_txt.name then
                if string.find(string.lower(x.loc_txt.name), "joker") then
                    times = times + 1
                end
            else
                local name = localize({ type = 'name_text', key = x.config.center_key, set = 'Joker' })
                if name and type(name) == "string" and string.find(string.lower(name), "joker") then
                    times = times + 1
                end
            end
        end
        return times * card.ability.extra.cash
    end,
    pools = { ["CJModSet"] = true, ["CJModSetFull"] = true, }
}

SMODS.Joker {
    key = "artjoker",
    pos = { x = 1, y = 12 },
    rarity = 2,
    atlas = "main",
    config = { extra = { } },

    cost = 8,
    blueprint_compat = false,
    loc_txt = {
        name = "Modern Art",
        text = {
            "When a Joker or consumeable is being {C:money}sold{} or",
            "{C:red}destroyed{}, gain half of its {C:money}value{}"
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { } }
    end,
    calculate = function(self, card, context)
        if context.destroy_card and (context.cardarea == G.jokers or context.cardarea == G.consumeables) then
            local crd = context.destroy_card
            if crd and crd.sell_cost and crd.sell_cost > 0 then
                card.ability.extra_value = card.ability.extra_value + math.ceil(crd.sell_cost / 2)
                card:set_cost()
                return {message = "Value up!", message_colour = G.C.MONEY}
            end
        elseif context.selling_card and (context.cardarea == G.jokers or context.cardarea == G.consumeables) then
            local crd = context.card
            if crd and crd.sell_cost and crd.sell_cost > 0 then
                card.ability.extra_value = card.ability.extra_value + math.ceil(crd.sell_cost / 2)
                card:set_cost()
                return {message = "Value up!", message_colour = G.C.MONEY}
            end
        end
    end,
    pools = { ["CJModSet"] = true, ["CJModSetFull"] = true, }
}

SMODS.Joker {
    key = "yogurt",
    pos = { x = 2, y = 12 },
    rarity = 1,
    atlas = "main",
    config = { extra = { cchips = 75, cmult = 7.5, dchips = 15, dmult = 1.5, current = "chips" } },
    cost = 4,
    eternal_compat = false,
    loc_txt = {
        name = "Turkish Yogurt",
        text = {
            "{C:chips}+#1#{} Chips or",
            "{C:mult}+#2#{} Mult",
            "Decays by {C:chips}#3#{} or {C:mult}#4#{}",
            "after every played hand",
            "{C:inactive}(Does not go well with Greek food){}"
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.cchips, card.ability.extra.cmult, card.ability.extra.dchips, card.ability.extra.dmult } }
    end,
    calculate = function(self, card, context)
        if context.before and not context.blueprint_card then
            local choice = pseudorandom(pseudoseed("yogurtchoice"), 1, 2)
            if choice == 1 and card.ability.extra.cchips > 0 then
                card.ability.extra.current = "chips"
            elseif card.ability.extra.cmult > 0 then
                card.ability.extra.current = "mult"
            else
                card.ability.extra.current = "chips"
            end
        elseif context.joker_main then
            for n, x in pairs(G.jokers.cards) do
                if x.config and x.config.center_key == "j_CJMod_yogurtcopy" and not x.debuffed then
                    G.E_MANAGER:add_event(Event({
                        trigger = "immediate",
                        func = function()
                            G.STATE = G.STATES.GAME_OVER
                            G.STATE_COMPLETE = false
                            return true
                        end
                        }))
                    return {message = "Fuck you"}
                end
            end
            if card.ability.extra.current == "chips" then
                return {chips = card.ability.extra.cchips}
            else
                return {mult = card.ability.extra.cmult}
            end
        elseif context.after and not context.blueprint_card then
            if card.ability.extra.current == "chips" then
                card.ability.extra.cchips = card.ability.extra.cchips - card.ability.extra.dchips
            else
                card.ability.extra.cmult = card.ability.extra.cmult - card.ability.extra.dmult
            end
            if card.ability.extra.cmult <= 0 and card.ability.extra.cchips <= 0 then
                SMODS.destroy_cards(card, nil, nil)
                return {message = "Consumed!"}
            else
                if card.ability.extra.current == "chips" then
                    return {message_colour = G.C.CHIPS, message = tostring(-card.ability.extra.dchips)}
                else
                    return {message_colour = G.C.MULT, message = tostring(-card.ability.extra.dmult)}
                end
            end
        end
    end,
    pools = { ["CJModSet"] = true, ["CJModSetFull"] = true, ["food"] = true, }
}

SMODS.Joker {
    key = "yogurtcopy",
    pos = { x = 3, y = 12 },
    rarity = 1,
    atlas = "main",
    config = { extra = { cchips = 1.5, cmult = 1.5, dchips = .1, dmult = .1, current = "chips" } },
    cost = 4,
    eternal_compat = false,
    loc_txt = {
        name = "Greek Yogurt",
        text = {
            "{X:chips,C:white}X#1#{} Chips or",
            "{X:mult,C:white}X#2#{} Mult",
            "Decays by {X:chips,C:white}X#3#{} or {X:mult,C:white}X#4#{}",
            "after every played hand",
            "{C:inactive}(Does not go well with Turkish food){}"
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.cchips, card.ability.extra.cmult, card.ability.extra.dchips, card.ability.extra.dmult } }
    end,
    calculate = function(self, card, context)
        if context.before and not context.blueprint_card then
            local choice = pseudorandom(pseudoseed("yogurtchoice"), 1, 2)
            if choice == 1 and card.ability.extra.cchips > 1 then
                card.ability.extra.current = "chips"
            elseif card.ability.extra.cmult > 1 then
                card.ability.extra.current = "mult"
            else
                card.ability.extra.current = "chips"
            end
        elseif context.joker_main then
            for n, x in pairs(G.jokers.cards) do
                if x.config and x.config.center_key == "j_CJMod_yogurt" and not x.debuffed then
                    G.E_MANAGER:add_event(Event({
                        trigger = "immediate",
                        func = function()
                            G.STATE = G.STATES.GAME_OVER
                            G.STATE_COMPLETE = false
                            return true
                        end
                        }))
                    return {message = "Fuck you"}
                end
            end
            if card.ability.extra.current == "chips" then
                return {xchips = card.ability.extra.cchips}
            else
                return {xmult = card.ability.extra.cmult}
            end
        elseif context.after and not context.blueprint_card then
            if card.ability.extra.current == "chips" then
                card.ability.extra.cchips = card.ability.extra.cchips - card.ability.extra.dchips
            else
                card.ability.extra.cmult = card.ability.extra.cmult - card.ability.extra.dmult
            end
            if card.ability.extra.cmult <= 1 and card.ability.extra.cchips <= 1 then
                SMODS.destroy_cards(card, nil, nil)
                return {message = "Consumed!"}
            else
                if card.ability.extra.current == "chips" then
                    return {message_colour = G.C.CHIPS, message = tostring(-card.ability.extra.dchips)}
                else
                    return {message_colour = G.C.MULT, message = tostring(-card.ability.extra.dmult)}
                end
            end
        end
    end,
    pools = { ["CJModSet"] = true, ["CJModSetFull"] = true, ["food"] = true, }
}

SMODS.Joker {
    key = "heartbreak",
    pos = { x = 4, y = 12 },
    rarity = 2,
    atlas = "main",
    config = { extra = { deckmult = 1, playmult = 5, cards = 3 } },
    cost = 8,
    loc_txt = {
        name = "Heartbreak",
        text = {
            "{C:mult}+#1#{} Mult for each",
            "{C:red}debuffed{} card in your full deck",
            "{C:inactive}(Currently {C:mult}#4#{C:inactive}){}",
            "Get {C:mult}#2#{} Mult for each {C:red}debuffed",
            "card in the scored hand"
        }
    },
    loc_vars = function(self, info_queue, card)
        local cards = 0
        if G.deck and G.deck.cards then
            for n, x in pairs(G.deck.cards) do
                if x.debuffed then
                    cards = cards + 1
                end
            end
        end
        return { vars = { card.ability.extra.deckmult, card.ability.extra.playmult, card.ability.extra.cards, cards } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local times = 0
            for n, x in pairs(G.play.cards) do
                if SMODS.in_scoring(x, context.scoring_hand) and x.debuff then
                    times = times + 1
                end
            end
            if times > 0 then
                return {mult = times * card.ability.extra.playmult}
            end
        elseif context.final_scoring_step then
            local times = 0
            for n, x in pairs(G.deck.cards) do
                if x.debuff then
                    times = times + 1
                end
            end
            if times > 0 then
                return {mult = times * card.ability.extra.deckmult}
            end
        elseif context.setting_blind then
            for i = 1, card.ability.extra.cards do
                local _card = SMODS.create_card { set = "Base", area = G.discard }
                SMODS.debuff_card(_card, true, "permanent")
                G.E_MANAGER:add_event(Event({
                    func = function()
                        G.playing_card = (G.playing_card and G.playing_card + 1) or 1
                        _card.playing_card = G.playing_card
                        G.deck:emplace(_card)
                        table.insert(G.playing_cards, _card)
                        return true
                    end
                }))
                delay(0.2)
                G.E_MANAGER:add_event(Event({
                    func = function()
                        _card:start_materialize()
                        G.GAME.blind:debuff_card(_card)
                        card:juice_up()
                        SMODS.calculate_context({ playing_card_added = true, cards = { _card } })
                        return true
                    end
                }))
                save_run()
                delay(0.2)
            end
            return {message = "Added!"}
        end
    end,
    pools = { ["CJModSet"] = true, ["CJModSetFull"] = true }
}

SMODS.Joker {
    key = "butterfly",
    pos = { x = 0, y = 13 },
    rarity = 2,
    atlas = "main",
    config = { extra = { current = 1, xchips = 0.3 } },
    cost = 7,
    loc_txt = {
        name = "Butterfly Curve",
        text = {
            "Gains {X:chips,C:white}X#2#{} Chips",
            "when a card with a {C:green}Venom Seal{}",
            "gets destroyed, then duplicates it with a",
            "{C:dark_edition}Random{} Seal",
            "{C:inactive}(Currently {X:chips,C:white}X#1#{C:inactive}){}"
        }
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_SEALS["CJMod_venom"]
        return { vars = { card.ability.extra.current, card.ability.extra.xchips } }
    end,
    calculate = function(self, card, context)
        if context.destroying_card then
            local _card = context.destroying_card
            if _card and _card.venombreak then
                G.E_MANAGER:add_event(Event({
                    trigger = "immediate",
                    func = function()
                        local copy = copy_card(_card)
                        copy.venombreak = false
                        copy:set_seal(SMODS.poll_seal({guaranteed = true}), true, true)
                        G.hand:emplace(copy)
                        table.insert(G.playing_cards, copy)
                        return true
                    end
                }))
                card.ability.extra.current = card.ability.extra.current + card.ability.extra.xchips
                return {message = "Upgraded!"}
            end
        elseif context.joker_main then
            return {xchips = card.ability.extra.current}
        end
    end,
    in_pool = function (self, args)
        if G.playing_cards then
            for n,x in pairs(G.playing_cards) do
                if x and x:get_seal(false) == "CJMod_venom" then
                    return true
                end
            end
        end
        return false
    end,
    pools = { ["CJModSet"] = true, ["CJModSetFull"] = true }
}