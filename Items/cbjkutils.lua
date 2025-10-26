
-- Goes through a table and checks for every value to see if its equal to val. Returns the index of the first iteration found, if it exists.
function find(t, val)
    for n, x in pairs(t) do
        if x == val then
            return n
        end
    end
end

-- Finds all iterations of val and returns the indexes in a table.
function findall(t, val)
    local tab = {}
    for n, x in pairs(t) do
        if x == val then
           table.insert(tab, n) 
        end
    end
    return tab
end

-- Gets the length of the table, regardless of indexes. Alternative for #table.
function tablelength(t)
    local length = 0
    for n, x in pairs(t) do
        length = length + 1
    end
    return length
end

-- Calculates the triangular number of integer.
function triangular(integer)
    local result = (math.ceil(integer) * (math.ceil(integer) + 1)) / 2
    return result
end

function getscore()
    return G.GAME.chips
end

function overscores()
    return G.GAME.blind and G.GAME.blind.chips <= (G.GAME.chips + hand_chips * mult)
end


local original_use_and_sell = G.UIDEF.use_and_sell_buttons

function remove_sell_button(node)
    if not node or not node.nodes then return end
    for i = #node.nodes, 1, -1 do
        local child = node.nodes[i]
        if child.config and child.config.button == "sell_card" then
            table.remove(node.nodes, i)
        else
            remove_sell_button(child)
         end
    end
end

function G.UIDEF.use_and_sell_buttons(card)
    local m = original_use_and_sell(card)
    if (card.config and card.config.center and card.config.center.key == "j_tdec_dried_joker") or card.ability.tdec_Eroding then
        remove_sell_button(m)
    end
    return m
end
