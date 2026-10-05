
local HttpService = game:GetService("HttpService")

local CONFIG_FOLDER = "JAYJAY-SAE"
local CONFIG_FILE = CONFIG_FOLDER .. "/jayjay.json"
local DefaultConfig = {}
local function EnsureFolder()
    pcall(function()
        if not isfolder(CONFIG_FOLDER) then
            makefolder(CONFIG_FOLDER)
        end
    end)
end

local function FileExists(Path)
    local Exists = false
    pcall(function()
        Exists = isfile(Path)
    end)
    return Exists
end
local function LoadConfig()
    EnsureFolder()
    print("[JAYJAY] Config Loaded (Empty)")
    return {}
end
local function SaveConfig(Config)
    EnsureFolder()

    local DataToSave = {}

    local EncodeSuccess, EncodedData = pcall(function()
        return HttpService:JSONEncode(DataToSave)
    end)

    if not EncodeSuccess then
        warn("[JAYJAY] Failed to encode config")
        return false
    end

    local WriteSuccess = pcall(function()
        writefile(CONFIG_FILE, EncodedData)
    end)

    if WriteSuccess then
        print("[JAYJAY] Config Saved (Empty)")
        return true
    else
        warn("[JAYJAY] Failed to write config")
        return false
    end
end
local function ApplyConfig(Config)
end
local LoadedConfig = LoadConfig()
ApplyConfig(LoadedConfig)
_G.JAYJAY_ConfigSystem = {
    Folder = CONFIG_FOLDER,
    File = CONFIG_FILE,
    Default = DefaultConfig,

    Load = function()
        local Config = LoadConfig()
        ApplyConfig(Config)

        task.spawn(function()
            task.wait(0.5)
            pcall(function()
                if _G.JAYJAY_RefreshEventUI then
                    _G.JAYJAY_RefreshEventUI()
                end
            end)
            pcall(function()
                if _G.JAYJAY_RefreshSettingUI then
                    _G.JAYJAY_RefreshSettingUI()
                end
            end)
        end)

        return Config
    end,

    Save = function()
        return SaveConfig({})
    end,

    Get = function()
        return {}
    end,

    Reset = function()
        ApplyConfig(DefaultConfig)
        return SaveConfig(DefaultConfig)
    end
}

print(" ConfigSystem Loaded (Empty  No AttackDrone/SafeSpeedMode)")
