-- prefab example
local function fn()
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()   
	inst.entity:AddNetwork()   
	MakeInventoryPhysics(inst)   
	inst.AnimState:SetBank("spear")   
	inst.AnimState:SetBuild("spear")   
	inst.AnimState:PlayAnimation("idle")       
	inst:AddTag("sharp")   
	if not TheWorld.ismastersim then
		return inst
	end
	inst.entity:SetPristine()   
	inst:AddComponent("weapon")   
	inst.components.weapon:SetDamage(TUNING.SPEAR_DAMAGE)
	-------       
	inst:AddComponent("finiteuses")   
	inst.components.finiteuses:SetMaxUses(TUNING.SPEAR_USES)   
	inst.components.finiteuses:SetUses(TUNING.SPEAR_USES)       
	inst.components.finiteuses:SetOnFinished(inst.Remove)   
	inst:AddComponent("inspectable")       
	inst:AddComponent("inventoryitem")       
	inst:AddComponent("equippable")   
	inst.components.equippable:SetOnEquip(onequip)   
	inst.components.equippable:SetOnUnequip(onunequip)   
	MakeHauntableLaunch(inst)       
	return inst
end

-- RPC example
--This is the function we'll call remotely to do it's thing, in this case make you giant!
local function GrowGiant(player)	
	player.Transform:SetScale(2,2,2)
end
--This adds the handler, which means that if the server gets told "GrowGiant",
-- it will call our function, GrowGiant, 
aboveAddModRPCHandler(modname, "GrowGiant", GrowGiant)
--This has it send the RPC to the server when you press "v"
local function SendGrowGiantRPC()
	SendModRPCToServer(MOD_RPC[modname]["GrowGiant"])
end
--This just uses keycodes, which you can look up online. This one is "v".
GLOBAL.TheInput:AddKeyDownHandler(118, SendGrowGiantRPC)


-- actions
local function spearthrow_point(inst, doer, pos, actions, right)
	if right then
		local target = nil
		local cur_time = GLOBAL.GetTime()
		if RANGE_CHECK then
			for k,v in pairs(GLOBAL.TheSim:FindEntities(pos.x, pos.y, pos.z, 2)) do
				if v.replica and v.replica.combat and v.replica.combat:CanBeAttacked(doer)
					and doer.replica and doer.replica.combat and doer.replica.combat:CanTarget(v)
					and (not v:HasTag("wall")) and (pvp or ((not pvp)
					and (not (doer:HasTag("player") and v:HasTag("player"))))) then
					target = v
					break
				end
			end
		end
		if target or not RANGE_CHECK then
			table.insert(actions, GLOBAL.ACTIONS.SPEARTHROW)
		end
	end
end
AddComponentAction("POINT", "spearthrowable", spearthrow_point)
local function spearthrow_target(inst, doer, target, actions, right)
	local pvp = GLOBAL.TheNet:GetPVPEnabled()
	local cur_time = GLOBAL.GetTime()
	if right and (not target:HasTag("wall"))
		and doer.replica.combat ~= nil
		and doer.replica.combat:CanTarget(target)
		and target.replica.combat:CanBeAttacked(doer)
		and (pvp or ((not pvp)
		and (not (doer:HasTag("player") and target:HasTag("player")))))	then
		table.insert(actions, GLOBAL.ACTIONS.SPEARTHROW)
	end
end
AddComponentAction("EQUIPPED", "spearthrowable", spearthrow_target)
