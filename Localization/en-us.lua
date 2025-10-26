return{ -- things in this file ARE case sensitive, so make sure you are using the correct capitalization
    descriptions = {
        back ={
            
        },
        Joker = {
            j_exmp_examplejoker = {
                name = "Example Joker",
                text = {
                    "This is an example joker.",
                    "It can be used to demonstrate how to create a joker.",
                    "You can customize the text and effects as needed.",
                    "this Joker give {C:mult}+#1#{} mult" -- the {C:mult} is the color of the text and #1# is the first variable that is in the jokers config and the {} ends the colored text without having to start a new line
                }
            },
            -- example joker 3 is used for people to see if they can identify the problems and fix it, its not a requirement, but it is a good way for people to understand how you would fix some of these weird bugs and unintentional behavior
            j_exmp_examplejoker3 = {
                name = "Example Joker 3",
                text = {
                    "This is an example joker.",
                    "It can be used to demonstrate how to create a joker.",
                    "You can customize the text and effects as needed.",
                    "this Joker give {C:white}+#2# mult"
                }
            },
            j_exmp_examplejoker4 = {
                name = "Example Joker 4",
                text = {
                    "This is an example of a scaling joker",
                    "this joker will gain {X:mult,C:white}+X#2#{} additional mult",
                    "every time a card is scored",
                    "{C:inactive}(currently gives {X:mult,C:white}X#1#{} {C:inactive}mult)"
                }
            },
            j_exmp_examplejoker5 = {
                name = "Example Joker 5",
                text = {
                    "Gives {C:mult}+#1#{} mult every time a {C:attention}2{} is scored",
                },
            },
            j_exmp_examplejoker6 = {
                name = "Example Joker 6",
                text = {
                    "Gives {C:mult}+#1#{} mult every time a {C:attention}2{} is scored",
                    "Gives {C:chips}+#2#{} chips every time a {C:attention}7{} is scored",
                    "Gives {C:mult}+#1#{} and {C:chips}+#2#{} chips every time a {C:attention}Ace{} is scored",
                },
            },
            j_exmp_examplejoker7 = {
                name = "Example Joker 7",
                text = {
                    "for every scored {C:attention}2{} gain {C:mult}+#1#{} mult",
                    "for every scored {C:attention}7{} gain {C:purple}1{} storage value",
                    "for every scored {C:attention}Ace{} gain {C:mult}+#1#{} * (1 + {C:attention}#4#{}) mult",
                    "for every scored {C:attention}5{}",
                    "increase the amount of mult gained by {C:mult}+#3#{}",
                    "{C:inactive}currently at #5# storage value",
                }
            },
        },
        Tarot = {
            c_exmp_exampletarot = {
                name = "Example Tarot",
                text = {
                    "This is an example tarot.",
                    "It can be used to demonstrate how to create a tarot.",
                    "You can customize the text and effects as needed.",
                    "Convert up to {C:attention}#1#{} selected cards to diamonds" -- the {C:attention} is the color of the text and #1# is the first variable that is in the Tarot's config and the {} ends the colored text without having to start a new line
                }
            },
            c_exmp_ExampleEnhTarot = {
                name = "Example Enhancement Tarot",
                text = {
                    "Converts up to {C:attention}#1#{} selected cards to Example Enhancement"
                },
            },
        },
        Spectral = {
            c_exmp_examplespectral = {
                name = "Example Spectral",
                text = {
                    "This is an example spectral.",
                    "It can be used to demonstrate how to create a spectral.",
                    "You can customize the text and effects as needed.",
                    "creates #1# negative jokers"
                }
            },
        },
        Planet = {
            c_exmp_exampleplanet = {
                name = "Example Planet",
                text = {
					"{S:0.8}({S:0.8,V:1}lvl.#1#{S:0.8}){} Level up",
					"{C:attention}#2#",
					"{C:mult}+#3#{} Mult and",
					"{C:chips}+#4#{} chips",
                }
            },
        },
        Edition = {
            e_exmp_gold = {
                name = "Example Gold",
                text = {
                    "insert text here",
                }
            },
            e_exmp_laminated = {
                name = "Example Laminated",
                text = {
                    "insert text here",
                }
            },
        },
        Enhanced = {
            m_exmp_MultEnh = {
                name = "Example Enhancement",
                text = {
                    "Gives {C:mult}+#1#{} mult",
                },
            },
        },
        ExampleSet = { -- this is how we add localization for a custom consumable type
            c_exmp_exampleconsume ={
                name = "Example Custom Consumable",
                text = {
                    "this is a consumable of a custom type added by the mod",
                    "when used it will give you {C:attention}#1#{} random planet cards",
                }
            }
        },
    },
    misc = {
        dictionary = {
            exmp_hand_Royal_Flush = "Royal Flush",

            exmp_restart = "Requires a restart to take effect",
            no_exmp_restart = "takes effect at the start of the next run",
            include_custom_consumable = "Enables the custom example consumable",
            example_config_label = "Example Label",
            extra_hands = "Extra Hands",
            extra_hands_label = "Extra hands",
            extra_discards = "Extra Discards",
            extra_discards_label = "Extra discards",
            insert_text_here = "Insert text here",
            only_faces = "NO Face Cards",
            random_cards = "Random Cards",
            option_1 = "meh",
            option_2 = "ok",
            option_3 = "good",
            option_4 = "great",
            b_use = "Use",
        },
        poker_hand_descriptions = {
            ["exmp_Royal_Flush"] = {
                "5 cards in a row (consecutive ranks) with",
                "all cards sharing the same suit",
                "made of only Aces, tens, and face cards"
            },
        },
        poker_hands = {
            ["exmp_Royal_Flush"] = "Royal Flush",
        },
        label = {
            e_exmp_laminated = "Laminated",
            e_exmp_gold = "Gold",
        },
    },
}