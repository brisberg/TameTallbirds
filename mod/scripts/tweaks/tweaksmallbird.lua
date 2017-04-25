function tweak_smallbird(inst)
    local OldSpawnTeen = inst.userfunctions.SpawnTeen
    function inst.userfunctions.SpawnTeen(inst)
        OldSpawnTeen(inst)
        if inst.components.follower and inst.components.follower.leader then
            local leader = inst.components.follower.leader
            if leader.components.leader then
                leader.components.leader:RemoveFollower(inst)
            end
        end
    end
end

return tweak_smallbird
