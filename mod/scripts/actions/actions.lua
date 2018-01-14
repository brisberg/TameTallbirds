----- TEMP ACTIONS ---
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
