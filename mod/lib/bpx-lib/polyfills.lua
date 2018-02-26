--[[
  Wrap many of Don't Starve and Don't Starve Together's mod APIs so that they
  will work as expected in all verions of Don't Starve.

  Supported versions: DS, DST, ROG, SW
]]

_G = _G or GLOBAL
local require = _G.require
local TheSim = _G.TheSim

local pf = {}

pf.GetModConfigData = function(optionname, get_local_config)
  if TheSim:GetGameID() == "DS" then
    if get_local_config == true then
      print("Warning ["..modname.."]: GetModConfigData with get_local_config=true is not supported in DS")
    end
    return _G.GetModConfigData(optionname)
  end
  -- DST
  return _G.GetModConfigData(optionname, get_local_config)
end

pf.AddLevel = _G.AddLevel
pf.AddRoom = _G.AddRoom
pf.AddTask = _G.AddTask

pf.TaskSetPreInit = function(...)
  if TheSim:GetGameID() == "DS" then
    print("Warning ["..modname.."]: TaskSetPreInit is not supported in DS.")
  else
    _G.TaskSetPreInit(...)
  end
end

pf.TaskSetPreInitAny = function(...)
  if TheSim:GetGameID() == "DS" then
    print("Warning ["..modname.."]: TaskSetPreInitAny is not supported in DS.")
  else
    _G.TaskSetPreInitAny(...)
  end
end

pf.AddLocation = function(...)
  if TheSim:GetGameID() == "DS" then
    print("Warning ["..modname.."]: AddLocation is not supported in DS.")
  else
    _G.AddLocation(...)
  end
end

pf.AddTaskSet = function(...)
  if TheSim:GetGameID() == "DS" then
    print("Warning ["..modname.."]: AddTaskSet is not supported in DS.")
  else
    _G.AddTaskSet(...)
  end
end

pf.AddStartLocation = function(...)
  if TheSim:GetGameID() == "DS" then
    print("Warning ["..modname.."]: AddStartLocation is not supported in DS.")
  else
    _G.AddStartLocation(...)
  end
end

pf.AddTaskPreInit = _G.AddTaskPreInit
pf.AddRoomPreInit = _G.AddRoomPreInit
pf.AddLevelPreInitAny = _G.AddLevelPreInitAny
pf.AddLevelPreInit = _G.AddLevelPreInit

-- Split for worldgen here
-- We do not have a straightforward flag to check for, but variable will work
-- for DS and DST. See scripts/mods.lua CreateEnvironment for where it is set
if _G.CHARACTERLIST == nil then
  return pf
end

pf.AddMinimapAtlas = _G.AddMinimapAtlas
pf.AddStategraphActionHandler = _G.AddStategraphActionHandler
pf.AddStategraphState = _G.AddStategraphState
pf.AddStategraphEvent = _G.AddStategraphEvent
pf.AddStategraphPostInit = _G.AddStategraphPostInit
pf.AddComponentPostInit = _G.AddComponentPostInit
pf.AddPrefabPostInitAny = _G.AddPrefabPostInitAny
pf.AddPlayerPostInit = _G.AddPlayerPostInit
pf.AddAddPrefabPostInitLevel = _G.AddPrefabPostInit
pf.AddBrainPostInit = _G.AddBrainPostInit
pf.AddIngredientValues = _G.AddIngredientValues
pf.AddCookerRecipe = _G.AddCookerRecipe
pf.LoadPOFile = _G.LoadPOFile
pf.RemapSoundEvent = _G.RemapSoundEvent

pf.AddAction = function( id, str, fn )
  if TheSim:GetGameID() == "DS" then
    local action = {
      id = id,
      str = str,
      fn = fn
    }
    _G.AddAction(action)
  else
    _G.AddAction(id, str, fn)
  end
end

-- Need to do this
pf.AddComponentAction = function(actiontype, component, fn)
  if TheSim:GetGameID() == "DS" then
    local comp = require("components/"..component)
    if comp.BPX_COMPONENT_ACTIONS == nil then
      comp.BPX_COMPONENT_ACTIONS = {}
    end

    if comp.BPX_COMPONENT_ACTIONS[actiontype] == nil then
      comp.BPX_COMPONENT_ACTIONS.actiontype = {}
    end

    table.insert(comp.BPX_COMPONENT_ACTIONS.actiontype, fn)
  else
    _G.AddComponentAction(actiontype, component, fn)
  end
end

