
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
