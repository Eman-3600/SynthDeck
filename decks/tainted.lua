local deck = {
    name = "Tainted Deck",
    key = "tainted",
    pos = {x = 1, y = 0},
    config = {joker_slot = -2},
    atlas = "atlassynthdeck",
    loc_txt = {
        name ="Tainted Deck",
        text={
            "At end of each Round:",
            "Create a {C:dark_edition}Negative{} {C:spectral}Spectral{} Card",
            "{C:red}-2{} Joker slots",
        },
    }
}

deck.trigger_effect = function(self, args)

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

return deck