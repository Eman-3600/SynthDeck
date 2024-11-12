local deck = {
    name = "Radioactive Deck",
    key = "radioactive",
    pos = {x = 3, y = 0},
    config = {vouchers = {'v_magic_trick','v_illusion', 'v_overstock_norm'}, decay_chance = 2, global_mult = 2},
    atlas = "atlassynthdeck",
    loc_txt = {
        name ="Radioactive Deck",
        text={
            "#1# in #2# scored cards are destroyed",
            "All cards score {C:red}X#6# mult{}",
            "Start with {C:attention,T:v_magic_trick}#3#,",
            "{C:attention,T:v_illusion}#4#, and {C:attention,T:v_overstock_norm}#5#",
        },
    }
}

deck.eman_should_destroy = function (self, card)
    if (card.ability.radioactive_decay) then
        return true
    end

    -- if (pseudorandom(pseudoseed('radioactive')) < G.GAME.probabilities.normal/self.config.decay_chance) then return true end
end

deck.eman_modify_played_card = function (self, card)
    if (pseudorandom(pseudoseed('radioactive')) < G.GAME.probabilities.normal/self.config.decay_chance) then
        card.ability.radioactive_decay = true
    end
end

deck.eman_add_card_effect = function (self, card)
    return {
        x_mult = self.config.global_mult
    }
end

deck.loc_vars = function (self, info_queue, card)
    return {vars = {
        (""..(G.GAME.probabilities.normal or 1)),
        self.config.decay_chance,
        localize{type = 'name_text', key = 'v_magic_trick', set = 'Voucher'},
        localize{type = 'name_text', key = 'v_illusion', set = 'Voucher'},
        localize{type = 'name_text', key = 'v_overstock_norm', set = 'Voucher'},
        self.config.global_mult,
    }}
end

return deck