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

------------------------------------------------------
-- Load language specific strings
local languageStrings = require('lang/' .. GetModConfigData("LANGUAGE"))
STRINGS.NAMES.TAMETALLBIRD = languageStrings.TAMETALLBIRD_NAME
STRINGS.CHARACTERS.GENERIC.DESCRIBE.TAMETALLBIRD = languageStrings.TAMETALLBIRD_DESCRIBE
STRINGS.ACTIONS.TTB_STAYHERE = languageStrings.STAY_ACTION.NAME
STRINGS.ACTIONS.TTB_FOLLOW = languageStrings.FOLLOW_ACTION.NAME
STRINGS.ACTIONS.TTB_RETREAT = languageStrings.RETREAT_ACTION.NAME
STRINGS.ACTIONS.TTB_PETPET = languageStrings.PET_ACTION.NAME
STRINGS.CHARACTERS.GENERIC.ANNOUNCE_ACTIONS = {
    TTB_STAYHERE = languageStrings.STAY_ACTION.ANNOUNCE,
    TTB_FOLLOW = languageStrings.FOLLOW_ACTION.ANNOUNCE,
    TTB_RETREAT = languageStrings.RETREAT_ACTION.ANNOUNCE,
    TTB_PETPET = languageStrings.PET_ACTION.ANNOUNCE,
}

------------------------------------------------------
-- Load the custom actions
require('actions/actions')
ActionHandler = GLOBAL.ActionHandler

AddStategraphActionHandler("wilson",ActionHandler(GLOBAL.ACTIONS.TTB_STAYHERE))
AddStategraphActionHandler("wilson",ActionHandler(GLOBAL.ACTIONS.TTB_FOLLOW))

local pet_state = GLOBAL.State({
    name = "ttb_petpet",
    tags = {"notalking", "busy"},

    onenter = function(inst)
        inst.components.locomotor:Stop()

        inst.AnimState:PlayAnimation("punch")
        inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_whoosh")

        -- inst:FacePoint(Point(inst.components.combat.target.Transform:GetWorldPosition()))
    end,

    timeline =
    {
        GLOBAL.TimeEvent(8*GLOBAL.FRAMES, function(inst)
            print("petpet timeline perform action")
            inst.PerformBufferedAction()
        end),
    },

    events =
    {
        GLOBAL.EventHandler("animover", function(inst)
            print("petpet anim over")
            inst.sg:GoToState("idle")
        end ),
    },
})

AddStategraphState("wilson", pet_state)
AddStategraphActionHandler("wilson",ActionHandler(GLOBAL.ACTIONS.TTB_PETPET, "ttb_petpet"))

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
