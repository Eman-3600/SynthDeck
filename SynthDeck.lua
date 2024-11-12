----------------------------------------------
------------MOD CODE -------------------------

-- list of all decks
local deck_list = {
    "synth",
    "tainted",
    "greed",
    "radioactive",
}

local mod_path = SMODS.current_mod.path
SMODS.Atlas{
    object_type = "atlas",
    key = "atlassynthdeck",
    path = "SynthDecks.png",
    px = 71,
    py = 95,
}





-- basically taken from MathBlinds, which was basically taken from Mystblinds, which was basically taken from 5CEBalatro lol
for k, v in ipairs(deck_list) do
    local deck = NFS.load(mod_path .. "decks/" .. v .. ".lua")()

    -- load if present
    if not deck then
        sendErrorMessage("[ClockBosses] Cannot find deck with shorthand: " .. v)
    else
        deck.key = v
        deck.discovered = false

        local deck_obj = SMODS.Back(deck)

        for k_, v_ in pairs(deck) do
            if type(v_) == 'function' then
                deck_obj[k_] = deck[k_]
            end
        end
    end
end
    ----------------------------------------------
    ------------MOD CODE END----------------------