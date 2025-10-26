local gamehook = Game.update

function Game:update(dt)
    local ret = gamehook(self, dt)

    if G.GAME and G.GAME.blind and G.GAME.blind.config.blind.key == 'bl_CJMod_quick' and not G.GAME.blind.disabled and G.STATE ~= G.STATES.MENU and G.STATE ~= G.STATES.GAME_OVER and G.STATE ~= G.STATES.NEW_ROUND then
        local subval = (G.GAME.blind.chips * 0.005) * (dt * 2)
        if G.GAME.chips - subval > 0 then
            subval = subval / 2
        end
        G.GAME.chips = G.GAME.chips - subval
    end

    local foundhand = nil
    local least = math.huge
    for n, x in pairs(G.GAME.hands) do
        if x.played < least and SMODS.is_poker_hand_visible(n) then
            foundhand = n
            least = x.played
        end
    end

    G.GAME.current_round.least_played_poker_hand = foundhand

    return ret
end

local contexthook = SMODS.calculate_context

function SMODS.calculate_context(context, return_table)
    local ret = contexthook(context, return_table)

    if context.setting_blind then
        local blind = G.GAME.blind
        if blind and G.GAME.round_resets.blind_choices.Big == blind.config.blind.key or blind and G.GAME.round_resets.blind_choices.Small == blind.config.blind.key then
            blind.boss = false
        end
        if blind then
            local deck = G.GAME.selected_back
            local extra = 0
            if deck.effect.config and deck.effect.config.blind_payout then
                extra = deck.effect.config.blind_payout
            end
            blind.dollars = math.max(0, blind.dollars + extra)
            if blind.dollars > 0 then
                G.GAME.current_round.dollars_to_be_earned = string.rep("$", blind.dollars)
            else
                G.GAME.current_round.dollars_to_be_earned = "You get NOTHING!"
            end
            
        end
    end
    return ret
end

-- rewritten to prevent selling a joker if it would bankrupt you
function SMODS.is_eternal(card, trigger)
    local calc_return = {}
    local ovr_compat = false
    local ret = false
    if not trigger then trigger = {} end
    SMODS.calculate_context({check_eternal = true, other_card = card, trigger = trigger, no_blueprint = true,}, calc_return)
    for _,eff in pairs(calc_return) do
        for _,tab in pairs(eff) do
            if tab.no_destroy then
                ret = true
                if type(tab.no_destroy) == 'table' then
                    if tab.no_destroy.override_compat then ovr_compat = true end
                end
            end
        end
    end
    if card.ability.eternal then ret = true end
    if not card.config.center.eternal_compat and not ovr_compat then ret = false end
    if card.sell_cost and -card.sell_cost + G.GAME.bankrupt_at > G.GAME.dollars then
        ret = true
        if card.sell_cost and card.sell_cost > 0 then
            ret = false
        end
    end
    return ret
end

