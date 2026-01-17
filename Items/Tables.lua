
function CJMod.recursivepack(t)
    local result = {}
    for n, x in pairs(t) do
        if type(x) == "table" then
            local res = CJMod.recursivepack(x)
            for j, k in pairs(res) do
                table.insert(result, k)
            end
        else
            table.insert(result, x)
        end
    end
    return result
end