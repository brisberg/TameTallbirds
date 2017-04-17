-- Add a prefabpostinit to teenbirds to make then select which type of adult they should grow up into.

print('Loading tallbird mod')
tweak_teenbird = GLOBAL.require('tweaks/tweakteenbird')

AddPrefabPostInit("teenbird", tweak_teenbird)
------------------------------------------------------

-- Define a new prefab for Tame Tallbirds
PrefabFiles = {'tametallbird'}
_G = GLOBAL
TUNING = _G.TUNING
GLOBAL.STRINGS.NAMES.TAMETALLBIRD = 'Tallbird'

------------------------------------------------------
-- Tuning Values for Tame Tallbirds
TUNING.TAME_TALLBIRD_HEALTH = 400
TUNING.TAME_TALLBIRD_DAMAGE = 50
TUNING.TAME_TALLBIRD_ATTACK_PERIOD = 2
TUNING.TAME_TALLBIRD_ATTACK_RANGE = 3
TUNING.TAME_TALLBIRD_TARGET_DIST = 8
TUNING.TAME_TALLBIRD_DEFEND_DIST = 12

TUNING.TAME_TALLBIRD_DAMAGE_PECK = 2
TUNING.TAME_TALLBIRD_PECK_PERIOD = 4
TUNING.TAME_TALLBIRD_HUNGER = 120
TUNING.TAME_TALLBIRD_STARVE_TIME = TUNING.TOTAL_DAY_TIME * 0.1
TUNING.TAME_TALLBIRD_STARVE_KILL_TIME = 240

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

-- print(TUNING.SMALLBIRD_HATCH_TIME)

------------------------------------------------------
-- Speed smallbird growth for testing purposes
print(TUNING.SMALLBIRD_HATCH_TIME)
TUNING.SMALLBIRD_HATCH_TIME = 5
TUNING.SMALLBIRD_GROW_TIME = 10
TUNING.TEENBIRD_GROW_TIME = 10
print(TUNING.SMALLBIRD_HATCH_TIME)
