----- TEMP ACTIONS ---
local ACTIONS = _G.ACTIONS
-- require('actions')
ACTIONS.TTB_STAYHERE = {
    priority = 1,
    strfn = nil,
    testfn = nil,
    instant = true,
    rmb = true,
    distance = 3,
}
-- ACTION(1, nil, true, 3)

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

ACTIONS.TTB_STAYHERE.id = "TTB_STAYHERE"
