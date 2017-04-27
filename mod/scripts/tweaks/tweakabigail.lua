function tweak_abigail(inst)
    local function OnNewTarget(inst, data)
        --print("abigail - OnNewTarget", data.target)
        if data.target then
            if data.target:HasTag("tametallbird")
                and data.target.components.follower
                and inst.components.follower
                and data.target.components.follower.leader == inst.components.follower.leader then
                inst.components.combat:SetTarget(nil)
            end
        end
    end

    inst:ListenForEvent("newcombattarget", OnNewTarget)
end

return tweak_abigail
