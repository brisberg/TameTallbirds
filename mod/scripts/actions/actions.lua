local ACTIONS = _G.ACTIONS

-- Stay Action
ACTIONS.TTB_STAYHERE = {
    id = "TTB_STAYHERE",
    priority = 1,
    strfn = nil,
    testfn = nil,
    instant = false,
    rmb = true,
    distance = 3,
}

ACTIONS.TTB_STAYHERE.fn = function(act)
    -- print("Running the TTB_STAYHERE act fn")
    if act.doer.components.talker then
        -- print("   Say 'Stay Here'")
        act.doer.components.talker:Say(STRINGS.CHARACTERS.GENERIC.ANNOUNCE_ACTIONS.TTB_STAYHERE)
    end
    -- print("   Unfollow Player")
    act.target.userfunctions.UnfollowPlayer(act.target, act.doer)
    return true
end

-- Follow Action
ACTIONS.TTB_FOLLOW = {
    id = "TTB_FOLLOW",
    priority = 1,
    strfn = nil,
    testfn = nil,
    instant = false,
    rmb = true,
    distance = 3,
}

ACTIONS.TTB_FOLLOW.fn = function(act)
    -- print("Running the TTB_FOLLOW act fn")
    if act.doer.components.talker then
        -- print("   Say 'Let's go big guy'")
        act.doer.components.talker:Say(STRINGS.CHARACTERS.GENERIC.ANNOUNCE_ACTIONS.TTB_FOLLOW)
    end
    -- print("   Unfollow Player")
    act.target.userfunctions.FollowPlayer(act.target, act.doer)
    return true
end

-- Retreat Action
ACTIONS.TTB_RETREAT = {
    id = "TTB_RETREAT",
    priority = 2,
    strfn = nil,
    testfn = nil,
    instant = true,
    rmb = true,
}

ACTIONS.TTB_RETREAT.testfn = function(act)
    local combatant = act.target
    -- check if combatant is in combat
    return combatant and combatant.components.combat and combatant.components.combat.target
end

ACTIONS.TTB_RETREAT.fn = function(act)
    -- print("Running the TTB_RETREAT act fn")
    if act.target and act.target.components.combat then
        act.doer.components.talker:Say(STRINGS.CHARACTERS.GENERIC.ANNOUNCE_ACTIONS.TTB_RETREAT)
        act.target.userfunctions.Retreat(act.target)
    end

    act.target.userfunctions.FollowPlayer(act.target, act.doer)

    return true
end

-- Pet Action
ACTIONS.TTB_PETPET = {
    id = "TTB_PETPET",
    priority = 2,
    strfn = nil,
    testfn = nil,
    instant = false,
    rmb = false,
    distance = 2,
}

ACTIONS.TTB_PETPET.fn = function(act)
    -- print("Running the TTB_PETPET act fn")
    -- act.doer.components.talker:Say(STRINGS.CHARACTERS.GENERIC.ANNOUNCE_ACTIONS.TTB_PETPET)
    act.target.userfunctions.GetPet(act.target)

    return true
end
