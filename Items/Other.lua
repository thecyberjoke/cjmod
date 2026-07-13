

SMODS.Sound({
    key = "music_ice", 
    path = "IceAtNight.ogg",
    pitch = 1,
    volume = 0.6,
    select_music_track = function()
        if G.STATE == G.STATES.SMODS_BOOSTER_OPENED then
            if G.pack_cards
                and G.pack_cards.cards
                and G.pack_cards.cards[1]
                and G.pack_cards.cards[1].config
                and G.pack_cards.cards[1].config.center
                and G.pack_cards.cards[1].config.center.mod
                and G.pack_cards.cards[1].config.center.mod.id 
                and G.pack_cards.cards[1].config.center.mod.id == "cjmod" then
		        return true 
            end
        end
	end,
})

SMODS.Sound({
    key = "music_limbus", 
    path = "Limbus.ogg",
    pitch = 1,
    volume = 0.3,
    select_music_track = function()
      local count = 0
      if G.GAME.blind and string.len(G.GAME.blind.name) > 0 and G.jokers then
        for n, x in ipairs(G.jokers.cards) do
          if x.config and x.config.center and x.config.center.pools and x.config.center.pools["LimbusFinger"] then
            count = count + 1
          end
        end
      end 
      return count >= 2
	end,
})

SMODS.Sound({
    key = "music_limbusbattle", 
    path = "Battle.ogg",
    pitch = 1,
    volume = 0.4,
    select_music_track = function()
      local istheresinner = false
      local istheredante = false
      if G.GAME.blind and string.len(G.GAME.blind.name) > 0 and G.jokers then
        for n, x in ipairs(G.jokers.cards) do
          if x.config and x.config.center and x.config.center.pools and x.config.center.pools["Sinner"] then
            istheresinner = true
          elseif x.config and x.config.center_key == "j_CJMod_dantesinner" then
            istheredante = true
          end
        end
      end 
      return istheredante and istheresinner
	end,
})

-- thanks yahi and SMG9000 for the code, this is mine now

function create_UIBox_custom_videos(name, buttonname)
  local file_path = CJMod.path .. "/resources/" .. name .. ".ogv"
  local file = NFS.read(file_path)
  love.filesystem.write("temp.ogv", file)
  local video_file = love.graphics.newVideo('temp.ogv')
  local vid_sprite = Sprite(0, 0, 11 * 16 / 9, 11, G.ASSET_ATLAS["ui_" .. (G.SETTINGS.colourblind_option and 2 or 1)],
    { x = 0, y = 0 })
  video_file:getSource():setVolume(G.SETTINGS.SOUND.volume * G.SETTINGS.SOUND.game_sounds_volume / (100 * 10))
  vid_sprite.video = video_file
  video_file:play()

  local t = create_UIBox_generic_options({
    back_delay = 3,
    back_label = buttonname,
    colour = G.C.BLACK,
    padding = 0,
    contents = {
      { n = G.UIT.O, config = { object = vid_sprite } } }
  })
  return t
end

function modify(t, min, max, mult)
  if t and type(t) == "table" then
    for m, y in pairs(t) do
      if type(y) == "table" then
        modify(y, min, max, mult)
      elseif type(y) == "number" then
        local modifier = pseudorandom(pseudoseed("ssdfg"), min * (mult or 1), max * (mult or 1))/mult
        t[m] = y * modifier
      end
    end
  end
end

CJMod.time_events = {
  clock = {},
  timed = {}
}

---@param every number
---@param func function
function clock_event(every, func)
  table.insert(CJMod.time_events.clock, {func = func, time = every, current = 0})
end

function timed_event(every, func)
  table.insert(CJMod.time_events.timed, {func = func, time = every, current = 0})
end

clock_event(0.5, function()
  if G.GAME and G.GAME.blind then
    local curmusic = SMODS.Sound:get_current_music()

    if curmusic == "CJMod_music_limbus" then
      G.ROOM.jiggle = (G.ROOM.jiggle or 0) + 2.5
    end
  end
end)

CJModGradients = {
  stupid = SMODS.Gradient {
    key = "stupid",
    colours = {
      HEX("1cffbe"),
      HEX("ffa1a1"),
    },
    cycle = 3,
    interpolation = "trig"
  }
}

SMODS.Rarity {
  key = "stupid",
  loc_txt = {
      name = "Stupid",
  },
  default_weight = 0.0325,
  badge_colour = CJModGradients.stupid,
  get_weight = function(self, weight, object_type)
    return weight
  end,
}

SMODS.Font {
  key = "papyrus",
  path = "papyrus.ttf",
  render_scale = 200,
  TEXT_HEIGHT_SCALE = 0.83,
  TEXT_OFFSET = { x = 0, y = 0 },
  FONTSCALE = 0.1,
  squish = 1,
  DESCSCALE = 1,
}

SMODS.Font {
  key = "comic",
  path = "comicsans.ttf",
  render_scale = 150,
  TEXT_HEIGHT_SCALE = 0.83,
  TEXT_OFFSET = { x = 0, y = 0 },
  FONTSCALE = 0.1,
  squish = 1,
  DESCSCALE = 1,
}

local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890!?#@-.,;:|"

---@param length integer
function random_bullshit(length)
  local composed = ""
  for i = 1, length do
    local num = math.random(1, #chars)
    local char = chars:sub(num, num)

    composed = composed.. char
  end

  return composed
end