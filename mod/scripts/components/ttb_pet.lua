-- Container component to attach StayHere, Follow, and Retreat actions
local TTB_Pet = Class(function(self, inst)
    self.inst = inst
end)

function TTB_Pet:GetDebugString()
    return "TTB_Pet"
end

return TTB_Pet
