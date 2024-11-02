----------------------------------------------
------------MOD CODE -------------------------

local mod_path = SMODS.current_mod.path
SMODS.Atlas{
    object_type = "atlas",
    key = "atlassynthdeck",
    path = "SynthDecks.png",
    px = 71,
    py = 95,
}

-- SYNTHETIC DECK --
SMODS.Back{
    name = "SynthDeck",
    key = "synthdeck",
    pos = {x = 0, y = 5},
    config = {cards_per_round = 2, cards_in_deck = 13, consumables = {'c_aura'}},
    atlas = "atlassynthdeck",
    loc_txt = {
        name ="Synthetic Deck",
        text={
            "At end of each Round:",
            "Create {C:attention}2{C:attention} Playing{} Cards",
            "Start with {C:attention}13{C:attention} Playing{} Cards",
            "and {C:attention}1{} copy of {C:spectral,T:c_aura}Aura{}",
        },
    },
    apply = function(self)

        G.E_MANAGER:add_event(Event({
            func = function()

                while #G.playing_cards > self.config.cards_in_deck do
                    local i = pseudorandom('synthbase', 1, #G.playing_cards)

                    G.playing_cards[i]:remove()
                end

                G.GAME.starting_deck_size = #G.playing_cards

                return true
            end
        }))
    end,

    trigger_effect = function(self, args)

        if (args.context == 'eval') then

            G.E_MANAGER:add_event(Event({
                func = (function()
                    for i = 1,self.config.cards_per_round,1 do
                        card = create_card((pseudorandom(pseudoseed('synthset'..G.GAME.round_resets.ante)) > 0.6) and "Enhanced" or "Base", G.pack_cards, nil, nil, nil, true, nil, 'sta')
                        local edition_rate = 2
                        local edition = poll_edition('standard_edition'..G.GAME.round_resets.ante, edition_rate, true)
                        card:set_edition(edition)
                        local seal_rate = 10
                        local seal_poll = pseudorandom(pseudoseed('synthseal'..G.GAME.round_resets.ante))
                        if seal_poll > 1 - 0.02*seal_rate then
                            local seal_type = pseudorandom(pseudoseed('synthsealtype'..G.GAME.round_resets.ante))
                            if seal_type > 0.75 then card:set_seal('Red')
                            elseif seal_type > 0.5 then card:set_seal('Blue')
                            elseif seal_type > 0.25 then card:set_seal('Gold')
                            else card:set_seal('Purple')
                            end
                        end

                        card:start_materialize({G.C.SECONDARY_SET.Enhanced})
                        G.play:emplace(card)
                        table.insert(G.playing_cards, card)
                    end
                    return true
                end)
            }))

            G.E_MANAGER:add_event(Event({
                func = function() 
                    G.deck.config.card_limit = G.deck.config.card_limit + self.config.cards_per_round

                    for i = 1,self.config.cards_per_round,1 do
                        draw_card(G.play,G.deck, 90,'up', nil)
                        playing_card_joker_effects({true})
                    end

                    return true
                end
            }))
        end

    end
}

-- TAINTED DECK --
SMODS.Back{
    name = "TaintedDeck",
    key = "tainteddeck",
    pos = {x = 1, y = 5},
    config = {joker_slot = -2},
    atlas = "atlassynthdeck",
    loc_txt = {
        name ="Tainted Deck",
        text={
            "At end of each Round:",
            "Create a {C:dark_edition}Negative{} {C:spectral}Spectral{} Card",
            "{C:red}-2{} Joker slots",
        },
    },
    
    trigger_effect = function(self, args)

        if (args.context == 'eval') then
            
            G.E_MANAGER:add_event(Event({
                func = (function()

                    local card = create_card('Spectral',G.consumeables, nil, nil, nil, nil, nil, 'sea')
                    card:set_edition({negative = true}, true)
                    card:add_to_deck()
                    G.consumeables:emplace(card)

                    return true
                end)
            }))
        end

    end
}
    ----------------------------------------------
    ------------MOD CODE END----------------------