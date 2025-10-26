
SMODS.Tag {
    key = "minibuffoon",
    min_ante = 2,
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
                    local card = SMODS.add_card {
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