pf.EnableBackCompatibleActions = function(package)
  if TheSim:GetGameID() == "DS" then
    _G.AddClassPostConstruct(package, function(self)
      function self:CollectSceneActions(doer, actions, right)
        for _,func in pairs(self.BPX_COMPONENT_ACTIONS.SCENE) do
          func(self, doer, actions, right)
        end
      end

      function self:CollectUseItemActions(doer, target, actions, right)
        for _,func in pairs(self.BPX_COMPONENT_ACTIONS.USEITEM) do
          func(self, doer, target, actions, right)
        end
      end

      function self:CollectPointActions(doer, pos, actions, right)
        for _,func in pairs(self.BPX_COMPONENT_ACTIONS.POINT) do
          func(self, doer, pos, actions, right)
        end
      end

      function self:CollectEquippedActions(doer, target, actions, right)
        for _,func in pairs(self.BPX_COMPONENT_ACTIONS.EQUIPPED) do
          func(self, doer, target, actions, right)
        end
      end

      function self:CollectInventoryActions(doer, actions, right)
        for _,func in pairs(self.BPX_COMPONENT_ACTIONS.INVENTORY) do
          func(self, doer, actions, right)
        end
      end

      function self:CollectIsValidActions(action, right)
        for _,func in pairs(self.BPX_COMPONENT_ACTIONS.ISVALID) do
          func(self, action, right)
        end
      end
    end)
  end
  -- No effect for DST
end

pf.AddModCharacter = function(name, gender)
  if TheSim:GetGameID() == "DS" then
    if gender ~= nil then
      print("Warning ["..modname.."]: AddModCharacter with gender is supported in DS, adding anyways.")
    end
    _G.AddModCharacter(name)
  else
    _G.AddModCharacter(name, gender)
  end
end

pf.RemoveDefaultCharacter = function(...)
  if TheSim:GetGameID() == "DS" then
    print("Warning ["..modname.."]: RemoveDefaultCharacter is not supported in DS.")
  else
    _G.RemoveDefaultCharacter(...)
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
    _G.AddSimPostInit(function(inst)
      local rec = nil
      if _G.SaveGameIndex:IsModeShipwrecked() then
        rec = _G.Recipe(recname, ingredients, tab, level, game_type, placer, min_spacing, nounlock, numtogive, aquatic, distance)
      else
        rec = _G.Recipe(recname, ingredients, tab, level, placer, min_spacing, nounlock, numtogive)
      end
      rec.atlas = atlas or resolvefilepath("images/inventoryimages.xml")
      rec.image = image or recname .. ".tex"
      return rec
    end)
  else
    -- DST
    return _G.AddRecipe(recname, ingredients, tab, level, placer, min_spacing, nounlock, numtogive, builder_tag, atlas, image, testfn)
  end
end

pf.AddRecipeTab = function( rec_str, rec_sort, rec_atlas, rec_icon, rec_owner_tag, rec_crafting_station )
  if TheSim:GetGameID() == "DS" then
    _G.RECIPETABS[rec_str] = { str = rec_str, sort = rec_sort, icon_atlas = rec_atlas, icon = rec_icon, crafting_station = rec_crafting_station }
    _G.STRINGS.TABS[rec_str] = rec_str
    return _G.RECIPETABS[rec_str]
  else
    return _G.AddRecipeTab(rec_str, rec_sort, rec_atlas, rec_icon, rec_owner_tag, rec_crafting_station)
  end
end

pf.AddReplicableComponent = function(...)
  if TheSim:GetGameID() == "DS" then
    print("Warning ["..modname.."]: AddReplicableComponent is not supported in DS.")
  else
    return _G.AddReplicableComponent(...)
  end
end

pf.AddModRPCHandler = function(...)
  if TheSim:GetGameID() == "DS" then
    print("Warning ["..modname.."]: AddModRPCHandler is not supported in DS.")
  else
    _G.AddModRPCHandler(...)
  end
end

pf.GetModRPCHandler = function(...)
  if TheSim:GetGameID() == "DS" then
    print("Warning ["..modname.."]: GetModRPCHandler is not supported in DS.")
  else
    return _G.GetModRPCHandler(...)
  end
end

pf.SendModRPCToServer = function(...)
  if TheSim:GetGameID() == "DS" then
    print("Warning ["..modname.."]: SendModRPCToServer is not supported in DS.")
  else
    _G.SendModRPCToServer(...)
  end
end

pf.GetModRPC = function(...)
  if TheSim:GetGameID() == "DS" then
    print("Warning ["..modname.."]: GetModRPC is not supported in DS.")
  else
    return _G.GetModRPC(...)
  end
end

pf.SetModHUDFocus = function(...)
  if TheSim:GetGameID() == "DS" then
    print("Warning ["..modname.."]: SetModHUDFocus is not supported in DS.")
  else
    _G.SetModHUDFocus(...)
  end
end

pf.AddUserCommand = function(...)
  if TheSim:GetGameID() == "DS" then
    print("Warning ["..modname.."]: AddUserCommand is not supported in DS.")
  else
    _G.AddUserCommand(...)
  end
end

pf.AddVoteCommand = function(...)
  if TheSim:GetGameID() == "DS" then
    print("Warning ["..modname.."]: AddVoteCommand is not supported in DS.")
  else
    _G.AddVoteCommand(...)
  end
end

pf.ExcludeClothingSymbolForModCharacter = function(...)
  if TheSim:GetGameID() == "DS" then
    print("Warning ["..modname.."]: ExcludeClothingSymbolForModCharacter is not supported in DS.")
  else
    _G.ExcludeClothingSymbolForModCharacter(...)
  end
end

return pf
