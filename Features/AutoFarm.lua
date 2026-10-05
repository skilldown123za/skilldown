
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Player = Players.LocalPlayer
local Container = workspace:WaitForChild("AreaEggSlotsClient")
local Cache = {
    MeshIdMap = {},
    MeshIdMapBuilt = false,
    PetData = {},
    UidCategory = {},
}

local AutoFarmEnabled = false
local SelectedEgg = nil
local EggList = {}
local Assets = ReplicatedStorage:WaitForChild("Data"):WaitForChild("Assets")
local Configs = Assets:WaitForChild("Configs")
local EggModels = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Models"):WaitForChild("Eggs")
local MutationsModule = nil
pcall(function()
    MutationsModule = require(ReplicatedStorage.Shared.Modules.Mutations)
end)
local function BuildMeshIdMap()
    if Cache.MeshIdMapBuilt then return end

    for _, Config in ipairs(Configs:GetChildren()) do
        local Success, Module = pcall(function()
            return require(Config)
        end)
        if Success and Module and Module.Egg then
            local ModelName = Module.Egg.ModelName or Config.Name
            local EggTemplate = EggModels:FindFirstChild(ModelName)
            if EggTemplate then
                for _, descendant in ipairs(EggTemplate:GetDescendants()) do
                    if descendant:IsA("MeshPart") and descendant.MeshId ~= "" then
                        Cache.MeshIdMap[descendant.MeshId] = Config.Name
                    end
                    if descendant:IsA("SpecialMesh") and descendant.MeshId ~= "" then
                        Cache.MeshIdMap[descendant.MeshId] = Config.Name
                    end
                end
            end
        end
    end

    Cache.MeshIdMapBuilt = true
    print("[AutoFarm] MeshId Map Built (Cache)")
end

BuildMeshIdMap()
local function GetPetData(AssetCategory)
    if not AssetCategory then return nil end

    if Cache.PetData[AssetCategory] then
        return Cache.PetData[AssetCategory]
    end

    local Config = Configs:FindFirstChild(AssetCategory)
    if not Config then return nil end

    local Data = {
        Name = AssetCategory,
        DisplayName = AssetCategory,
        EarningRate = 0,
        Icon = nil
    }

    local Success, Module = pcall(function()
        return require(Config)
    end)

    if Success and Module then
        Data.DisplayName = Module.DisplayName or AssetCategory
        Data.EarningRate = Module.EarningRate or 0
        Data.Icon = Module.Icon
    end

    Cache.PetData[AssetCategory] = Data
    return Data
end
local function FormatMoney(Amount)
    if type(Amount) ~= "number" then return tostring(Amount) end
    if Amount >= 1e12 then
        return string.format("%.2fT", Amount / 1e12)
    elseif Amount >= 1e9 then
        return string.format("%.2fB", Amount / 1e9)
    elseif Amount >= 1e6 then
        return string.format("%.2fM", Amount / 1e6)
    elseif Amount >= 1e3 then
        return string.format("%.2fK", Amount / 1e3)
    else
        return tostring(math.floor(Amount))
    end
end
local function CalculateRatePerSecond(EarningRate, Scale, Mutations)
    local PayoutFactor
    if Scale <= 5 then
        PayoutFactor = Scale ^ 1.85
    else
        PayoutFactor = (Scale / 5) ^ 1.2 * 19.637875755794113
    end

    local MutationMultiplier = 1
    if Mutations and #Mutations > 0 and MutationsModule then
        local Success, Result = pcall(function()
            return MutationsModule.EarningsFor(Mutations)
        end)
        if Success then
            MutationMultiplier = Result
        end
    end

    return math.round(EarningRate * PayoutFactor * MutationMultiplier)
end
local function FindAssetCategory(EggModel)
    if not EggModel then return nil end

    local Uid = EggModel.Name
    if Cache.UidCategory[Uid] then
        return Cache.UidCategory[Uid]
    end

    for _, descendant in ipairs(EggModel:GetDescendants()) do
        if descendant:IsA("MeshPart") and descendant.MeshId ~= "" then
            local Category = Cache.MeshIdMap[descendant.MeshId]
            if Category then
                Cache.UidCategory[Uid] = Category
                return Category
            end
        end
        if descendant:IsA("SpecialMesh") and descendant.MeshId ~= "" then
            local Category = Cache.MeshIdMap[descendant.MeshId]
            if Category then
                Cache.UidCategory[Uid] = Category
                return Category
            end
        end
    end
    return nil
