
SMODS.Consumable {
	set = "Tarot",
	name = "Energy-Tank", 
	key = "etank", 
	pos = { x = 1, y = 0 }, 
    cost=5,
	atlas = "Tarot", 
	loc_txt = { 
      name = "Energy-Tank",
      text = {
        "Gives an extra hand,",
      }
    },
  	in_pool = function(self, args)
    	return not args or args.source ~= "ar1"
  	end,
	can_use = function(self, card) 
		return G.GAME.blind.chips > 0
	end,
    config = { extra = {}}, 
	loc_vars = function(self, info_queue, card) 
	end,
	use = function(self, card, area, copier)
		G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('timpani')
                ease_hands_played(1, true)
                card:juice_up(0.3, 0.5)
                return true
            end
        }))
        delay(0.4)
	end,
}

SMODS.Consumable {
	set = "Tarot",
	name = "67", 
	key = "sixtyseven", 
	pos = { x = 3, y = 0 }, 
    cost=3,
	atlas = "Tarot", 
	loc_txt = { 
      name = "Sixty Seven",
      text = {
        "Draws into hand {C:green}#1# to #2#{},",
        "extra cards from your deck, regardless",
        "of hand size"
      }
    },
  	in_pool = function(self, args)
    	return not args or args.source ~= "ar1"
  	end,
	can_use = function(self, card) 
		return G.GAME.blind.chips > 0 and #G.deck.cards >= 1
	end,
    config = { extra = {min = 6, max = 7}}, 
	loc_vars = function(self, info_queue, card) 
        return { vars = {card.ability.extra.min, card.ability.extra.max} }
	end,
	use = function(self, card, area, copier)
        local amount = pseudorandom("mangoes", card.ability.extra.min, card.ability.extra.max)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                play_sound('card1')
                card:juice_up()
                SMODS.draw_cards(amount)
                return true
            end
        }))
        delay(0.2)
		
	end,
}

SMODS.Consumable {
	set = "Tarot",
	name = "@here", 
	key = "cjmod", 
	pos = { x = 2, y = 0 }, 
    cost=8,
	atlas = "Tarot", 
	loc_txt = { 
      name = "@here",
      text = {
        "Gives a random CJ Mod Joker.",
      }
    },
	can_use = function(self, card)
        return G.jokers and #G.jokers.cards < G.jokers.config.card_limit
    end,
    config = { extra = {}}, 
	loc_vars = function(self, info_queue, card) 
	end,
	use = function(self, card, area, copier)
		G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('timpani')
                SMODS.add_card({ set = 'CJModSetFull' })
                card:juice_up(0.3, 0.5)
                return true
            end
        }))
        delay(0.4)
	end,
}

SMODS.Consumable {
    key = 'plague',
    set = 'Spectral',
    atlas = "Tarot",
    cost = 7,
    pos = { x = 0, y = 1 },
    loc_txt = { 
      name = "Plague",
      text = {
        "Applies a {C:green}Venom Seal{}",
        "to up to {C:attention}#1#{} selected cards",
        "in your hand"
      }
    },
    config = { extra = { seal = 'CJMod_venom' }, max_highlighted = 3 },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_SEALS[card.ability.extra.seal]
        return { vars = { card.ability.max_highlighted } }
    end,
    use = function(self, card, area, copier)
        for n, x in pairs(G.hand.highlighted) do
            G.E_MANAGER:add_event(Event({
            func = function()
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                return true
            end
            }))

            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1,
                func = function()
                    x:set_seal(card.ability.extra.seal, nil, true)
                    return true
                end
            }))
        end
        
        delay(0.5)

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                G.hand:unhighlight_all()
                return true
            end
        }))
    end,
}

SMODS.Consumable {
    key = 'empower',
    set = 'Spectral',
    atlas = "Tarot",
    cost = 6,
    pos = { x = 3, y = 1 },
    loc_txt = { 
      name = "Empower",
      text = {
        "Applies a {C:attention}Power Seal{}",
        "to up to {C:attention}#1#{} selected card",
        "in your hand"
      }
    },
    config = { extra = { seal = 'CJMod_power' }, max_highlighted = 1 },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_SEALS[card.ability.extra.seal]
        return { vars = { card.ability.max_highlighted } }
    end,
    use = function(self, card, area, copier)
        for n, x in pairs(G.hand.highlighted) do
            G.E_MANAGER:add_event(Event({
            func = function()
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                return true
            end
            }))

            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1,
                func = function()
                    x:set_seal(card.ability.extra.seal, nil, true)
                    return true
                end
            }))
        end
        
        delay(0.5)

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                G.hand:unhighlight_all()
                return true
            end
        }))
    end,
}

