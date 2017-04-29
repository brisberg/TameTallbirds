_G = GLOBAL
TUNING = _G.TUNING
STRINGS = _G.STRINGS
require = _G.require
IsDLCEnabled = _G.IsDLCEnabled

-- Add a prefabpostinit to teenbirds to make then select which type of adult they should grow up into.
tweak_teenbird = require('tweaks/tweakteenbird')

AddPrefabPostInit("teenbird", tweak_teenbird)

-- Add a prefabpostinit to smallbirds to remove as follower when they grow up
tweak_smallbird = require('tweaks/tweaksmallbird')

AddPrefabPostInit("smallbird", tweak_smallbird)
------------------------------------------------------

-- Define a new prefab for Tame Tallbirds
PrefabFiles = {'tametallbird'}
STRINGS.NAMES.TAMETALLBIRD = 'Tame Tallbird'
STRINGS.CHARACTERS.GENERIC.DESCRIBE.TAMETALLBIRD = {
    FULL = "Surprisingly friendly with a full stomach.",
    GENERIC = "Very tall and very loyal.",
    HUNGRY = "Better get you some food, Big Guy.",
    STARVING = "Careful Big Guy, just don't eat me!",
    SLEEPING = "Curiously docile.",
}

------------------------------------------------------
-- Load the custom actions
require('actions/actions')

if GLOBAL.TheSim:GetGameID() == "DST" then
    -- local Action = ACTION
    local TTB_STAYHERE = AddAction("TTB_STAYHERE", "Stay", function(act)
        print("Running the TTB_STAYHERE act fn")
        if act.doer.components.talker then
            print("   Say 'Stay Here'")
            act.doer.components.talker:Say("Stay here!")
        end
        print("   Unfollow Player")
        act.target.userfunctions.UnfollowPlayer(act.target, act.doer)
        return true
    end)
    -- TTB_STAYHERE.priority = action_data.priority
    -- TTB_STAYHERE.instant = action_data.instant
    -- TTB_STAYHERE.distance = action_data.distance
    TTB_STAYHERE.priority = 1
    TTB_STAYHERE.instant = true
    TTB_STAYHERE.distance = 3
end

if GLOBAL.TheSim:GetGameID() == "DST" then
    local function stayhere_action(inst, doer, pos, actions, right)
        if right and self.inst.components.follower and self.inst.components.follower.leader == doer then
            table.insert(actions, ACTIONS.TTB_STAYHERE)
        end
    end
    AddComponentAction("SCENE", "ttb_pet", stayhere_action)
end

------------------------------------------------------
-- Tuning Values for Tame Tallbirds
TUNING.TAME_TALLBIRD_HEALTH = 400 * GetModConfigData("TAMETALLBIRD_HEALTH_MOD")
TUNING.TAME_TALLBIRD_DAMAGE = 50 * GetModConfigData("TAMETALLBIRD_DAMAGE_MOD")
TUNING.TAME_TALLBIRD_ATTACK_PERIOD = 2
TUNING.TAME_TALLBIRD_ATTACK_RANGE = 3
TUNING.TAME_TALLBIRD_TARGET_DIST = 8
TUNING.TAME_TALLBIRD_DEFEND_DIST = 12

TUNING.TAME_TALLBIRD_DAMAGE_PECK = 2
TUNING.TAME_TALLBIRD_PECK_PERIOD = 4
TUNING.TAME_TALLBIRD_HUNGER = 120
TUNING.TAME_TALLBIRD_STARVE_TIME = TUNING.TOTAL_DAY_TIME * GetModConfigData("TAMETALLBIRD_STARVE_TIME")
TUNING.TAME_TALLBIRD_STARVE_KILL_TIME = 240

-- Tuning Values for Tallbird Growth
TUNING.SMALLBIRD_HATCH_TIME = TUNING.TOTAL_DAY_TIME * GetModConfigData("TALLBIRDEGG_HATCH_TIME")
TUNING.SMALLBIRD_GROW_TIME = TUNING.TOTAL_DAY_TIME * GetModConfigData("TEEN_GROWTH_TIME")
TUNING.TEENBIRD_GROW_TIME = TUNING.TOTAL_DAY_TIME * GetModConfigData("ADULT_GROWTH_TIME")

------------------------------------------------------
-- For Reference
--TALLBIRD_HEALTH = 400,
--TALLBIRD_DAMAGE = 50,
--TALLBIRD_ATTACK_PERIOD = 2,
--TALLBIRD_ATTACK_RANGE = 3,
--TALLBIRD_TARGET_DIST = 8,
--TALLBIRD_DEFEND_DIST = 12,

--TEENBIRD_DAMAGE_PECK = 2,
--TEENBIRD_PECK_PERIOD = 4,
--TEENBIRD_HUNGER = 60,
--TEENBIRD_STARVE_TIME = total_day_time * 1,
--TEENBIRD_STARVE_KILL_TIME = 240,

------------------------------------------------------
-- Speed smallbird growth for testing purposes
if GetModConfigData("DEBUG_GROWTH_SPEED") then
	TUNING.SMALLBIRD_HATCH_TIME = 5
	TUNING.SMALLBIRD_GROW_TIME = 10
	TUNING.TEENBIRD_GROW_TIME = 10
end
