-- Add a prefabpostinit to teenbirds to make then select which type of adult they should grow up into.

local function SpawnTameAdult(inst)
	--print("TameTallbirds - SpawnTameAdult called")

    local tamebird = GLOBAL.SpawnPrefab("tametallbird")
	--local tamebird = GLOBAL.SpawnPrefab("spider")
    tamebird.Transform:SetPosition(inst.Transform:GetWorldPosition())
    tamebird.sg:GoToState("idle")

    if inst.components.follower and inst.components.follower.leader then
        tamebird.components.follower:SetLeader(inst.components.follower.leader)
    end

    inst:Remove()
end

function tweak_teenbird(inst)
    local SpawnNormalAdult = inst.userfunctions.SpawnAdult
    function inst.userfunctions.SpawnAdult(inst)
        if
            inst.components.follower
            and inst.components.follower.leader
            and inst.components.follower.leader:HasTag("player")
        then
			-- We are a teen following a player, spawn a tame adult
            SpawnTameAdult(inst)
        else
			-- We are a wild bird, spawn normal adult
            SpawnNormalAdult(inst)
        end
    end
end

AddPrefabPostInit("teenbird", tweak_teenbird)
------------------------------------------------------

-- Define a new prefab for Tame Tallbirds
PrefabFiles = {'tametallbird'}

GLOBAL.STRINGS.NAMES.TAMETALLBIRD = 'Tallbird'

------------------------------------------------------
-- Tuning Values for Tame Tallbirds
GLOBAL.TUNING.TAME_TALLBIRD_HEALTH = 400
GLOBAL.TUNING.TAME_TALLBIRD_DAMAGE = 50
GLOBAL.TUNING.TAME_TALLBIRD_ATTACK_PERIOD = 2
GLOBAL.TUNING.TAME_TALLBIRD_ATTACK_RANGE = 3
GLOBAL.TUNING.TAME_TALLBIRD_TARGET_DIST = 8
GLOBAL.TUNING.TAME_TALLBIRD_DEFEND_DIST = 12

GLOBAL.TUNING.TAME_TALLBIRD_DAMAGE_PECK = 2
GLOBAL.TUNING.TAME_TALLBIRD_PECK_PERIOD = 4
GLOBAL.TUNING.TAME_TALLBIRD_HUNGER = 120
GLOBAL.TUNING.TAME_TALLBIRD_STARVE_TIME = GLOBAL.TUNING.TOTAL_DAY_TIME * 0.1
GLOBAL.TUNING.TAME_TALLBIRD_STARVE_KILL_TIME = 240

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
TUNING.SMALLBIRD_HATCH_TIME = 5
TUNING.SMALLBIRD_GROW_TIME = 10
TUNING.TEENBIRD_GROW_TIME = 10