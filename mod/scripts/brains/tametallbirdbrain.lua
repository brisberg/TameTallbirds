require "behaviours/chaseandattack"
require "behaviours/faceentity"
require "behaviours/follow"
require "behaviours/standstill"
require "behaviours/wander"


local MIN_FOLLOW_DIST = 2
local MAX_FOLLOW_DIST = 9
local MAX_IDLE_WANDER_DIST = 6
local LEASH_RETURN_DIST = 10
local LEASH_MAX_DIST = 20
local TARGET_FOLLOW_DIST = (MAX_FOLLOW_DIST+MIN_FOLLOW_DIST)/2

local MAX_CHASE_TIME = 10

local TRADE_DIST = 20

local SEE_FOOD_DIST = 15
local FIND_FOOD_HUNGER_PERCENT = 0.75 -- if hunger below this, forage for nearby food

--local MAX_WANDER_DIST = 20
--local MAX_CHASE_DIST = 30

local START_RUN_DIST = 4
local STOP_RUN_DIST = 6

local function IsHungry(inst)
    return inst.components.hunger and inst.components.hunger:GetPercent() < FIND_FOOD_HUNGER_PERCENT
end

local function IsStarving(inst)
    return inst.components.hunger and inst.components.hunger:IsStarving()
end

local function ShouldStandStill(inst)
    return inst.components.hunger and inst.components.hunger:IsStarving() and not inst:HasTag("teenbird") 
end

local function CanSeeFood(inst)
    local notags = {"FX", "NOCLICK", "DECOR","INLIMBO"}
    local target = FindEntity(inst, SEE_FOOD_DIST, function(item) return inst.components.eater:CanEat(item) end, nil, notags)
    -- if target then
    --     print("CanSeeFood", inst.name, target.name)
    -- end
    return target
end

local function FindFoodAction(inst)
	-- if inst.sg:HasStateTag("busy") then
	-- 	return
	-- end

    local target = CanSeeFood(inst)
    if target then
        return BufferedAction(inst, target, ACTIONS.EAT)
    end
end

local function GetTraderFn(inst)
	return FindEntity(inst, TRADE_DIST, function(target) return inst.components.trader:IsTryingToTradeWithMe(target) end, {"player"})
end

local function KeepTraderFn(inst, target)
    return inst.components.trader:IsTryingToTradeWithMe(target)
end

local function GetStayLocation(inst)
	-- print('GetStayLocation', inst.stayLoc:_toString())
	return inst.stayLoc
end

local function SpringMod(amt)
    -- if GetSeasonManager() and (GetSeasonManager():IsSpring() or GetSeasonManager():IsGreenSeason()) then
    --     return amt * TUNING.SPRING_COMBAT_MOD
    -- else
    --     return amt
    -- end
    return amt
end

local TameTallBirdBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

function TameTallBirdBrain:OnStart()
    local root = 
    PriorityNode({
        FaceEntity(self.inst, GetTraderFn, KeepTraderFn),
        -- when starving prefer finding food over fighting
        SequenceNode{
            ConditionNode(function() return IsStarving(self.inst) and CanSeeFood(self.inst) end, "SeesFoodToEat"),
            ParallelNodeAny {
                WaitNode(math.random()*.5),
                PriorityNode {
                	Follow(self.inst, function() return self.inst.components.follower.leader end, MIN_FOLLOW_DIST, TARGET_FOLLOW_DIST, MAX_FOLLOW_DIST),
                },
            },
            DoAction(self.inst, FindFoodAction),
        },
        SequenceNode{
            ConditionNode(function() return self.inst.components.combat.target ~= nil end, "HasTarget"),
            WaitNode(math.random()*.9),
            ChaseAndAttack(self.inst, SpringMod(MAX_CHASE_TIME)),
        },
        SequenceNode{
            ConditionNode(function() return IsHungry(self.inst) and CanSeeFood(self.inst) end, "SeesFoodToEat"),
            ParallelNodeAny {
                WaitNode(1 + math.random()*2),
                PriorityNode {
                	Follow(self.inst, function() return self.inst.components.follower.leader end, MIN_FOLLOW_DIST, TARGET_FOLLOW_DIST, MAX_FOLLOW_DIST),
                },
            },
            DoAction(self.inst, FindFoodAction),
        },
        Follow(self.inst, function() return self.inst.components.follower.leader end, MIN_FOLLOW_DIST, TARGET_FOLLOW_DIST, MAX_FOLLOW_DIST),
        SequenceNode{
        	ConditionNode(function() return self.inst.components.follower.leader end, "HasLeader"),
        	Wander(self.inst, function() if self.inst.components.follower.leader then return Vector3(self.inst.components.follower.leader.Transform:GetWorldPosition()) end end, MAX_FOLLOW_DIST-1, {minwalktime=.5, randwalktime=.5, minwaittime=6, randwaittime=3}),
    	},
        Wander(self.inst, GetStayLocation, MAX_FOLLOW_DIST-1, {minwalktime=.5, randwalktime=.5, minwaittime=6, randwaittime=3}),
    },.25)
    self.bt = BT(self.inst, root)
end

return TameTallBirdBrain
