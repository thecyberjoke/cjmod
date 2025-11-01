
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


SMODS.Voucher{
  key = "bigbet",
  atlas = "Vouchers",
  pos = {x = 0, y = 1},
  config = { money = 1 },
  loc_txt = {
    name = "Bigger Bet",
    text = {
      "{C:money}+#1#${} blind payout"
    }
  },
  loc_vars = function (self, info_queue, card)
    return { vars = { card.ability.money } }
  end,
  cost = 10,
  redeem = function (self, voucher)
    G.GAME.blind_payout = (G.GAME.blind_payout or 0) + voucher.ability.money
  end
}

--[[SMODS.Voucher{
  key = "giantbet",
  atlas = "Vouchers",
  pos = {x = 1, y = 1},
  config = { money = 2, hands = 1 },
  loc_vars = function (self, info_queue, card)
    return { vars = { card.ability.money, card.ability.hands } }
  end,
  loc_txt = {
    name = "All In",
    text = {
      "{C:money}+#1#${} blind payout",
      "{C:blue}-#2#{} hand every round",
    }
  },
  
  cost = 10,
  redeem = function (self, voucher)
    G.GAME.blind_payout = (G.GAME.blind_payout or 0) + voucher.ability.money
     G.GAME.round_resets.hands = G.GAME.round_resets.hands - voucher.ability.hands
    ease_hands_played(-voucher.ability.hands)
  end,
  requires = {"v_CJMod_bigbet"}
}]]