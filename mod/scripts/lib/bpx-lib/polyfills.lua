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
    else
      env.AddAction(id, str, fn)
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
      env.AddComponentAction(actiontype, component, fn)
    end
  end

  pf.EnableBackCompatibleActions = function(package)
    if TheSim:GetGameID() == "DS" then
      env.AddClassPostConstruct(package, function(self)
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

  -- GLOBAL.global('pfv')
  -- _G.pfv = pf
  return pf
end

return loadfn
