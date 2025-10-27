-- thanks yahi and SMG9000 for the code, this is mine now

function create_UIBox_custom_video1(name, buttonname)
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
  default_weight = 0.02,
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

SMODS.Voucher{
  key = "cardjutsu",
  atlas = "Vouchers",
  pos = {x = 0, y = 0},
  loc_txt = {
    name = "Paper Jutsu",
    text = {
      "{C:blue}Played{} cards may appear",
      "{C:attention}multiple times{} during rounds"
    }
  },
  cost = 10,
}

SMODS.Voucher{
  key = "infinitus",
  atlas = "Vouchers",
  pos = {x = 1, y = 0},
  loc_txt = {
    name = "Cardis Infinitus",
    text = {
      "{C:red}Discarded{} cards may appear",
      "{C:attention}multiple times{} during rounds"
    }
  },
  cost = 10,
  requires = {"v_CJMod_cardjutsu"}
}