SMODS.Consumable {
    key = 'enchant',
    set = 'Spectral',
    atlas = "Tarot",
    pos = { x = 1, y = 1 },
    cost = 10,
    loc_txt = {
      name = "Enchant",
      text = {
        "Add a {C:dark_edition}negative{} edition to all cards in hand",
        "{C:red}-2{} hand size"
      }
    },
    config = { extra = { edition = "e_negative" }},
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS[card.ability.extra.edition]
        return { vars = { card.ability.extra.mult, localize{ type = "name_text", set = "Enhanced", key = card.ability.extra.edition} } }
    end,
    use = function(self, card, area, copier)
        local used_tarot = copier or card
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('tarot1')
                used_tarot:juice_up(0.3, 0.5)
                return true
            end
        }))
        for i = 1, #G.hand.cards do
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.2,
                func = function()
                    local _card = G.hand.cards[i]
                    pcall(function()
                        _card:set_edition(card.ability.extra.edition, true)
                        _card:juice_up(0.2, 0.4)
                    end)
                    return true
                end
            }))
        end
        G.hand:change_size(-2)
        if G.GAME.blind.chips > 0 then
            G.hand:draw()
        end
    end,
    can_use = function(self, card)
        return G.hand and #G.hand.cards > 0
    end,
}

SMODS.Consumable {
    key = 'purify',
    set = 'Spectral',
    atlas = "Tarot",
    pos = { x = 2, y = 1 },
    loc_txt = {
      name = "Purify",
      text = {
        "Removes enhancements, editions and seals from",
        "all cards in hand",
        "Gives between {C:attention}3${} & {C:attention}5${}",
        "for each removed one"
      }
    },
    config = {},
    cost = 6,
    use = function(self, card, area, copier)
        local cash = 0
        local used_tarot = copier or card
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('tarot1')
                used_tarot:juice_up(0.3, 0.5)
                return true
            end
        }))
        for i = 1, #G.hand.cards do
            local _card = G.hand.cards[i]
            local percent = 1.15 - (i - 0.999) / (#G.hand.cards - 0.998) * 0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    play_sound('card1', percent)
                    _card:flip()
                    return true
                end
            }))

            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    pcall(function()
                        if _card:get_edition(true) ~= nil then
                            _card:set_edition(nil, true)
                            ease_dollars(pseudorandom("hi", 3, 5), true)
                        end
                        if _card:get_seal(true) ~= nil then
                            _card:set_seal(nil, true)
                            ease_dollars(pseudorandom("hi", 3, 5), true)
                        end
                        if _card.config.center_key ~= "c_base" then
                            _card:set_ability("c_base", nil, true)
                            ease_dollars(pseudorandom("hi", 3, 5), true)
                        end
                    end)
                    return true
                end
            }))
        end

        delay(0.5)

        for i = 1, #G.hand.cards do
            local _card = G.hand.cards[i]
            if _card then
                local percent = 0.85 + (i - 0.999) / (#G.hand.cards - 0.998) * 0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    _card:flip()
                    play_sound('tarot2', percent, 0.6)
                    _card:juice_up(0.3, 0.3)
                    return true
                end
            }))
            end
        end
    end,
    can_use = function(self, card)
        return G.hand and #G.hand.cards > 0
    end,
}

SMODS.Consumable {
	set = "Spectral",
	name = "Reinforce", 
	key = "reinforce", 
	pos = { x = 4, y = 1 }, 
    cost=9,
	atlas = "Tarot", 
	loc_txt = { 
      name = "Reinforce",
      text = {
        "Generates {C:red}#1#{} Pawns,",
        "Halves cash if it's atleast {C:attention}20${},",
        "otherwise set to {C:attention}0${}"
      }
    },
	can_use = function(self, card)
        return G.jokers and #G.jokers.cards < G.jokers.config.card_limit
    end,
    config = { mod_conv = "j_CJMod_pawnjoker", extra = {amount = 2}}, 
	loc_vars = function(self, info_queue, card) 
        info_queue[#info_queue + 1] = G.P_CENTERS[card.ability.mod_conv]
        return {vars = {card.ability.extra.amount}}
	end,
	use = function(self, card, area, copier)
        for i = 1, card.ability.extra.amount do
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    if not G.jokers or #G.jokers.cards >= G.jokers.config.card_limit then return true end
                    play_sound('timpani')
                    SMODS.add_card({key = card.ability.mod_conv, edition = poll_edition(nil, nil, false, false)})
                    card:juice_up(0.3, 0.5)
                    return true
                end
            }))
            delay(0.4)
		end
        delay(0.4)

        if G.GAME.dollars >= 20 then
            ease_dollars(math.ceil(-G.GAME.dollars/2), true)
        else
            ease_dollars(-G.GAME.dollars, true)
        end
	end,
}