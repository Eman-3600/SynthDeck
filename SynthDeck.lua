--- STEAMODDED HEADER
--- MOD_NAME: Synthetic Deck
--- MOD_ID: SynthDeck
--- MOD_AUTHOR: [Eman3600]
--- MOD_DESCRIPTION: A deck that starts small and grows each round.

----------------------------------------------
------------MOD CODE -------------------------

function SMODS.INIT.SynthDeck()

    local ch_Synth_art = SMODS.findModByID("SynthDeck")

    local atlasdeck = {
        object_type = "Atlas",
        key = "atlasynthdeck",
        path = "SynthDecks.png",
        px = 71,
        py = 95,
    }

    local sprite_centers = SMODS.Sprite:new("atlassynthdeck", ch_Synth_art.path, "SynthDecks.png", 71, 95, "asset_atli")
    sprite_centers:register()

    SMODS.Back{
        name = "SynthDeck",
        key = "synthdeck",
        pos = {x = 0, y = 5},
        config = {cards_per_round = 3},
        atlas = "atlassynthdeck",
        loc_txt = {
            name ="Synthetic Deck",
            text={
                "At end of each Round:",
                "Create 3 playing cards",
                "Start with 12 {C:attention}Stone cards",
            },
        },
        apply = function(self)
            G.E_MANAGER:add_event(Event({
                func = function()

                    for k, v in pairs(G.playing_cards) do
                        if not v:is_face() then
                            v.to_remove = true
                        else
                            v:set_base(pseudorandom_element(G.P_CARDS, pseudoseed('synthbase')))
                            v:set_ability(G.P_CENTERS.m_stone)
                        end
                    end
                    
                    local i = 1
                    while i <= #G.playing_cards do
                        if G.playing_cards[i].to_remove then
                            G.playing_cards[i]:remove()
                        else
                            i = i + 1
                        end
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
                        G.deck.config.card_limit = G.deck.config.card_limit + 4
                        return true
                    end}))
                    for i = 1,self.config.cards_per_round,1 do
                        draw_card(G.play,G.deck, 90,'up', nil)
                    end

                playing_card_joker_effects({true})
            end

        end
    }
end
    ----------------------------------------------
    ------------MOD CODE END----------------------