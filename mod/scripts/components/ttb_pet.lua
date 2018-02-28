-- local ACTIONS = GLOBAL.ACTIONS

local TTB_Pet = Class(function(self, inst)
    self.inst = inst
end)

function TTB_Pet:GetDebugString()
    return "TTB_Pet"
end

-- function TTB_Pet:CollectSceneActions(doer, actions, right)
--     if right and self.inst.components.follower and self.inst.components.follower.leader == doer then
--         table.insert(actions, ACTIONS.TTB_STAYHERE)
--     end
--     if right and self.inst.components.follower and self.inst.components.follower.leader == nil then
--         table.insert(actions, ACTIONS.TTB_FOLLOW)
--     end
--     if right and self.inst.components.combat and self.inst.components.combat.target then
--         table.insert(actions, ACTIONS.TTB_RETREAT)
--     end
-- end

bpx.AddComponentAction("SCENE", "ttb_pet", function(doer, actions, right)
  -- if right and self.inst.components.follower and self.inst.components.follower.leader == doer then
  --     table.insert(actions, ACTIONS.TTB_STAYHERE)
  -- end
end)
-- bpx.AddComponentAction("SCENE", "ttb_pet", function(doer, actions, right)
--   if right and self.inst.components.follower and self.inst.components.follower.leader == nil then
--       table.insert(actions, ACTIONS.TTB_FOLLOW)
--   end
-- end)
-- bpx.AddComponentAction("SCENE", "ttb_pet", function(doer, actions, right)
--   if right and self.inst.components.combat and self.inst.components.combat.target then
--       table.insert(actions, ACTIONS.TTB_RETREAT)
--   end
-- end)
bpx.EnableBackCompatibleActions("TTB_Pet")

return TTB_Pet
