
SMODS.Tag {
    key = "minibuffoon",
    min_ante = 99,
    atlas = "Tags",
    pos = { x = 0, y = 0 },
    loc_txt = {
        name = "Mini",
        text = {
            "Gives a random perishable",
            "{C:chips}Common{} Joker",
            "{C:inactive}(Will never appear normally!){}"
        }
    },
    apply = function(self, tag, context)
        if context.type == 'immediate' then
            local lock = tag.ID
            G.CONTROLLER.locks[lock] = true
            tag:yep('+', G.C.PURPLE, function()
                if G.jokers and #G.jokers.cards < G.jokers.config.card_limit then
                    local tempkey = "j_riff_raff"
                    local removelater = false
                    if not G.GAME.banned_keys[tempkey] then
                        removelater = true
                        G.GAME.banned_keys[tempkey] = true
                    end
                    local card = SMODS.add_card{
                        set = "Joker",
                        rarity = "Common",
                        key_append = "CJMod_minibuffoon",
                        no_edition = true,
                    }
                    card:add_sticker("perishable", true)
                    card.ability.perish_tally = 3
                    card.ability.perishable_rounds = 3
                    if removelater then
                        G.GAME.banned_keys[tempkey] = false
                    end
                end
                G.CONTROLLER.locks[lock] = nil
                return true
            end)
            tag.triggered = true
            return true
        end
    end,
    in_pool = function (self, args)
        return false
    end
}

