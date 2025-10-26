
if not CJMod then
    CJMod = {}
end

CJMod = {
    show_options_button = true,
    
}

CJMod = SMODS.current_mod
CJMod_config = CJMod.config
CJMod.enabled = copy_table(CJMod_config)
CJMod.optional_features = function()
    return {
        retrigger_joker = true,
        post_trigger = true,
    }
end

SMODS.Atlas{
    object_type = "Atlas",
    key = "main",
    path = "Jokers.png",
    px = 71,
    py = 95,
}
SMODS.Atlas{
    key = "Tarot",
    path = "Tarots.png",
    px = 71,
    py = 95,
}
SMODS.Atlas{
    key = "Booster",
    path = "Boosters.png",
    px = 71,
    py = 95,
}
SMODS.Atlas{
    key = "Decks",
    path = "Decks.png",
    px = 71,
    py = 95,
}
SMODS.Atlas{
    key = "Blinds",
    path = "Blinds.png",
    px = 34,
    py = 34,
    frames = 1,
    atlas_table = 'ANIMATION_ATLAS'
}

SMODS.Atlas({
	key = "modicon",
	path = "icon.png",
	px = 32,
	py = 32,
})

SMODS.Atlas({
	key = "Tags",
	path = "Tags.png",
	px = 32,
	py = 32,
})

SMODS.Sound({
    key = "hiss",
    path = "hiss.ogg",
    pitch = 1.1
})

local mod_path = "" .. SMODS.current_mod.path
CJMod.path = mod_path

local files = NFS.getDirectoryItems(mod_path .. "items")
for _, file in ipairs(files) do
	local f, err = SMODS.load_file("Items/" .. file)
	if err then
		error(err) 
	end
    if f then
        f()
    end
end

SMODS.ObjectType({
    key = "CJModSet",
    default = "j_card_sharp",
    cards = {},
    inject = function(self)
        SMODS.ObjectType.inject(self)
    end,
})

SMODS.ObjectType({
    key = "CJModSetFull",
    default = "j_gros_michel",
    cards = {},
    inject = function(self)
        SMODS.ObjectType.inject(self)
    end,
})

SMODS.ObjectType({
    key = "CJModChess",
    default = "j_CJMod_pawnjoker",
    cards = {},
    inject = function(self)
        SMODS.ObjectType.inject(self)
    end,
})