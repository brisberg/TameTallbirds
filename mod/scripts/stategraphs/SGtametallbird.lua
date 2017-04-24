require("stategraphs/commonstates")


local actionhandlers =
{
    ActionHandler(ACTIONS.EAT, "eat"),
}

local events=
{
    CommonHandlers.OnStep(),
    CommonHandlers.OnSleep(),
    CommonHandlers.OnLocomote(false,true),
    CommonHandlers.OnFreeze(),
    EventHandler("attacked", function(inst)
        if not inst.components.health:IsDead() then
            inst.sg:GoToState("hit")
        end
    end),
    EventHandler("doattack", function(inst)
        if not inst.components.health:IsDead() and (inst.sg:HasStateTag("hit") or not inst.sg:HasStateTag("busy")) then
			if inst:HasTag("peck_attack") then
				inst.sg:GoToState("peck")
			else
				inst.sg:GoToState("attack")
			end
        end
    end),

    EventHandler("death", function(inst) inst.sg:GoToState("death") end),
}

local states=
{
    State{
        name = "idle",
        tags = {"idle", "canrotate"},

        onenter = function(inst, pushanim)
        	print('SGtametallbird - idle')
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("idle", true)
            inst.sg:SetTimeout(4 + 4*math.random())
        end,

        ontimeout = function(inst)
            --print("smallbird - idle timeout")
            if math.random() <= inst.userfunctions.GetPeepChance(inst) then
                inst.sg:GoToState("idle_peep")
            else
                inst.sg:GoToState("idle_blink")
            end
        end,

        events=
        {
            EventHandler("startstarving",
                function(inst, data)
                    --print("smallbird - SG - startstarving")
                    inst.sg:GoToState("idle_peep")
                end
            ),
        },
    },

    State{
        name = "idle_blink",
        tags = {"idle", "canrotate"},

        onenter = function(inst)
        	print('SGtametallbird - idle_blink')
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("idle_blink")
        end,

        timeline =
        {
            TimeEvent(17*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/smallbird/blink") end),
        },

        events=
        {
            EventHandler("animover",
                function(inst,data)
                    if math.random() < 0.1 then
                        inst.sg:GoToState("idle_blink")
                    else
                        inst.sg:GoToState("idle")
                    end
                end
            ),
        },
    },

    State{
        name = "idle_peep",
        tags = {"idle"},

        onenter = function(inst)
        	print('SGtametallbird - idle_peep')
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("meep")
        end,

        timeline =
        {
            TimeEvent(3*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/smallbird/chirp") end),
        },

        events=
        {
            EventHandler("animover",
                function(inst,data)
                    if math.random() <= inst.userfunctions.GetPeepChance(inst) then
                        inst.sg:GoToState("idle_peep")
                    else
                        inst.sg:GoToState("idle")
                    end
                end
            ),
        },
    },

	State{
        name = "death",
        tags = {"busy"},

        onenter = function(inst)
        	print('SGtametallbird - death')
            inst.SoundEmitter:PlaySound("dontstarve/creatures/tallbird/death")
            inst.AnimState:PlayAnimation("death")
            inst.components.locomotor:StopMoving()
            RemovePhysicsColliders(inst)
            inst.components.lootdropper:DropLoot(Vector3(inst.Transform:GetWorldPosition()))
        end,

    },

    State{
        name = "taunt",
        tags = {"busy", "canrotate"},

        onenter = function(inst)
        	print('SGtametallbird - taunt')
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("call")
            if inst.components.combat and inst.components.combat.target then
                inst:FacePoint(Vector3(inst.components.combat.target.Transform:GetWorldPosition()))
            end
        end,

        timeline=
        {
            TimeEvent(6*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/tallbird/scratch_ground") end),
            TimeEvent(30*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/tallbird/scratch_ground") end),
        },

        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },

    State{
        name = "attack",
        tags = {"attack", "busy"},

        onenter = function(inst, cb)
        	print('SGtametallbird - attack')
            inst.Physics:Stop()
            inst.components.combat:StartAttack()
            inst.AnimState:PlayAnimation("atk_pre")
            inst.AnimState:PushAnimation("atk", false)
        end,

        timeline=
        {
            TimeEvent(10*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/tallbird/attack") end),
            TimeEvent(12*FRAMES, function(inst) inst.components.combat:DoAttack() end),
            TimeEvent(14*FRAMES, function(inst)
				inst.sg:RemoveStateTag("attack")
				inst.sg:RemoveStateTag("busy")
			end),
        },

        events=
        {
            EventHandler("animqueueover", function(inst) inst.sg:GoToState("idle") end),
        },
    },

    State{
        name = "peck",
        tags = {"attack", "busy", "canrotate"},

        onenter = function(inst, cb)
            inst.Physics:Stop()
            inst.components.combat:StartAttack()
            inst.AnimState:PlayAnimation("teenatk_pre")
            inst.AnimState:PushAnimation("teenatk", false)
        end,

        timeline =
        {
            TimeEvent(11*FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve/creatures/teenbird/peck")
            end),
            TimeEvent(13*FRAMES, function(inst)
                inst.components.combat:DoAttack()
                local target = inst.components.combat.target
                if target and target.components.talker then
                    target.components.talker:Say( GetString(target.prefab, "ANNOUNCE_PECKED") )
                end
            end),
        },

        events =
        {
            EventHandler("animqueueover", function(inst) inst.sg:GoToState("idle") end),
        },
    },

    State{
        name = "hit",
        tags = {"busy"},

        onenter = function(inst)
        	print('SGtametallbird - hit')
            inst.SoundEmitter:PlaySound("dontstarve/creatures/tallbird/hurt")
            inst.AnimState:PlayAnimation("hit")
            inst.Physics:Stop()
        end,

        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end ),
        },
    },
    State{
        name = "eat",
        tags = {"busy", "canrotate"},

        onenter = function(inst)
        	print('SGtametallbird - eat')
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("eat")
            inst.SoundEmitter:PlaySound("dontstarve/creatures/smallbird/scratch_ground")
        end,

        timeline=
        {
            TimeEvent(7*FRAMES, function(inst)
                inst:PerformBufferedAction()
            end),
        },

        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end ),
        },
    },
}

CommonStates.AddWalkStates(states, {
    walktimeline =
    {
        TimeEvent(0*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/tallbird/footstep") end ),
		TimeEvent(12*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/tallbird/footstep") end ),
    }
}, nil, true)

CommonStates.AddSleepStates(states,
{
    starttimeline =
    {
        TimeEvent(0*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/tallbird/sleep") end)
    },
    waketimeline =
    {
        TimeEvent(0*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/tallbird/wakeup") end)
    },
})
CommonStates.AddFrozenStates(states)

return StateGraph("tametallbird", states, events, "idle", actionhandlers)
