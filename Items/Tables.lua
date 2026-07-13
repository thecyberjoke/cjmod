
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

---Creates a shallow copy of the table `t`. If the given `deep` argument is a truth-ly value, creates a deep copy of `t` instead.
---@param t table
---@param deep boolean?
---@return table
function table.copy(t, deep)
    assert(type(t) == "table", "Attempted to pass a non-table data type to a table.copy function (".. type(t).. ")")
    local new = {}
    for n, x in ipairs(t) do
        if deep and type(x) == "table" then
            new[n] = table.copy(x, deep)
        else
            new[n] = x
        end
    end
    for n, x in pairs(t) do
        if deep and type(n) == "table" then
            n = table.copy(n, deep)
        end
        if deep and type(x) == "table" then
            new[n] = table.copy(x, deep)
        else
            new[n] = x
        end
    end

    return new
end

---Returns the index of value `v` in table `t`, if it exists.
---@param t table
---@param v any
---@return any?
function table.find(t, v)
    for n, x in pairs(t) do
        if x == v then
            return n
        end
    end
end