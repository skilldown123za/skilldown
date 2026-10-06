local BASE_URL = "https://raw.githubusercontent.com/skilldown123za/skilldown/main/"

-- Cache buster ensures fresh files are always fetched from GitHub (bypasses 5-min CDN cache)
local CACHE_BUSTER = "?t=" .. tostring(os.time())

_G.JAYJAY_Cache = {}

local function GetScript(path)
    local fullPath = BASE_URL .. path
    if _G.JAYJAY_Cache[fullPath] then
        return _G.JAYJAY_Cache[fullPath]
    end
    
    local script = nil
    -- Try with cache-buster first to avoid stale GitHub raw CDN
    local success, res = pcall(function()
        return game:HttpGet(fullPath .. CACHE_BUSTER)
    end)
    if success and res and res ~= "" then
        script = res
    else
        -- Fallback without query param
        local s2, r2 = pcall(function()
            return game:HttpGet(fullPath)
        end)
        if s2 and r2 and r2 ~= "" then
            script = r2
        end
    end

    if script and script ~= "" then
        _G.JAYJAY_Cache[fullPath] = script
        return script
    end

    warn("❌ JAYJAY HUB: Failed to HttpGet: " .. path)
    return nil
end

local baseGenv = (getgenv and type(getgenv) == "function" and getgenv()) or getfenv(0)

local function LoadScript(path)
    local code = GetScript(path)
    if not code then
        warn("❌ JAYJAY HUB: Could not fetch " .. path)
        return false
    end
    
    local func, err = loadstring(code)
    if not func then
        warn("❌ JAYJAY HUB Syntax Error in " .. path .. ": " .. tostring(err))
        return false
    end
    
    -- Inject environment metatable so all globals (_G, getgenv, chunk) are seamlessly shared
    pcall(function()
        if setfenv then
            local chunkEnv = setmetatable({}, {
                __index = function(_, k)
                    if k == "_G" then return _G end
                    if baseGenv and baseGenv[k] ~= nil then return baseGenv[k] end
                    if _G[k] ~= nil then return _G[k] end
                    return getfenv(0)[k]
                end,
                __newindex = function(_, k, v)
                    if baseGenv then baseGenv[k] = v end
                    _G[k] = v
                end
            })
            setfenv(func, chunkEnv)
        end
    end)
    
    local success, runErr = pcall(func)
    if not success then
        warn("❌ JAYJAY HUB Runtime Error in " .. path .. ": " .. tostring(runErr))
        return false
    else
        print("✅ JAYJAY: Loaded " .. path)
        return true
    end
end

repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer
local Player = game.Players.LocalPlayer

print("🚀 Loading JAYJAY HUB...")

-- ==================================================
-- 1. LOAD CORE & UI
-- ==================================================
LoadScript("Config.lua")
LoadScript("UI.lua")
LoadScript("Components.lua")
LoadScript("Tabs/Init.lua")

-- ==================================================
-- 2. BUILD ALL TABS IMMEDIATELY (Render UI Menus First)
-- ==================================================
print("📑 Building Tabs...")
LoadScript("Tabs/Info.lua")
LoadScript("Tabs/Farming.lua")
LoadScript("Tabs/Combat.lua")
LoadScript("Tabs/Event.lua")
LoadScript("Tabs/HopServer.lua")
LoadScript("Tabs/Setting.lua")
LoadScript("Tabs/CollectEggNew.lua")
LoadScript("Tabs/ESP.lua")
LoadScript("Tabs/MapSettings.lua")

-- Select default tab (Info)
task.wait(0.1)
if _G.JAYJAY_TabsManager then
    _G.JAYJAY_TabsManager:SelectTabByName("Info")
end
print("✅ JAYJAY HUB: Menus & Tabs Ready!")

-- ==================================================
-- 3. LOAD FEATURES IN BACKGROUND (Won't block UI)
-- ==================================================
task.spawn(function()
    print("⚙️ Loading Features in background...")
    
    -- SpeedLock
    LoadScript("Features/SpeedLock.lua")
    if _G.JAYJAY_SpeedLock then
        pcall(function()
            _G.JAYJAY_SpeedLock.RunCheck()
            _G.JAYJAY_IsSpeedUnlocked = _G.JAYJAY_SpeedLock.IsUnlocked()
        end)
    end
    
    -- Core Features
    LoadScript("Features/AntiAFK.lua")
    LoadScript("Features/AntiTrap.lua")
    LoadScript("Features/GodMode.lua")
    LoadScript("Features/TeleportSystem.lua")
    LoadScript("Features/AutoFarm.lua")
    LoadScript("Features/AutoAttack.lua")
    LoadScript("Features/AFKSystem.lua")
    LoadScript("Features/FarmingManager.lua")
    LoadScript("Features/ManualFastClick.lua")
    LoadScript("Features/DropEgg.lua")
    LoadScript("Features/AntiGuard.lua")
    LoadScript("Features/ConfigSystem.lua")
    LoadScript("Features/BypassAntiCheat.lua")
    
    -- Speedlock registrations
    task.wait(0.5)
    if _G.JAYJAY_SpeedLock then
        if _G.JAYJAY_FarmButton then
            _G.JAYJAY_SpeedLock.RegisterLockable(_G.JAYJAY_FarmButton, "Farm")
        end
        if _G.JAYJAY_GetEggCheckButton then
            _G.JAYJAY_SpeedLock.RegisterLockable(_G.JAYJAY_GetEggCheckButton, "GetEgg")
        end
        if not _G.JAYJAY_SpeedLock.IsUnlocked() then
            _G.JAYJAY_SpeedLock.ApplyLock()
        end
    end
    
    print("🎉 JAYJAY HUB | Fully Ready!")
    print(" Speed:", _G.JAYJAY_IsSpeedUnlocked and " UNLOCKED" or " LOCKED")
    print(" MapSettings:", _G.JAYJAY_MapSettings and " LOADED" or " NOT LOADED")
    print(" Sound:", _G.JAYJAY_Sound and " LOADED" or " NOT LOADED")
end)