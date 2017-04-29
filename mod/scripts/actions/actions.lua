-- require("modutil")

local action_data = {
    priority = 1,
    strfn = nil,
    testfn = nil,
    instant = true,
    distance = 3,
}

local action_fn = function(act)
    print("Running the TTB_STAYHERE act fn")
    if act.doer.components.talker then
        print("   Say 'Stay Here'")
        act.doer.components.talker:Say("Stay here!")
    end
    print("   Unfollow Player")
    act.target.userfunctions.UnfollowPlayer(act.target, act.doer)
    return true
end

if TheSim:GetGameID() == "DS" then
    ----- TEMP ACTIONS ---
    local ACTIONS = _G.ACTIONS
    -- require('actions')
    ACTIONS.TTB_STAYHERE = {
        priority = 1,
        strfn = nil,
        testfn = nil,
        instant = true,
        rmb = false,
        distance = 3,
    }
    -- ACTION(1, nil, true, 3)

    ACTIONS.TTB_STAYHERE.fn = action_fn

    STRINGS.ACTIONS.TTB_STAYHERE = "Stay"
    ACTIONS.TTB_STAYHERE.str = "Stay"
    ACTIONS.TTB_STAYHERE.id = "TTB_STAYHERE"
end