SMODS.Tag {
    key = "work",
    min_ante = 2,
    atlas = "Tags",
    pos = { x = 0, y = 1 },
    config = { money = 5, max = 30 },
    loc_vars = function(self, info_queue, tag)
        return { vars = { tag.config.money, tag.config.max } }
    end,
    loc_txt = {
        name = "Work",
        text = {
            "Get {C:money}$#1#{} for",
            "every Joker you have",
            "{C:inactive}(Max {C:money}$#2#{C:inactive}){}"
        }
    },
    apply = function(self, tag, context)
        if context.type == 'immediate' then
            local lock = tag.ID
            G.CONTROLLER.locks[lock] = true
            tag:yep('+', G.C.MONEY, function()
                G.CONTROLLER.locks[lock] = nil
                return true
            end)
            local total = math.min(math.max(0, #G.jokers.cards or 0 * tag.config.money), tag.config.max)
            ease_dollars(total)
            tag.triggered = true
            return true
        end
    end
}

SMODS.Tag {
    key = "stereotype",
    min_ante = 1,
    atlas = "Tags",
    pos = { x = 0, y = 2 },
    config = { pool = "food" },
    loc_vars = function(self, info_queue, tag)
        return { vars = { } }
    end,
    loc_txt = {
        name = "Stereotype",
        text = {
            "Next shop has a ",
            "free Food Joker",
        }
    },
    apply = function(self, tag, context)
        if context.type == 'store_joker_create' then
            local card = SMODS.create_card {
                set = "food",
                area = context.area,
                key_append = "CJMod_stereotype"
            }
            create_shop_card_ui(card, 'Joker', context.area)
            card.states.visible = false
            tag:yep('+', G.C.RED, function()
                card:start_materialize()
                card.ability.couponed = true
                card:set_cost()
                return true
            end)
            tag.triggered = true
            return card
        end
    end
}

SMODS.Tag {
    key = "missing",
    min_ante = 3,
    atlas = "Tags",
    pos = { x = 0, y = 3 },
    config = {},
    loc_vars = function(self, info_queue, tag)
        return { vars = { } }
    end,
    loc_txt = {
        name = "ERROR",
        text = {
            "{C:stupid,E:1,s:2}??????{}"
        }
    },
    apply = function(self, tag, context)
        if context.type == 'immediate' then
            tag:yep("!z(£)?}/$)à", G.C.BLACK, function()
                local randomfunctions = {
                    [1] = function ()
                        ease_ante(-1)
                    end,
                    [2] = function ()
                        ease_ante(4)
                    end,
                    [3] = function ()
                        G.GAME.round_resets.discards = G.GAME.round_resets.discards + 1
                        ease_discard(1)
                    end,
                    [4] = function ()
                        G.GAME.round_resets.discards = math.max(G.GAME.round_resets.discards - 2, 0)
                        ease_discard(-2)
                    end,
                    [5] = function ()
                        G.GAME.round_resets.hands = G.GAME.round_resets.hands + 1
                        G.GAME.current_round.hands_left = G.GAME.current_round.hands_left + 1
                    end,
                    [6] = function ()
                        G.GAME.round_resets.hands = math.max(1, G.GAME.round_resets.hands - 2)
                        G.GAME.current_round.hands_left = math.max(1, G.GAME.current_round.hands_left + 1)
                    end,
                    [7] = function ()
                        ease_dollars(14)
                    end,
                    [8] = function ()
                        ease_dollars(-23)
                    end,
                    [9] = function ()
                        G.FUNCS.overlay_menu {
                        definition = create_UIBox_custom_video1("mustard", "thanks i hate it"),
                        config = { no_esc = true }
                        }
                    end,
                    [10] = function ()
                        SMODS.add_card({key = "j_misprint"})
                    end,
                    [11] = function ()
                        local amount = pseudorandom(pseudoseed("shit"),1,4)
                        for i = 1, amount do
                            local _card = SMODS.create_card{ set = "Base", area = G.discard, enhancement = SMODS.poll_enhancement(), edition = poll_edition(nil, nil, false, true), seal = SMODS.poll_seal() }
                            G.E_MANAGER:add_event(Event({
                                func = function()
                                    G.playing_card = (G.playing_card and G.playing_card + 1) or 1
                                    _card.playing_card = G.playing_card
                                    table.insert(G.playing_cards, _card)
                                    SMODS.debuff_card(_card, true, "fuck you")
                                    return true
                                end
                            }))

                            G.E_MANAGER:add_event(Event({
                                func = function()
                                    SMODS.calculate_context({ playing_card_added = true, cards = { _card } })
                                    return true
                                end
                            }))
                        end
                    end,
                    [12] = function ()
                        play_sound("CJMod_glitch".. math.random(1,4))
                    end,
                    [13] = function ()
                        love.timer.sleep(math.random(150,1700)*0.01)
                    end,
                }
                local odd1 = pseudorandom(pseudoseed("FUCK"), 1, 13)
                local odd2 = nil
                while not odd2 or odd2 == odd1 do
                    odd2 = pseudorandom(pseudoseed("FUCK"), 1, 13)
                end
                local odd3 = nil
                while not odd3 or odd3 == odd2 or odd3 == odd1 do
                    odd3 = pseudorandom(pseudoseed("FUCK"), 1, 13)
                end
                local odd4 = nil
                while not odd4 or odd4 == odd3 or odd4 == odd2 or odd4 == odd1 do
                    odd4 = pseudorandom(pseudoseed("FUCK"), 1, 13)
                end
                randomfunctions[odd1]()
                love.timer.sleep(math.random(5,30)*0.1)
                randomfunctions[odd2]()
                love.timer.sleep(math.random(5,30)*0.1)
                randomfunctions[odd3]()
                love.timer.sleep(math.random(5,30)*0.1)
                randomfunctions[odd4]()
                save_run()
                return true
            end)
            tag.triggered = true
            return true
        end
    end
}

SMODS.Tag {
    key = "art",
    min_ante = 1,
    atlas = "Tags",
    pos = { x = 0, y = 3 },
    config = { mod_conv1 = "j_CJMod_pencil", mod_conv2 = "j_CJMod_canvas" },
    loc_vars = function(self, info_queue, tag)
        info_queue[#info_queue + 1] = G.P_CENTERS[tag.config.mod_conv1]
        info_queue[#info_queue + 1] = G.P_CENTERS[tag.config.mod_conv2]
        return { vars = { } }
    end,
    loc_txt = {
        name = "Artistic Flow",
        text = {
            "Either get a",
            "{C:dark_edition}Canvas{} or {C:dark_edition}Pencil{}",
            "{C:inactive}(Won't get consumed until you{}",
            "{C:inactive}have enough space){}"
        }
    },
    apply = function(self, tag, context)
        if context.type == "immediate" then
            if G.jokers.config.card_limit > #G.jokers.cards then
                local rndkey = pseudorandom_element({"j_CJMod_pencil", "j_CJMod_canvas"}, pseudoseed("SHITANDSTUFF"))
                local card = SMODS.create_card{
                    key = rndkey,
                }
                G.jokers:emplace(card)
                card.states.visible = false
                tag:yep('+', G.C.GREEN, function()
                    card:start_materialize()
                    return true
                end)
                return true
            end
        end
    end
}