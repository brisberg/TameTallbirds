function tweak_smallbird(inst)
    local OldSpawnTeen = inst.userfunctions.SpawnTeen
    function inst.userfunctions.SpawnTeen(inst)
        OldSpawnTeen(inst)
        inst.components.follower.leader.components.leader:RemoveFollower(inst)
    end
end

return tweak_smallbird
