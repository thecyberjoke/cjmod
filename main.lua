-- this file is an example of what is generally in a main lua file 

-- the SMODS functions such as SMODS.Joker are also case sensitive, so if you use SMODS.joker instead of SMODS.Joker the joker you coded will not appear in the game, the same goes for any other SMODS method

if not CJMod then -- this is used to make sure that the mod is not loaded multiple times, and it is used to make sure that the mod is not loaded in a different order than it should be
    CJMod = {}
end

CJMod = {
    show_options_button = true,
    
}

CJMod = SMODS.current_mod
CJMod_config = CJMod.config -- this is the config file that is used to store the mods settings, and it is used to make sure that the mods config is loaded correctly
CJMod.enabled = copy_table(CJMod_config) -- this is the current state of the mods settings, and it is used to make sure that the mods config settings are saved
CJMod.optional_features = function()
    return {
        retrigger_joker = true,
        post_trigger = true,
    }
end

-- to make your config actually register and work you will need to add the lines 3, 4, and 5 to your mod, and you can replace the ExampleMod with your mods name

-- When making a Sprite For Balatro you need to have a 1x and a 2x file, because the 1x is used for no pixel art smothing, and 2x is used for pixel art smothing
SMODS.Atlas{
    object_type = "Atlas",
    key = "main", -- this is what you put in your atlas in your jokr, consumable, or any other modded item, an example of this can be found in Items/Jokers.lua on line 8
    path = "Jokers.png",-- this is the name of the file that your sprites will use from your assets folder
    px = 71,
    py = 95,-- the standard 1x size of any joker or consumable is 71x95
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

SMODS.Sound({
    key = "hiss",
    path = "hiss.ogg",
    pitch = 1.1
})

-- do note that the key and path of an atlas is case sensitive, so make sure you are using the correct capitalization

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

-- this is where we will register other files from within this mods folder such as stuff from our Items folder, tho if you don't want to load that file you can comment it out by adding "--" aty the start of the line
-- when setting the files path you need to make sure that you are using the correct capitalization, because if you don't, your mod will crash on linux platforms
--assert(SMODS.load_file("Lib/Utility.lua"))() -- this is the file where we add the code to initialize the config menu and other utility functions

--[[SMODS.ObjectType({
    key = "CJModSet",
    default = "j_four_fingers",
    cards = {
         ["j_CJMod_keyOfTheJoker"] = true,
     },
    inject = function(self)
        SMODS.ObjectType.inject(self)
        self:inject_card(G.P_CENTERS.j_CJMod_keyOfTheJoker)
    end,
})]]--