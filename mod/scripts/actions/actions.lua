local Action = GLOBAL.Action
local ActionHandler = GLOBAL.ActionHandler
local languageStrings = require('lang/' .. GetModConfigData("LANGUAGE"))
local bpx = GLOBAL.bpx

-- Stay Action
local TTB_STAYHERE = bpx.AddAction("TTB_STAYHERE", languageStrings.STAY_ACTION.NAME, function(act)
  -- print("Running the TTB_STAYHERE act fn")
  if act.doer.components.talker then
      -- print("   Say 'Stay Here'")
      act.doer.components.talker:Say(STRINGS.CHARACTERS.GENERIC.ANNOUNCE_ACTIONS.TTB_STAYHERE)
  end
  -- print("   Unfollow Player")
  act.target.userfunctions.UnfollowPlayer(act.target, act.doer)
  return true
end)
TTB_STAYHERE.priority = 1
TTB_STAYHERE.rmb = true
TTB_STAYHERE.distance = 3

bpx.AddComponentAction("SCENE", "ttb_pet", function(inst, doer, actions, right)
  -- print("collect scene action for ttb_pet ttb_stayhere")
  if right and inst.replicas.follower and inst.replicas.follower.leader == doer then
      table.insert(actions, GLOBAL.ACTIONS.TTB_STAYHERE)
  end
end)

-- Follow Action
local TTB_FOLLOW = bpx.AddAction("TTB_FOLLOW", languageStrings.FOLLOW_ACTION.NAME, function(act)
  -- print("Running the TTB_FOLLOW act fn")
  if act.doer.components.talker then
      -- print("   Say 'Let's go big guy'")
      act.doer.components.talker:Say(STRINGS.CHARACTERS.GENERIC.ANNOUNCE_ACTIONS.TTB_FOLLOW)
  end
  -- print("   Unfollow Player")
  act.target.userfunctions.FollowPlayer(act.target, act.doer)
  return true
end)
TTB_FOLLOW.priority = 1
TTB_FOLLOW.rmb = true
TTB_FOLLOW.distance = 3

bpx.AddComponentAction("SCENE", "ttb_pet", function(inst, doer, actions, right)
  -- print("collect scene action for ttb_pet ttb_follow")
  if right and inst.replicas.follower and inst.replicas.follower.leader == nil then
      table.insert(actions, GLOBAL.ACTIONS.TTB_FOLLOW)
  end
end)

-- Retreat Action
local TTB_RETREAT = bpx.AddAction("TTB_RETREAT", languageStrings.RETREAT_ACTION.NAME, function(act)
  -- print("Running the TTB_RETREAT act fn")
  if act.target and act.target.components.combat then
      act.doer.components.talker:Say(STRINGS.CHARACTERS.GENERIC.ANNOUNCE_ACTIONS.TTB_RETREAT)
      act.target.userfunctions.Retreat(act.target)
  end

  act.target.userfunctions.FollowPlayer(act.target, act.doer)

  return true
end)
TTB_RETREAT.priority = 2
TTB_RETREAT.instant = true
TTB_RETREAT.rmb = true
TTB_RETREAT.testfn = function(act)
    local combatant = act.target
    -- check if combatant is in combat
    return combatant and combatant.components.combat and combatant.components.combat.target
end

bpx.AddComponentAction("SCENE", "ttb_pet", function(inst, doer, actions, right)
  if right and inst.replicas.combat and inst.replicas.combat.target then
      table.insert(actions, GLOBAL.ACTIONS.TTB_RETREAT)
  end
end)


bpx.AddStategraphActionHandler("wilson",ActionHandler(TTB_STAYHERE))
bpx.AddStategraphActionHandler("wilson_client",ActionHandler(TTB_STAYHERE))
bpx.AddStategraphActionHandler("wilson",ActionHandler(TTB_FOLLOW))
bpx.AddStategraphActionHandler("wilson_client",ActionHandler(TTB_FOLLOW))