end
local function ScanEggs()
    EggList = {}

    for _, child in ipairs(Container:GetChildren()) do
        if child:IsA("Model") then
            local AssetCategory = FindAssetCategory(child)
            if AssetCategory then
                local Data = GetPetData(AssetCategory)
                if Data then
                    local Scale = child:GetAttribute("AssetScale") or 1
                    local Mutations = child:GetAttribute("Mutations") or {}
                    local RealRate = CalculateRatePerSecond(Data.EarningRate, Scale, Mutations)

                    table.insert(EggList, {
                        Id = child.Name,
                        Category = AssetCategory,
                        DisplayName = Data.DisplayName,
                        Icon = Data.Icon,
                        EarningRate = RealRate,
                        Model = child
                    })
                end
            end
        end
    end

    table.sort(EggList, function(a, b)
        return a.EarningRate > b.EarningRate
    end)

    return EggList
end
local function EnableAutoFarm()
    AutoFarmEnabled = true
    print("[JAYJAY] Auto Farm: ON")
end

local function DisableAutoFarm()
    AutoFarmEnabled = false
    print("[JAYJAY] Auto Farm: OFF")
end
local function SelectEgg(EggData)
    SelectedEgg = EggData
    print("[JAYJAY] Selected Egg: " .. EggData.DisplayName .. " ($" .. FormatMoney(EggData.EarningRate) .. "/s)")
end
local function StartTeleport()
    if not SelectedEgg then
        warn("[JAYJAY] No Egg Selected")
        return
    end
    if _G.JAYJAY_VIPTP and _G.JAYJAY_VIPTP.IsEnabled() then
        pcall(function()
            _G.JAYJAY_VIPTP.Disable()
        end)
        print("[AutoFarm]  Disabled VIPTP (Prevent Conflict)")
    end

    print("[JAYJAY] Start Teleport | Target: " .. SelectedEgg.Id)

    if _G.JAYJAY_TeleportSystem then
        _G.JAYJAY_TeleportSystem.SetTargetId(SelectedEgg.Id)
        _G.JAYJAY_TeleportSystem.Enable()
        print("[JAYJAY]  TeleportSystem Enabled")
    else
        warn("[JAYJAY] TeleportSystem not loaded!")
    end
end
local function StopTeleport()
    if _G.JAYJAY_TeleportSystem then
        _G.JAYJAY_TeleportSystem.Disable()
    end
    print("[JAYJAY] Stop Teleport")
end
_G.JAYJAY_AutoFarm = {
    Enable = EnableAutoFarm,
    Disable = DisableAutoFarm,
    IsEnabled = function() return AutoFarmEnabled end,
    ScanEggs = ScanEggs,
    GetEggList = function() return EggList end,
    SelectEgg = SelectEgg,
    StartTeleport = StartTeleport,
    StopTeleport = StopTeleport,
    GetSelectedEgg = function() return SelectedEgg end,
    FormatMoney = FormatMoney,

    ClearCache = function()
        Cache.UidCategory = {}
        print("[AutoFarm] Uid Cache Cleared")
    end,
}
if _G.JAYJAY_CharacterSystem then
    _G.JAYJAY_CharacterSystem:RegisterFeature({
        Name = "AutoFarm",
        Enable = EnableAutoFarm,
        Disable = DisableAutoFarm,
        IsEnabled = function() return AutoFarmEnabled end,
        OnCharacterAdded = function(Char, Hum, Root)
            if AutoFarmEnabled and SelectedEgg then
                task.wait(2)
                pcall(function()
                    if _G.JAYJAY_TeleportSystem and _G.JAYJAY_TeleportSystem.IsEnabled() then
                        StartTeleport()
                    end
                end)
            end
        end
    })
end

print(" AutoFarm Feature Loaded (FAST + CACHE + TeleportSystem + No Conflict)")
