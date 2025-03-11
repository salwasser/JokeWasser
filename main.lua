
--Creates an atlas for cards to use
SMODS.Atlas {
    -- Key for code to find it with
    key = "JokeWasser",
    -- The name of the file, for the code to pull the atlas from
    path = "Jokers.png",
    -- Width of each sprite in 1x size
    px = 71,
    -- Height of each sprite in 1x size
    py = 95
}

SMODS.Joker {
    -- How the code refers to the joker.
    key = 'hard_hat',
    -- loc_text is the actual name and description that show in-game for the card.
    loc_txt = {
        name = 'Hard Hat',
        text = {
            --[[
            The #1# is a variable that's stored in config, and is put into loc_vars.
            The {C:} is a color modifier, and uses the color "mult" for the "+#1# " part, and then the empty {} is to reset all formatting, so that Mult remains uncolored.
                There's {X:}, which sets the background, usually used for XMult.
                There's {s:}, which is scale, and multiplies the text size by the value, like 0.8
                There's one more, {V:1}, but is more advanced, and is used in Castle and Ancient Jokers. It allows for a variable to dynamically change the color. You can find an example in the Castle joker if needed.
                Multiple variables can be used in one space, as long as you separate them with a comma. {C:attention, X:chips, s:1.3} would be the yellow attention color, with a blue chips-colored background,, and 1.3 times the scale of other text.
                You can find the vanilla joker descriptions and names as well as several other things in the localization files.
                ]]
            "Scored cards give",
            "{X:mult,C:white} X#1# {} Mult,",
            "but have a {C:green}#2# in #3#{} chance",
            "to be destroyed."
        }
    },
    --[[
        Config sets all the variables for your card, you want to put all numbers here.
        This is really useful for scaling numbers, but should be done with static numbers -
        If you want to change the static value, you'd only change this number, instead
        of going through all your code to change each instance individually.
        ]]
    config = {
        extra = {
            Xmult = 1.25,
            chance_denominator = 5
        }
    },
    -- loc_vars gives your loc_text variables to work with, in the format of #n#, n being the variable in order.
    -- #1# is the first variable in vars, #2# the second, #3# the third, and so on.
    -- It's also where you'd add to the info_queue, which is where things like the negative tooltip are.

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult, G.GAME.probabilities.normal, card.ability.extra.chance_denominator } }
    end,

    -- Sets rarity. 1 common, 2 uncommon, 3 rare, 4 legendary.
    rarity = 1,
    -- Which atlas key to pull from.
    atlas = 'JokeWasser',
    -- This card's position on the atlas, starting at {x=0,y=0} for the very top left.
    pos = { x = 0, y = 0 },
    -- Cost of card in shop.
    cost = 2,
    -- The functioning part of the joker, looks at context to decide what step of scoring the game is on, and then gives a 'return' value if something activates.
    unlocked = true, --where it is unlocked or not: if true,
    discovered = true, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    calculate = function(self, card, context)
        -- Tests if context.joker_main == true.
        -- joker_main is a SMODS specific thing, and is where the effects of jokers that just give +stuff in the joker area area triggered, like Joker giving +Mult, Cavendish giving XMult, and Bull giving +Chips.

        if context.individual and context.cardarea == G.play then
            return {
                message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } },
                Xmult_mod = card.ability.extra.Xmult
            }
        elseif context.destroying_card then
            if pseudorandom('hard_hat') < G.GAME.probabilities.normal/card.ability.extra.chance_denominator then
                return true
            end
        end

    end
}

----------------------------------------------
------------MOD CODE END----------------------
