
local BASE_URL = "https://raw.githubusercontent.com/skilldown123za/skilldown/main/"

_G.JAYJAY_EnablePrint = false

local oldPrint = print
print = function(...)
    if _G.JAYJAY_EnablePrint then
        oldPrint(...)
    end
end

print(" Loading JAYJAY HUB...")
_G.JAYJAY_Cache = _G.JAYJAY_Cache or {}

local function GetScript(path)
    local fullPath = BASE_URL .. path
    if _G.JAYJAY_Cache[fullPath] then
        return _G.JAYJAY_Cache[fullPath]
    end
    local script = game:HttpGet(fullPath)
    _G.JAYJAY_Cache[fullPath] = script
    return script
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
loadstring(GetScript("Config.lua"))()

Loading.Update(10)
loadstring(GetScript("UI.lua"))()

Loading.Update(12)
loadstring(GetScript("Components.lua"))()
Loading.Update(15)
loadstring(GetScript("Features/SpeedLock.lua"))()
Loading.Update(18)
print(" Running Speed Check...")
task.wait(1.5)

if _G.JAYJAY_SpeedLock then
    _G.JAYJAY_SpeedLock.RunCheck()
    _G.JAYJAY_IsSpeedUnlocked = _G.JAYJAY_SpeedLock.IsUnlocked()
end
Loading.Update(25)
loadstring(GetScript("Tabs/Init.lua"))()
Loading.Update(28)
loadstring(GetScript("Features/AntiAFK.lua"))()

Loading.Update(30)

Loading.Update(33)
loadstring(GetScript("Features/AntiTrap.lua"))()

Loading.Update(36)
loadstring(GetScript("Features/GodMode.lua"))()
Loading.Update(39)
loadstring(GetScript("Features/TeleportSystem.lua"))()

Loading.Update(42)
loadstring(GetScript("Features/AutoFarm.lua"))()

Loading.Update(45)
loadstring(GetScript("Features/AutoAttack.lua"))()

Loading.Update(48)
loadstring(GetScript("Features/AFKSystem.lua"))()
Loading.Update(52)
loadstring(GetScript("Features/FarmingManager.lua"))()

Loading.Update(56)

Loading.Update(58)

Loading.Update(60)
loadstring(GetScript("Features/ManualFastClick.lua"))()

Loading.Update(61)
loadstring(GetScript("Features/DropEgg.lua"))()

Loading.Update(62)
loadstring(GetScript("Features/AntiGuard.lua"))()

Loading.Update(63)
loadstring(GetScript("Features/ConfigSystem.lua"))()
Loading.Update(65)
loadstring(GetScript("Tabs/Info.lua"))()

Loading.Update(68)
loadstring(GetScript("Tabs/Farming.lua"))()

Loading.Update(70)
loadstring(GetScript("Tabs/Combat.lua"))()

Loading.Update(73)
loadstring(GetScript("Tabs/AutoFarming.lua"))()

Loading.Update(76)
loadstring(GetScript("Tabs/Event.lua"))()

Loading.Update(80)
loadstring(GetScript("Tabs/HopServer.lua"))()

Loading.Update(85)
loadstring(GetScript("Tabs/Setting.lua"))()

Loading.Update(88)
loadstring(GetScript("Tabs/CollectEggNew.lua"))()

Loading.Update(90)
loadstring(GetScript("Tabs/ESP.lua"))()
Loading.Update(91)
loadstring(GetScript("Tabs/MapSettings.lua"))()
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
loadstring(GetScript("Features/BypassAntiCheat.lua"))()


Loading.Update(100)

task.wait(0.3)
Loading.Destroy()
print(" Loading Screen Closed!")
print(" JAYJAY HUB | Ready!")
print(" Speed:", _G.JAYJAY_IsSpeedUnlocked and " UNLOCKED" or " LOCKED")
print(" MapSettings:", _G.JAYJAY_MapSettings and " LOADED" or " NOT LOADED")
print(" Sound:", _G.JAYJAY_Sound and " LOADED" or " NOT LOADED")
