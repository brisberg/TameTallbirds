--[[
  Wrap many of Don't Starve and Don't Starve Together's mod APIs so that they
  will work as expected in all verions of Don't Starve.

  Supported versions: DS, DST, ROG, SW
]]

-- for key, _ in ipairs(_G) do
--     print(key)
-- end

_G = _G or GLOBAL
local require = _G.require
local TheSim = _G.TheSim

local function loadfn(env)
  local pf = {}

  pf.GetModConfigData = function(optionname, get_local_config)
    if TheSim:GetGameID() == "DS" then
      if get_local_config == true then
        print("Warning ["..modname.."]: GetModConfigData with get_local_config=true is not supported in DS")
      end
      return env.GetModConfigData(optionname)
    end
    -- DST
    return env.GetModConfigData(optionname, get_local_config)
  end

  pf.AddLevel = env.AddLevel
  pf.AddRoom = env.AddRoom
  pf.AddTask = env.AddTask

  pf.TaskSetPreInit = function(...)
    if TheSim:GetGameID() == "DS" then
      print("Warning ["..modname.."]: TaskSetPreInit is not supported in DS.")
    else
      env.TaskSetPreInit(...)
    end
  end

  pf.TaskSetPreInitAny = function(...)
    if TheSim:GetGameID() == "DS" then
      print("Warning ["..modname.."]: TaskSetPreInitAny is not supported in DS.")
    else
      env.TaskSetPreInitAny(...)
    end
  end

  pf.AddLocation = function(...)
    if TheSim:GetGameID() == "DS" then
      print("Warning ["..modname.."]: AddLocation is not supported in DS.")
    else
      env.AddLocation(...)
    end
  end

  pf.AddTaskSet = function(...)
    if TheSim:GetGameID() == "DS" then
      print("Warning ["..modname.."]: AddTaskSet is not supported in DS.")
    else
      env.AddTaskSet(...)
    end
  end

  pf.AddStartLocation = function(...)
    if TheSim:GetGameID() == "DS" then
      print("Warning ["..modname.."]: AddStartLocation is not supported in DS.")
    else
      env.AddStartLocation(...)
    end
  end

  pf.AddTaskPreInit = env.AddTaskPreInit
  pf.AddRoomPreInit = env.AddRoomPreInit
  pf.AddLevelPreInitAny = env.AddLevelPreInitAny
  pf.AddLevelPreInit = env.AddLevelPreInit

  -- Split for worldgen here
  -- We do not have a straightforward flag to check for, but variable will work
  -- for DS and DST. See scripts/mods.lua CreateEnvironment for where it is set
  if env.CHARACTERLIST == nil then
    return pf
  end

  pf.AddMinimapAtlas = env.AddMinimapAtlas
  pf.AddStategraphActionHandler = env.AddStategraphActionHandler
  pf.AddStategraphState = env.AddStategraphState
  pf.AddStategraphEvent = env.AddStategraphEvent
  pf.AddStategraphPostInit = env.AddStategraphPostInit
  pf.AddComponentPostInit = env.AddComponentPostInit
  pf.AddPrefabPostInitAny = env.AddPrefabPostInitAny
  pf.AddPlayerPostInit = env.AddPlayerPostInit
  pf.AddAddPrefabPostInitLevel = env.AddPrefabPostInit
  pf.AddBrainPostInit = env.AddBrainPostInit
  pf.AddIngredientValues = env.AddIngredientValues
  pf.AddCookerRecipe = env.AddCookerRecipe
  pf.LoadPOFile = env.LoadPOFile
  pf.RemapSoundEvent = env.RemapSoundEvent

  pf.AddAction = function( id, str, fn )
    if TheSim:GetGameID() == "DS" then
      local action = {
        id = id,
        str = str,
        fn = fn
      }
      env.AddAction(action)
      return action
    else
      return env.AddAction(id, str, fn)
    end
  end

  local function AddActionCollectorFn(actiontype, comp, fn)
    if actiontype == "SCENE" then
      function comp:CollectSceneActions(doer, actions, right)
        self.inst.replica = self.inst.components
        doer.replica = doer.components
        fn(self.inst, doer, actions, right)
        doer.replica = nil
        self.inst.replica = nil
      end
    elseif actiontype == "USEITEM" then
      function comp:CollectUseItemActions(doer, target, actions, right)
        self.inst.replica = self.inst.components
        doer.replica = doer.components
        target.replica = target.components
        fn(self.inst, doer, target, actions, right)
        doer.replica = nil
        target.replica = nil
        self.inst.replica = nil
      end
    elseif actiontype == "POINT" then
      function comp:CollectPointActions(doer, pos, actions, right)
        self.inst.replica = self.inst.components
        doer.replica = doer.components
        target.replica = target.components
        fn(self.inst, doer, pos, actions, right)
        doer.replica = nil
        target.replica = nil
        self.inst.replica = nil
      end
    elseif actiontype == "EQUIPPED" then
      function comp:CollectEquippedActions(doer, target, actions, right)
        self.inst.replica = self.inst.components
        doer.replica = doer.components
        target.replica = target.components
        fn(self.inst, doer, target, actions, right)
        doer.replica = nil
        target.replica = nil
        self.inst.replica = nil
      end
    elseif actiontype == "INVENTORY" then
      function comp:CollectInventoryActions(doer, actions, right)
        self.inst.replica = self.inst.components
        doer.replica = doer.components
        fn(self.inst, doer, actions, right)
        doer.replica = nil
        self.inst.replica = nil
      end
    elseif actiontype == "ISVALID" then
      function comp:CollectIsValidActions(action, right)
        self.inst.replica = self.inst.components
        fn(self.inst, action, right)
        self.inst.replica = nil
      end
    end
  end

  -- Create a custom action collection function on the component for the
  -- specified action.
  pf.AddComponentAction = function(actiontype, component, fn)
    print("polyfill AddComponentAction")
    if TheSim:GetGameID() == "DS" then
      local comp = require("components/"..component)
      print(comp:GetDebugString())
      AddActionCollectorFn(actiontype, comp, fn)
    else
      env.AddComponentAction(actiontype, component, fn)
    end
  end

  pf.AddModCharacter = function(name, gender)
    if TheSim:GetGameID() == "DS" then
      if gender ~= nil then
        print("Warning ["..modname.."]: AddModCharacter with gender is supported in DS, adding anyways.")
      end
      env.AddModCharacter(name)
    else
      env.AddModCharacter(name, gender)
    end
  end

  pf.RemoveDefaultCharacter = function(...)
    if TheSim:GetGameID() == "DS" then
      print("Warning ["..modname.."]: RemoveDefaultCharacter is not supported in DS.")
    else
      env.RemoveDefaultCharacter(...)
    end
  end

  pf.MakePlayerCharacter = function(name, customprefabs, customassets, common_postinit, master_postinit, starting_inventory)
    if TheSim:GetGameID() == "DS" then
      local function fn( ... )
        if common_postinit then
          common_postinit(...)
        end
        if master_postinit then
          master_postinit(...)
        end
      end
      return require("prefabs/player_common")(name, customprefabs, customassets, fn, starting_inventory)
    else
      return require("prefabs/player_common")(name, customprefabs, customassets, common_postinit, master_postinit, starting_inventory)
    end
  end

  pf.AddRecipe = function(recname, ingredients, tab, level, placer, min_spacing, nounlock, numtogive, builder_tag, atlas, image, testfn, game_type, aquatic, distance)
    if TheSim:GetGameID() == "DS" then
      env.AddSimPostInit(function(inst)
        local rec = nil
        if env.SaveGameIndex:IsModeShipwrecked() then
          rec = env.Recipe(recname, ingredients, tab, level, game_type, placer, min_spacing, nounlock, numtogive, aquatic, distance)
        else
          rec = env.Recipe(recname, ingredients, tab, level, placer, min_spacing, nounlock, numtogive)
        end
        rec.atlas = atlas or resolvefilepath("images/inventoryimages.xml")
        rec.image = image or recname .. ".tex"
        return rec
      end)
    else
      -- DST
      return env.AddRecipe(recname, ingredients, tab, level, placer, min_spacing, nounlock, numtogive, builder_tag, atlas, image, testfn)
    end
  end

  pf.AddRecipeTab = function( rec_str, rec_sort, rec_atlas, rec_icon, rec_owner_tag, rec_crafting_station )
    if TheSim:GetGameID() == "DS" then
      env.RECIPETABS[rec_str] = { str = rec_str, sort = rec_sort, icon_atlas = rec_atlas, icon = rec_icon, crafting_station = rec_crafting_station }
      env.STRINGS.TABS[rec_str] = rec_str
      return env.RECIPETABS[rec_str]
    else
      return env.AddRecipeTab(rec_str, rec_sort, rec_atlas, rec_icon, rec_owner_tag, rec_crafting_station)
    end
  end

  pf.AddReplicableComponent = function(...)
    if TheSim:GetGameID() == "DS" then
      print("Warning ["..modname.."]: AddReplicableComponent is not supported in DS.")
    else
      return env.AddReplicableComponent(...)
    end
  end

  pf.AddModRPCHandler = function(...)
    if TheSim:GetGameID() == "DS" then
      print("Warning ["..modname.."]: AddModRPCHandler is not supported in DS.")
    else
      env.AddModRPCHandler(...)
    end
  end

  pf.GetModRPCHandler = function(...)
    if TheSim:GetGameID() == "DS" then
      print("Warning ["..modname.."]: GetModRPCHandler is not supported in DS.")
    else
      return env.GetModRPCHandler(...)
    end
  end

  pf.SendModRPCToServer = function(...)
    if TheSim:GetGameID() == "DS" then
      print("Warning ["..modname.."]: SendModRPCToServer is not supported in DS.")
    else
      env.SendModRPCToServer(...)
    end
  end

  pf.GetModRPC = function(...)
    if TheSim:GetGameID() == "DS" then
      print("Warning ["..modname.."]: GetModRPC is not supported in DS.")
    else
      return env.GetModRPC(...)
    end
  end

  pf.SetModHUDFocus = function(...)
    if TheSim:GetGameID() == "DS" then
      print("Warning ["..modname.."]: SetModHUDFocus is not supported in DS.")
    else
      env.SetModHUDFocus(...)
    end
  end

  pf.AddUserCommand = function(...)
    if TheSim:GetGameID() == "DS" then
      print("Warning ["..modname.."]: AddUserCommand is not supported in DS.")
    else
      env.AddUserCommand(...)
    end
  end

  pf.AddVoteCommand = function(...)
    if TheSim:GetGameID() == "DS" then
      print("Warning ["..modname.."]: AddVoteCommand is not supported in DS.")
    else
      env.AddVoteCommand(...)
    end
  end

  pf.ExcludeClothingSymbolForModCharacter = function(...)
    if TheSim:GetGameID() == "DS" then
      print("Warning ["..modname.."]: ExcludeClothingSymbolForModCharacter is not supported in DS.")
    else
      env.ExcludeClothingSymbolForModCharacter(...)
    end
  end

  -- Shipwrecked stuff
  pf.MakePoisonableCharacter = function(...)
    if TheSim:GetGameID() == "DS" and _G.SaveGameIndex:IsModeShipwrecked() then
      _G.MakePoisonableCharacter(...)
    end
  end

  pf.MakeInventoryFloatable = function(...)
    if TheSim:GetGameID() == "DS" and _G.SaveGameIndex:IsModeShipwrecked() then
      _G.MakeInventoryFloatable(...)
    end
  end

  pf.AddTreasurePreInit = function(...)
    if TheSim:GetGameID() == "DS" and _G.SaveGameIndex:IsModeShipwrecked() then
      env.AddTreasurePreInit(...)
    else
      print("Warning ["..modname.."]: AddTreasurePreInit only supported in Shipwrecked.")
    end
  end

  pf.AddTreasureLootPreInit = function(...)
    if TheSim:GetGameID() == "DS" and _G.SaveGameIndex:IsModeShipwrecked() then
      env.AddTreasureLootPreInit(...)
    else
      print("Warning ["..modname.."]: AddTreasureLootPreInit only supported in Shipwrecked.")
    end
  end

  pf.AddTreasure = function(...)
    if TheSim:GetGameID() == "DS" and _G.SaveGameIndex:IsModeShipwrecked() then
      env.AddTreasure(...)
    else
      print("Warning ["..modname.."]: AddTreasure only supported in Shipwrecked.")
    end
  end

  pf.AddTreasureLoot = function(...)
    if TheSim:GetGameID() == "DS" and _G.SaveGameIndex:IsModeShipwrecked() then
      env.AddTreasureLoot(...)
    else
      print("Warning ["..modname.."]: AddTreasureLoot only supported in Shipwrecked.")
    end
  end

  -- DST polyfills
  pf.CreateEntity = function()
    if TheSim:GetGameID() == "DS" then
      local inst = _G.CreateEntity()
      local entity = getmetatable(inst.entity)
      entity.__index.AddNetwork = function(...) end
      entity.__index.SetPristine = function(...) end
      return inst
    else
      return _G.CreateEntity()
    end
  end

  pf.CreatePrefabSkin = function(name, info)
    if TheSim:GetGameID() == "DS" then
      -- Dummy prefab just to load the skin assets, character prefab will use
      -- assets that match their prefab name by default.
      return Prefab(name, nil, info.assets, info.prefabs)
    else
      return _G.CreatePrefabSkin(name, info)
    end
  end

  -- Hauntables
  if TheSim:GetGameID() == "DS" then
    pf.MakeHauntableLaunch = function(...) end
    pf.MakeHauntableLaunchAndSmash = function(...) end
    pf.MakeHauntableWork = function(...) end
    pf.MakeHauntableWorkAndIgnite = function(...) end
    pf.MakeHauntableFreeze = function(...) end
    pf.MakeHauntableIgnite = function(...) end
    pf.MakeHauntableLaunchAndIgnite = function(...) end
    -- pf.DoChangePrefab = function(...) end
    pf.MakeHauntableChangePrefab = function(...) end
    pf.MakeHauntableLaunchOrChangePrefab = function(...) end
    pf.MakeHauntablePerish = function(...) end
    pf.MakeHauntableLaunchAndPerish = function(...) end
    pf.MakeHauntablePanic = function(...) end
    pf.MakeHauntablePanicAndIgnite = function(...) end
    pf.MakeHauntablePlayAnim = function(...) end
    pf.MakeHauntableGoToState = function(...) end
    pf.MakeHauntableDropFirstItem = function(...) end
    pf.MakeHauntableLaunchAndDropFirstItem = function(...) end
    pf.AddHauntableCustomReaction = function(...) end
    pf.AddHauntableDropItemOrWork = function(...) end
  else
    pf.MakeHauntableLaunch = _G.MakeHauntableLaunch
    pf.MakeHauntableLaunchAndSmash = _G.MakeHauntableLaunchAndSmash
    pf.MakeHauntableWork = _G.MakeHauntableWork
    pf.MakeHauntableWorkAndIgnite = _G.MakeHauntableWorkAndIgnite
    pf.MakeHauntableFreeze = _G.MakeHauntableFreeze
    pf.MakeHauntableIgnite = _G.MakeHauntableIgnite
    pf.MakeHauntableLaunchAndIgnite = _G.MakeHauntableLaunchAndIgnite
    -- pf.DoChangePrefab = _G.DoChangePrefab
    pf.MakeHauntableChangePrefab = _G.MakeHauntableChangePrefab
    pf.MakeHauntableLaunchOrChangePrefab = _G.MakeHauntableLaunchOrChangePrefab
    pf.MakeHauntablePerish = _G.MakeHauntablePerish
    pf.MakeHauntableLaunchAndPerish = _G.MakeHauntableLaunchAndPerish
    pf.MakeHauntablePanic = _G.MakeHauntablePanic
    pf.MakeHauntablePanicAndIgnite = _G.MakeHauntablePanicAndIgnite
    pf.MakeHauntablePlayAnim = _G.MakeHauntablePlayAnim
    pf.MakeHauntableGoToState = _G.MakeHauntableGoToState
    pf.MakeHauntableDropFirstItem = _G.MakeHauntableDropFirstItem
    pf.MakeHauntableLaunchAndDropFirstItem = _G.MakeHauntableLaunchAndDropFirstItem
    pf.AddHauntableCustomReaction = _G.AddHauntableCustomReaction
    pf.AddHauntableDropItemOrWork = _G.AddHauntableDropItemOrWork
  end

  pf.SpringCombatMod = function(amount)
    if TheSim:GetGameID() == "DS" then
      if GetSeasonManager() then
          if (IsDLCEnabled(REIGN_OF_GIANTS) and GetSeasonManager():IsSpring()) or (IsDLCEnabled(CAPY_DLC) and GetSeasonManager():IsGreenSeason()) then
              return amount * TUNING.SPRING_COMBAT_MOD
          end
      else
          return amount
      end
    else
      return _G.SpringCombatMod(amount)
    end
  end

  -- Component APIs
  if TheSim:GetGameID() == "DS" then
    env.AddComponentPostInit("follower", function(self, inst)
      function self:GetLeader()
        -- print("GetLeader called")
        return self.leader
      end
    end)
    env.AddComponentPostInit("combat", function(self, inst)
      function self:GetTarget()
        -- print("GetTarget called")
        return self.target
      end
    end)
    env.AddComponentPostInit("eater", function(self, inst)
      function self:SetDiet(foodgrouplist, ...)
        local foodprefs = {}
        for _,foodgroup in ipairs(foodgrouplist) do
            for i=1,#foodgroup do
              foodprefs[#foodprefs+1] = foodgroup[i]
          end
        end
        self.foodprefs = foodprefs
      end
    end)
    global("FOODGROUP")
    _G.FOODGROUP = {
      OMNI = { "MEAT", "VEGGIE", "INSECT", "SEEDS", "GENERIC" }
    }
    global("TheWorld")
    _G.TheWorld = {
      ismastersim = true
    }
  end

  -- GLOBAL.global('pfv')
  -- _G.pfv = pf
  return pf
end

return loadfn
