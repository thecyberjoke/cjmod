SMODS.Back {
    key = "jacked",
    atlas = "Decks",
    pos = { x = 0, y = 0 },
    unlocked = true,
    discovered = true,
    loc_txt = {
        name = "Jack of Jacks",
        text = {
            "Start with {C:blue}Jacks{}",
            "instead of {C:red}Kings{}",
            "and {C:money}Queens{}"
        },
    },
    apply = function(self, back)
        G.E_MANAGER:add_event(Event({
            func = function()
                for n, x in pairs(G.playing_cards) do
                    if x:is_face() then
                        assert(SMODS.change_base(x, nil, "Jack"))
                    end
                end
                return true
            end
        }))
    end,
}

SMODS.Back {
    key = "discoloured",
    atlas = "Decks",
    pos = { x = 1, y = 0 },
    unlocked = true,
    discovered = true,
    loc_txt = {
        name = "Discoloured Deck",
        text = {
            "Keep only {C:attention}2{} {C:spades}card suits{}",
            "for {C:red}each rank{}"
        },
    },
    apply = function(self, back)
        G.E_MANAGER:add_event(Event({
            func = function()
                local cards = {}
                local todestroy = {}

                for n, x in pairs(G.playing_cards) do
                    if not cards[x:get_id()] then
                        cards[x:get_id()] = { x }
                    else
                        table.insert(cards[x:get_id()], x)
                    end
                end

                for n, x in pairs(cards) do
                    for i = 1, 2 do
                        local destroycard = x[pseudorandom("RandomCardDestroy", 1, #x)]
                        table.remove(x, find(x, destroycard))
                        table.insert(todestroy, destroycard)
                    end
                end

                SMODS.destroy_cards(todestroy, true, true, true)
                return true
            end
        }))
    end,
}

SMODS.Back {
    key = "glowy",
    atlas = "Decks",
    pos = { x = 2, y = 0 },
    unlocked = true,
    discovered = true,
    config = { joker_slot = -1, consumable_slot = -1, vouchers = { 'v_hone', 'v_glow_up', 'v_clearance_sale' } },
    loc_txt = {
        name = "{C:edition}Glowy Deck{}",
        text = {
            "{C:red}-1{} Joker Slot",
            "Start with {C:dark_edition,T:v_hone}Hone{}",
            "{C:edition,T:v_glow_up}Glow Up,",
            "and {C:money,T:v_clearance_sale}Clearance Sale{}"
        },
    },
}

SMODS.Back {
    key = "decker",
    atlas = "Decks",
    pos = { x = 3, y = 0 },
    unlocked = true,
    discovered = true,
    config = { hand_size = 1, consumable_slot = -1, vouchers = { 'v_magic_trick', 'v_illusion', "v_overstock_norm" } },
    loc_txt = {
        name = "Decker's Deck",
        text = {
            "{C:dark_edition}+1{} hand size",
            "{C:red}-1{} consumable slot",
            "Start with {C:money,T:v_magic_trick}Magic Trick{},",
            "{C:money,T:v_illusion}Illusion{} and {C:red,T:v_overstock_norm}Overstock{}"
        },
    },
}

SMODS.Back {
    key = "uno",
    atlas = "Decks",
    pos = { x = 4, y = 0 },
    unlocked = true,
    discovered = true,
    loc_txt = {
        name = "Copyright Infringement",
        text = {
            "Keep only ranks from {C:spades}A{} to {C:diamonds}9{}",
            "Get 2 copies of each card left",
            "{C:red}-1{} hand size, {C:dark_edition}+1{} consumable slot",
            "Start with {C:purple,T:v_crystal_ball}Crystal Ball{}"
        },
    },
    config = { hand_size = -1, consumable_slot = 2, no_faces = true, vouchers = {"v_crystal_ball"} },
    apply = function(self, back)
        G.E_MANAGER:add_event(Event({
            func = function()
                local cards = SMODS.shallow_copy(G.playing_cards)
                local dupecards = {}
                local todestroy = {}

                for n, x in pairs(cards) do
                    if x:get_id() ~= 14 and x:get_id() > 9 then
                        table.insert(todestroy, x)
                        cards[n] = nil
                        SMODS.destroy_cards(x, true, true, true)
                        G.deck.config.card_limit = G.deck.config.card_limit - 1
                    else
                        table.insert(dupecards, x)
                    end
                end

                for n, x in pairs(dupecards) do
                    local card = SMODS.add_card({set = "Base", area = G.deck, rank = x.base.value, suit = x.base.suit })
                end
                
                return true
            end
        }))
    end,
}

SMODS.Back {
    key = "daredevil",
    atlas = "Decks",
    pos = { x = 5, y = 0 },
    unlocked = true,
    discovered = true,
    config = { blind_payout = -1, joker_slot = 1 },
    loc_txt = {
        name = "Daredevil Deck",
        text = {
            "{C:dark_edition}+1{} Joker Slot",
            "Start with a {C:chips,T:tag_juggle}Mini Tag{}",
            "{C:money}#1#${} Blind Payout",
            "{C:red,E:2,s:1.1}All Blinds are Boss Blinds{}"
        },
    },
    loc_vars = function (self, info_queue, card)
        return {vars = {self.config.blind_payout}}
    end,
    calculate = function (self, back, context)
        if context.beat_boss then
            pseudorandom(G.GAME.pseudorandom.seed, 1, 2)
            G.GAME.round_resets.blind_choices.Small = get_new_boss()
            pseudorandom(G.GAME.pseudorandom.seed, 1, 2)
            G.GAME.round_resets.blind_choices.Big = get_new_boss()
            G.GAME.round_resets.boss_rerolled = false
        elseif context.setting_blind then
            local blind = G.GAME.blind
            if blind and G.GAME.round_resets.blind_choices.Big == blind.config.blind.key or blind and G.GAME.round_resets.blind_choices.Small == blind.config.blind.key then
                blind.boss = false
            end
            if blind then
                blind.dollars = math.max(0, blind.dollars - 1)
                G.GAME.current_round.dollars_to_be_earned = string.rep("$", blind.dollars)
            end
        end
    end,
    apply = function(self, back)
        G.GAME.round_resets.blind_choices.Small = get_new_boss()
        G.GAME.round_resets.blind_choices.Big = get_new_boss()
        G.GAME.round_resets.boss_rerolled = false
        
        G.E_MANAGER:add_event(Event({
            func = function()
                add_tag(Tag('tag_CJMod_minibuffoon'))
                play_sound('generic1', 0.9 + math.random() * 0.1, 0.8)
                play_sound('holo1', 1.2 + math.random() * 0.1, 0.4)
                
                return true
            end
        }))
    end,
}

SMODS.Back {
    key = "freeloader",
    atlas = "Decks",
    pos = { x = 0, y = 1 },
    unlocked = true,
    discovered = true,
    config = { blind_payout = -2, vouchers = {"v_seed_money"} },
    loc_txt = {
        name = "Freeloader Deck",
        text = {
            "After beating the {C:red}boss blind{},",
            "get a {C:green,T:tag_d_six}D6{} and {C:mult,T:tag_coupon}Coupon Tag{}",
            "Start with {C:money,T:v_seed_money}Seed Money{}",
            "{C:red}#1#${} Blind Payout",
        },
    },
    loc_vars = function (self, info_queue, card)
        return {vars = {self.config.blind_payout}}
    end,
    calculate = function (self, back, context)
        if context.round_eval and G.GAME.last_blind and G.GAME.last_blind.boss then
            G.E_MANAGER:add_event(Event({
                func = function()
                    add_tag(Tag('tag_coupon'))
                    add_tag(Tag('tag_d_six'))

                    play_sound('generic1', 0.9 + math.random() * 0.1, 0.8)
                    play_sound('holo1', 1.2 + math.random() * 0.1, 0.4)
                
                    return true
                end
            }))
        end
    end,
}

SMODS.Back {
    key = "strategy",
    atlas = "Decks",
    pos = { x = 1, y = 1 },
    unlocked = true,
    discovered = true,
    config = { blind_payout = -40 },
    loc_txt = {
        name = "Strategy Deck",
        text = {
            "At the start of the Run",
            "and at the end of the {C:red}Boss Blind{}",
            "Get a free {C:money,T:tag_investment}Investment Tag{}",
            "Start with a {C:chips,T:j_CJMod_pawnjoker}Pawn{}",
            "{C:red,E:2,s:1.1}No Blind Payout{}"
        },
    },
    loc_vars = function (self, info_queue, card)
        return {vars = {self.config.dollars}}
    end,
    apply = function (self, back)
        G.E_MANAGER:add_event(Event({
            func = function()
                add_tag(Tag('tag_investment'))

                play_sound('generic1', 0.9 + math.random() * 0.1, 0.8)
                play_sound('holo1', 1.2 + math.random() * 0.1, 0.4)

                SMODS.add_card({key = "j_CJMod_pawnjoker", no_edition = true})
                
                return true
            end
        }))
    end,
    calculate = function (self, back, context)
        if context.round_eval and G.GAME.last_blind and G.GAME.last_blind.boss then
            G.E_MANAGER:add_event(Event({
                func = function()
                    add_tag(Tag('tag_investment'))

                    play_sound('generic1', 0.9 + math.random() * 0.1, 0.8)
                    play_sound('holo1', 1.2 + math.random() * 0.1, 0.4)
                
                    return true
                end
            }))
        end
    end,
}