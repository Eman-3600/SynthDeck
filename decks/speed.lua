local deck = {
    name = "Speed Deck",
    key = "speed",
    pos = {x = 4, y = 0},
    config = {},
    atlas = "atlassynthdeck",
    loc_txt = {
        name ="Speed Deck",
        text={
            "Start with all",
            "{C:attention}Booster Tags{}",
            "{C:attention}+1{} Ante",
        },
    }
}

deck.apply = function (self)
    G.E_MANAGER:add_event(Event({
        func = function()

            ease_ante(1)

            add_tag(Tag('tag_buffoon'))
            add_tag(Tag('tag_charm'))
            add_tag(Tag('tag_ethereal'))
            add_tag(Tag('tag_standard'))
            add_tag(Tag('tag_meteor'))
            play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
            play_sound('holo1', 1.2 + math.random()*0.1, 0.4)

            return true
        end
    }))
end

return deck