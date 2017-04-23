
local function SpawnTameAdult(inst)
    --print("TameTallbirds - SpawnTameAdult called")

    local tamebird = SpawnPrefab("tametallbird")
    -- local tamebird = SpawnPrefab("spider")
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
        -- SpawnTameAdult(inst)
        if
            inst.components.follower
            and inst.components.follower.leader
            and inst.components.follower.leader:HasTag("player") then
            -- We are a teen following a player, spawn a tame adult
            SpawnTameAdult(inst)
        else
            -- We are a wild bird, spawn normal adult
            SpawnNormalAdult(inst)
        end
    end
end

return tweak_teenbird