-- rewritten to work better
function get_new_boss()
    G.GAME.perscribed_bosses = G.GAME.perscribed_bosses or {
    }
    if G.GAME.perscribed_bosses and G.GAME.perscribed_bosses[G.GAME.round_resets.ante] then 
        local ret_boss = G.GAME.perscribed_bosses[G.GAME.round_resets.ante] 
        G.GAME.perscribed_bosses[G.GAME.round_resets.ante] = nil
        G.GAME.bosses_used[ret_boss] = G.GAME.bosses_used[ret_boss] + 1
        return ret_boss
    end
    if G.FORCE_BOSS then return G.FORCE_BOSS end
    
    local eligible_bosses = {}
    for k, v in pairs(G.P_BLINDS) do
        if not v.boss then

        elseif v.in_pool and type(v.in_pool) == 'function' then
            local res, options = v:in_pool()
            if
                (
                    ((G.GAME.round_resets.ante)%G.GAME.win_ante == 0 and G.GAME.round_resets.ante >= 2) ==
                    (v.boss.showdown or false)
                ) or
                (options or {}).ignore_showdown_check
            then
                eligible_bosses[k] = res and true or nil
            end
        elseif not v.boss.showdown and (v.boss.min <= math.max(1, G.GAME.round_resets.ante) and ((math.max(1, G.GAME.round_resets.ante))%G.GAME.win_ante ~= 0 or G.GAME.round_resets.ante < 2)) then
            eligible_bosses[k] = true
        elseif v.boss.showdown and (G.GAME.round_resets.ante)%G.GAME.win_ante == 0 and G.GAME.round_resets.ante >= 2 then
            eligible_bosses[k] = true
        end
    end
    for k, v in pairs(G.GAME.banned_keys) do
        if eligible_bosses[k] then eligible_bosses[k] = nil end
    end

    local min_use = 100
    for k, v in pairs(G.GAME.bosses_used) do
        if eligible_bosses[k] then
            eligible_bosses[k] = v
            if eligible_bosses[k] <= min_use then 
                min_use = eligible_bosses[k]
            end
        end
    end
    for k, v in pairs(eligible_bosses) do
        if eligible_bosses[k] then
            if eligible_bosses[k] > min_use then 
                eligible_bosses[k] = nil
            end
        end
    end
    local _, boss = pseudorandom_element(eligible_bosses, G.GAME.pseudorandom.seed)
    G.GAME.bosses_used[boss] = G.GAME.bosses_used[boss] + 1
    
    return boss
end

