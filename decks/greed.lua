local deck = {
    name = "Greed Deck",
    key = "greed",
    pos = {x = 2, y = 0},
    config = {greed_count = 25, discards = -1},
    atlas = "atlassynthdeck",
    loc_txt = {
        name ="Greed Deck",
        text={
            "Increase hand size by {C:attention}1{}",
            "for every {C:money}$#1#{} you have",
            "{C:red}-1{} discard every round",
        },
    }
}

deck.loc_vars = function (self, info_queue, card)
    return {vars = {self.config.greed_count}}
end

deck.eman_update_money = function (self, dollars, added_dollars)

    local old_mod = G.GAME.greed_back_modifier or 0

    local new_mod = math.max(math.floor(dollars/self.config.greed_count), 0)

    G.GAME.greed_back_modifier = new_mod

    if new_mod ~= old_mod then
        G.hand:change_size(new_mod - old_mod)
    end
end

return deck