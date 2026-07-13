return {
    IndexTasks = {
        {
            variables = { cards = 3, no_play = "Hearts" },
            text = "Play exactly 3 cards, without any Hearts",

            ---@param vars table
            ---@param card table|Card
            ---@param context table|CalcContext
            calculate = function(vars, card, context)
                if context.before then
                    local count = 0
                    for n, x in ipairs(G.play.cards) do
                        count = count + 1
                        if count > vars.cards then
                            return false
                        end
                        if x.base.suit == vars.no_play then
                            return false
                        end
                    end
                    if count == vars.cards then
                        return true
                    end
                    return false
                end
            end
        },
        {
            variables = { cards = 5, no_play = "Diamonds" },
            text = "Play exactly 5 cards, without any Diamonds",

            ---@param vars table
            ---@param card table|Card
            ---@param context table|CalcContext
            calculate = function(vars, card, context)
                if context.before then
                    local count = 0
                    for n, x in ipairs(G.play.cards) do
                        count = count + 1
                        if count > vars.cards then
                            return false
                        end
                        if x.base.suit == vars.no_play then
                            return false
                        end
                    end
                    if count == vars.cards then
                        return true
                    end
                    return false
                end
            end
        },
        {
            variables = { cards = 2, no_play = "Clubs" },
            text = "Play exactly 2 cards, without any Clubs",

            ---@param vars table
            ---@param card table|Card
            ---@param context table|CalcContext
            calculate = function(vars, card, context)
                if context.before then
                    local count = 0
                    for n, x in ipairs(G.play.cards) do
                        count = count + 1
                        if count > vars.cards then
                            return false
                        end
                        if x.base.suit == vars.no_play then
                            return false
                        end
                    end
                    if count == vars.cards then
                        return true
                    end
                    return false
                end
            end
        },
        {
            variables = { cards = 4, no_play = "Spades" },
            text = "Play exactly 4 cards, without any Spades",

            ---@param vars table
            ---@param card table|Card
            ---@param context table|CalcContext
            calculate = function(vars, card, context)
                if context.before then
                    local count = 0
                    for n, x in ipairs(G.play.cards) do
                        count = count + 1
                        if count > vars.cards then
                            return false
                        end
                        if x.base.suit == vars.no_play then
                            return false
                        end
                    end
                    if count == vars.cards then
                        return true
                    end
                    return false
                end
            end
        },
        {
            variables = { cards = 1 },
            text = "Play exactly 1 card",

            ---@param vars table
            ---@param card table|Card
            ---@param context table|CalcContext
            calculate = function(vars, card, context)
                if context.before then
                    local count = 0
                    for n, x in ipairs(G.play.cards) do
                        count = count + 1
                        if count > vars.cards then
                            return false
                        end
                    end
                    if count == vars.cards then
                        return true
                    end
                    return false
                end
            end
        },
        {
            variables = { cards = 3 },
            text = "Discard exactly 3 face cards",

            ---@param vars table
            ---@param card table|Card
            ---@param context table|CalcContext
            calculate = function(vars, card, context)
                if context.discarding and context.discarded then
                    local faces = 0
                    for n, x in ipairs(context.discarded) do
                        if x:is_face(false) then
                            faces = faces + 1
                            if faces > vars.cards then
                                return false
                            end
                        end
                    end

                    if faces == vars.cards then
                        return true
                    end

                    return false
                end
            end
        },
    }
}