G.FUNCS.discard_cards_from_highlighted = function(e, hook)
    stop_use()
    G.CONTROLLER.interrupt.focus = true
    G.CONTROLLER:save_cardarea_focus('hand')

    for k, v in ipairs(G.playing_cards) do
        v.ability.forced_selection = nil
    end

    if G.CONTROLLER.focused.target and G.CONTROLLER.focused.target.area == G.hand then G.card_area_focus_reset = {area = G.hand, rank = G.CONTROLLER.focused.target.rank} end
    local highlighted_count = math.min(#G.hand.highlighted, G.discard.config.card_limit - #G.play.cards)
    if highlighted_count > 0 then 
        update_hand_text({immediate = true, nopulse = true, delay = 0}, {mult = 0, chips = 0, level = '', handname = ''})
        table.sort(G.hand.highlighted, function(a,b) return a.T.x < b.T.x end)
        inc_career_stat('c_cards_discarded', highlighted_count)
        SMODS.calculate_context({pre_discard = true, full_hand = G.hand.highlighted, hook = hook})
        
        -- TARGET: pre_discard
        local cards = {}
        local destroyed_cards = {}
        for i=1, highlighted_count do
            G.hand.highlighted[i]:calculate_seal({discard = true})
            local removed = false
            local effects = {}
            SMODS.calculate_context({discard = true, other_card =  G.hand.highlighted[i], full_hand = G.hand.highlighted, ignore_other_debuff = true}, effects)
            SMODS.trigger_effects(effects)
            for _, eval in pairs(effects) do
                if type(eval) == 'table' then
                    for key, eval2 in pairs(eval) do
                        if key == 'remove' or (type(eval2) == 'table' and eval2.remove) then removed = true end
                    end
                end
            end
            table.insert(cards, G.hand.highlighted[i])
            if removed then
                destroyed_cards[#destroyed_cards + 1] = G.hand.highlighted[i]
                if SMODS.shatters(G.hand.highlighted[i]) then
                    G.hand.highlighted[i]:shatter()
                else
                    G.hand.highlighted[i]:start_dissolve()
                end
            else 
                G.hand.highlighted[i].ability.discarded = true
                if G.GAME.used_vouchers["v_CJMod_infinitus"] then
                    draw_card(G.hand, G.deck, i*100/highlighted_count, 'down', false, G.hand.highlighted[i])
                else
                    draw_card(G.hand, G.discard, i*100/highlighted_count, 'down', false, G.hand.highlighted[i])
                end
            end
        end

        -- context.remove_playing_cards from discard
        if destroyed_cards[1] then
            SMODS.calculate_context({remove_playing_cards = true, removed = destroyed_cards})
        end
        
        -- TARGET: effects after cards destroyed in discard

        G.GAME.round_scores.cards_discarded.amt = G.GAME.round_scores.cards_discarded.amt + #cards
        check_for_unlock({type = 'discard_custom', cards = cards})
        if not hook then
            if G.GAME.modifiers.discard_cost then
                ease_dollars(-G.GAME.modifiers.discard_cost)
            end
            ease_discard(-1)
            G.GAME.current_round.discards_used = G.GAME.current_round.discards_used + 1
            G.STATE = G.STATES.DRAW_TO_HAND
            G.E_MANAGER:add_event(Event({
                trigger = 'immediate',
                func = function()
                    G.STATE_COMPLETE = false
                    return true
                end
            }))
        end
    end
end

function end_round()
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.2,
        func = function()
            G.GAME.blind.in_blind = false
            local game_over = true
            local game_won = false
            G.RESET_BLIND_STATES = true
            G.RESET_JIGGLES = true
            if G.GAME.chips - G.GAME.blind.chips >= 0 then
                game_over = false
            end
            -- context.end_of_round calculations
            SMODS.saved = false
            G.GAME.saved_text = nil
            SMODS.calculate_context({ end_of_round = true, game_over = game_over, beat_boss = G.GAME.blind.boss })
            if SMODS.saved then game_over = false end
            -- TARGET: main end_of_round evaluation
            if G.GAME.round_resets.ante == G.GAME.win_ante and G.GAME.blind.boss then
                game_won = true
                G.GAME.won = true
            end
            if game_over then
                G.STATE = G.STATES.GAME_OVER
                if not G.GAME.won and not G.GAME.seeded and not G.GAME.challenge then
                    G.PROFILES[G.SETTINGS.profile].high_scores.current_streak.amt = 0
                end
                G:save_settings()
                G.FILE_HANDLER.force = true
                G.STATE_COMPLETE = false
            else
                G.GAME.unused_discards = (G.GAME.unused_discards or 0) + G.GAME.current_round.discards_left
                if G.GAME.blind and G.GAME.blind.config.blind then
                    discover_card(G.GAME.blind.config.blind)
                end

                if G.GAME.blind.boss then
                    local _handname, _played, _order = 'High Card', -1, 100
                    for k, v in pairs(G.GAME.hands) do
                        if v.played > _played or (v.played == _played and _order > v.order) then
                            _played = v.played
                            _handname = k
                        end
                    end
                    G.GAME.current_round.most_played_poker_hand = _handname
                end

                if G.GAME.blind.boss and not G.GAME.seeded and not G.GAME.challenge then
                    G.GAME.current_boss_streak = G.GAME.current_boss_streak + 1
                    check_and_set_high_score('boss_streak', G.GAME.current_boss_streak)
                end

                if G.GAME.current_round.hands_played == 1 then
                    inc_career_stat('c_single_hand_round_streak', 1)
                else
                    if not G.GAME.seeded and not G.GAME.challenge then
                        G.PROFILES[G.SETTINGS.profile].career_stats.c_single_hand_round_streak = 0
                        G:save_settings()
                    end
                end

                check_for_unlock({ type = 'round_win' })
                set_joker_usage()
                if game_won and not G.GAME.win_notified then
                    G.GAME.win_notified = true
                    G.E_MANAGER:add_event(Event({
                        trigger = 'immediate',
                        blocking = false,
                        blockable = false,
                        func = (function()
                            if G.STATE == G.STATES.ROUND_EVAL then
                                win_game()
                                G.GAME.won = true
                                return true
                            end
                        end)
                    }))
                end
                for _, v in ipairs(SMODS.get_card_areas('playing_cards', 'end_of_round')) do
                    SMODS.calculate_end_of_round_effects({
                        cardarea = v,
                        end_of_round = true,
                        beat_boss = G.GAME.blind
                            .boss
                    })
                end

                G.FUNCS.draw_from_hand_to_discard()
                if G.GAME.blind.boss then
                    G.GAME.voucher_restock = nil
                    if G.GAME.modifiers.set_eternal_ante and (G.GAME.round_resets.ante == G.GAME.modifiers.set_eternal_ante) then
                        for k, v in ipairs(G.jokers.cards) do
                            v:set_eternal(true)
                        end
                    end
                    if G.GAME.modifiers.set_joker_slots_ante and (G.GAME.round_resets.ante == G.GAME.modifiers.set_joker_slots_ante) then
                        G.jokers.config.card_limit = 0
                    end
                    delay(0.4); ease_ante(1, true); delay(0.4); check_for_unlock({
                        type = 'ante_up',
                        ante = G.GAME
                            .round_resets.ante + 1
                    })
                end
                G.FUNCS.draw_from_discard_to_deck()
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.3,
                    func = function()
                        G.STATE = G.STATES.ROUND_EVAL
                        G.STATE_COMPLETE = false

                        if G.GAME.round_resets.blind.key == G.GAME.round_resets.blind_choices.Small then
                            G.GAME.round_resets.blind_states.Small = 'Defeated'
                        elseif G.GAME.round_resets.blind.key == G.GAME.round_resets.blind_choices.Big then
                            G.GAME.round_resets.blind_states.Big = 'Defeated'
                        else
                            G.GAME.current_round.voucher = SMODS.get_next_vouchers()
                            G.GAME.round_resets.blind_states.Boss = 'Defeated'
                            for k, v in ipairs(G.playing_cards) do
                                v.ability.played_this_ante = nil
                            end
                        end

                        if G.GAME.round_resets.temp_handsize then
                            G.hand:change_size(-G.GAME.round_resets.temp_handsize); G.GAME.round_resets.temp_handsize = nil
                        end
                        if G.GAME.round_resets.temp_reroll_cost then
                            G.GAME.round_resets.temp_reroll_cost = nil; calculate_reroll_cost(true)
                        end

                        reset_idol_card()
                        reset_mail_rank()
                        reset_ancient_card()
                        reset_castle_card()
                        for _, mod in ipairs(SMODS.mod_list) do
                            if mod.reset_game_globals and type(mod.reset_game_globals) == 'function' then
                                mod.reset_game_globals(false)
                            end
                        end
                        for k, v in ipairs(G.playing_cards) do
                            v.ability.discarded = nil
                            v.ability.forced_selection = nil
                        end
                        return true
                    end
                }))
            end
            return true
        end
    }))
