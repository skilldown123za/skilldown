local BASE_URL = "https://raw.githubusercontent.com/skilldown123za/skilldown/main/"

_G.JAYJAY_EnablePrint = false

local oldPrint = print
getgenv().print = function(...)
    if _G.JAYJAY_EnablePrint then
        oldPrint(...)
    end
end

print(" Loading JAYJAY HUB...")
_G.JAYJAY_Cache = {}

local function GetScript(path)
    local fullPath = BASE_URL .. path
    if _G.JAYJAY_Cache[fullPath] then
        return _G.JAYJAY_Cache[fullPath]
    end
    local script = game:HttpGet(fullPath)
    _G.JAYJAY_Cache[fullPath] = script
    return script
end

local function LoadScript(path)
    local code = GetScript(path)
    local func, err = loadstring(code)
    
    if not func then
        warn("❌ JAYJAY HUB Error! Failed to load: " .. path)
        warn("❌ Syntax Error: " .. tostring(err))
        return
    end
    
    -- Share executor's global environment so globals like CreateTab/CreatePage
    -- are visible across all loadstring chunks
    pcall(function()
        if setfenv then
            setfenv(func, getfenv(0))
        end
    end)
    
    local success, runErr = pcall(func)
    if not success then
        warn("❌ JAYJAY HUB Error! Failed to execute: " .. path)
        warn("❌ Runtime Error: " .. tostring(runErr))
    else
        warn("✅ JAYJAY: Loaded " .. path)
    end
end
repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer

local Player = game.Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

print(" Game loaded, Player: " .. Player.Name)
local function CreateLoadingScreen()
    local function UpdateProgress(percent)
    end

    return {
        Gui = nil,
        Update = UpdateProgress,
        Destroy = function()
        end
    }
end

local Loading = CreateLoadingScreen()
Loading.Update(5)
Loading.Update(8)
LoadScript("Config.lua")

Loading.Update(10)
LoadScript("UI.lua")

Loading.Update(12)
LoadScript("Components.lua")
Loading.Update(15)
LoadScript("Features/SpeedLock.lua")
Loading.Update(18)
print(" Running Speed Check...")
task.wait(1.5)

if _G.JAYJAY_SpeedLock then
    _G.JAYJAY_SpeedLock.RunCheck()
    _G.JAYJAY_IsSpeedUnlocked = _G.JAYJAY_SpeedLock.IsUnlocked()
end
Loading.Update(25)
LoadScript("Tabs/Init.lua")
Loading.Update(28)
LoadScript("Features/AntiAFK.lua")

Loading.Update(30)

Loading.Update(33)
LoadScript("Features/AntiTrap.lua")

Loading.Update(36)
LoadScript("Features/GodMode.lua")
Loading.Update(39)
LoadScript("Features/TeleportSystem.lua")

Loading.Update(42)
LoadScript("Features/AutoFarm.lua")

Loading.Update(45)
LoadScript("Features/AutoAttack.lua")

Loading.Update(48)
LoadScript("Features/AFKSystem.lua")
Loading.Update(52)
LoadScript("Features/FarmingManager.lua")

Loading.Update(56)

Loading.Update(58)

Loading.Update(60)
LoadScript("Features/ManualFastClick.lua")

Loading.Update(61)
LoadScript("Features/DropEgg.lua")

Loading.Update(62)
LoadScript("Features/AntiGuard.lua")

Loading.Update(63)
LoadScript("Features/ConfigSystem.lua")
Loading.Update(65)
LoadScript("Tabs/Info.lua")

Loading.Update(68)
LoadScript("Tabs/Farming.lua")

Loading.Update(70)
LoadScript("Tabs/Combat.lua")

Loading.Update(73)
LoadScript("Tabs/AutoFarming.lua")

Loading.Update(76)
LoadScript("Tabs/Event.lua")

Loading.Update(80)
LoadScript("Tabs/HopServer.lua")

Loading.Update(85)
LoadScript("Tabs/Setting.lua")

Loading.Update(88)
LoadScript("Tabs/CollectEggNew.lua")

Loading.Update(90)
LoadScript("Tabs/ESP.lua")
Loading.Update(91)
LoadScript("Tabs/MapSettings.lua")
Loading.Update(92)
task.spawn(function()
    task.wait(0.5)
    
    if _G.JAYJAY_SpeedLock then
        if _G.JAYJAY_FarmButton then
            _G.JAYJAY_SpeedLock.RegisterLockable(_G.JAYJAY_FarmButton, "Farm")
            print(" Registered FarmButton")
        else
            warn(" _G.JAYJAY_FarmButton not found!")
        end
        
        if _G.JAYJAY_GetEggCheckButton then
            _G.JAYJAY_SpeedLock.RegisterLockable(_G.JAYJAY_GetEggCheckButton, "GetEgg")
            print(" Registered GetEggCheckButton")
        else
            warn(" _G.JAYJAY_GetEggCheckButton not found!")
        end
        
        task.wait(0.3)
        if not _G.JAYJAY_SpeedLock.IsUnlocked() then
            _G.JAYJAY_SpeedLock.ApplyLock()
            print(" Re-applied Lock")
        end
    end
end)
Loading.Update(94)
if _G.JAYJAY_TabsManager then
    _G.JAYJAY_TabsManager:SelectTabByName("Info")
end

Loading.Update(95)
Loading.Update(96)
LoadScript("Features/BypassAntiCheat.lua")


Loading.Update(100)

task.wait(0.3)
Loading.Destroy()
print(" Loading Screen Closed!")
print(" JAYJAY HUB | Ready!")
print(" Speed:", _G.JAYJAY_IsSpeedUnlocked and " UNLOCKED" or " LOCKED")
print(" MapSettings:", _G.JAYJAY_MapSettings and " LOADED" or " NOT LOADED")
print(" Sound:", _G.JAYJAY_Sound and " LOADED" or " NOT LOADED")