end

function Blind:get_type()
    local typology = "Big"
    if self.name == "Small Blind" then
        typology = 'Small'
    elseif self.name == "Big Blind" then
        typology = 'Big'
    elseif self.boss then
        typology = 'Boss'
    end
    return typology
end

local uiboxhook = create_UIBox_blind_choice

function create_UIBox_blind_choice(type, run_info)
    local t = uiboxhook(type, run_info)
    local blind_choice = {
        config = G.P_BLINDS[G.GAME.round_resets.blind_choices[type]],
    }

    local deck = G.GAME.selected_back
    local extra = 0
    if deck.effect.config and deck.effect.config.blind_payout then
        extra = deck.effect.config.blind_payout
    end

    if t.nodes[1].nodes[3].nodes[1].nodes[2].nodes[3] and blind_choice and blind_choice.config and blind_choice.config.dollars then
        local cash = math.max(0, blind_choice.config.dollars + extra)
        if cash > 0 then
            t.nodes[1].nodes[3].nodes[1].nodes[2].nodes[3].nodes[2].config.text = string.rep(localize("$"), cash) .. '+'
        else
            t.nodes[1].nodes[3].nodes[1].nodes[2].nodes[3].nodes[2].config.text = "n/a"
        end
        
    end
    return t
end

G.FUNCS.draw_from_play_to_discard = function(e)
    local play_count = #G.play.cards
    local it = 1
    for k, v in ipairs(G.play.cards) do
        if (not v.shattered) and (not v.destroyed) then
            if G.GAME.used_vouchers["v_CJMod_cardjutsu"] then
                draw_card(G.play,G.deck, it*100/play_count,'down', false, v)
            else
                draw_card(G.play,G.discard, it*100/play_count,'down', false, v)
            end
            it = it + 1
        end
    end
end