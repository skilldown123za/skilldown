
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ProximityPromptService = game:GetService("ProximityPromptService")

local Player = Players.LocalPlayer
local WALK_SPEED_VALUE = 800
local TELEPORT_DELAY = 0.5 --  Teleport 
local POSITION_1 = Vector3.new(663, 70, -369)
local POSITION_3 = Vector3.new(5974, 70, -368)
local Enabled = false
local WalkSpeedConnection = nil
local OriginalWalkSpeed = 16
local FastClickPromptConnection = nil
local FastClickHeartbeatConnection = nil
local FastClickCounter = 0
local EggCheckThread = nil
local DropHeldEgg = nil
local EggCollectTriggered = false

local FlyLoopRunning = false
local CurrentFlyStep = 1
local StartFlyLoop
local StopFly

local function safeTeleport(hrp, position)
    pcall(function() hrp.Velocity = Vector3.new(0, 0, 0) end)
    pcall(function() hrp.RotVelocity = Vector3.new(0, 0, 0) end)
    hrp.CFrame = CFrame.new(position.X, position.Y, position.Z)
end
local function GetHumanoid()
    local Char = Player.Character
    if not Char then return nil, nil end
    return Char:FindFirstChildOfClass("Humanoid"), Char:FindFirstChild("HumanoidRootPart")
end
local function StartWalkSpeed()
    local Hum = GetHumanoid()
    if Hum then
        OriginalWalkSpeed = Hum.WalkSpeed
        Hum.WalkSpeed = WALK_SPEED_VALUE
    end

    if WalkSpeedConnection then WalkSpeedConnection:Disconnect() end
    WalkSpeedConnection = RunService.Heartbeat:Connect(function()
        if not Enabled then return end
        local H = GetHumanoid()
        if H then H.WalkSpeed = WALK_SPEED_VALUE end
    end)

    print("[For Event Drop Egg] WalkSpeed: ON (" .. WALK_SPEED_VALUE .. ")")
end

local function StopWalkSpeed()
    if WalkSpeedConnection then
        WalkSpeedConnection:Disconnect()
        WalkSpeedConnection = nil
    end
    local Hum = GetHumanoid()
    if Hum then Hum.WalkSpeed = OriginalWalkSpeed end
    print("[For Event Drop Egg] WalkSpeed: OFF")
end
local function ApplyHoldDuration(prompt)
    if not prompt then return end
    pcall(function() prompt.HoldDuration = 0 end)
end

local function ScanAllPrompts()
    for _, d in ipairs(workspace:GetDescendants()) do
        if d:IsA("ProximityPrompt") then ApplyHoldDuration(d) end
    end
    local PG = Player:FindFirstChild("PlayerGui")
    if PG then
        for _, d in ipairs(PG:GetDescendants()) do
            if d:IsA("ProximityPrompt") then ApplyHoldDuration(d) end
        end
    end
end

local function StartFastClick()
    ScanAllPrompts()

    if FastClickPromptConnection then FastClickPromptConnection:Disconnect() end
    FastClickPromptConnection = ProximityPromptService.PromptShown:Connect(function(prompt)
        if not Enabled then return end
        ApplyHoldDuration(prompt)
    end)

    if FastClickHeartbeatConnection then FastClickHeartbeatConnection:Disconnect() end
    FastClickCounter = 0
    FastClickHeartbeatConnection = RunService.Heartbeat:Connect(function()
        if not Enabled then return end
        FastClickCounter = FastClickCounter + 1
        if FastClickCounter >= 30 then
            FastClickCounter = 0
            ScanAllPrompts()
        end
    end)

    print("[For Event Drop Egg] Fast Click: ON")
end

local function StopFastClick()
    if FastClickPromptConnection then FastClickPromptConnection:Disconnect() FastClickPromptConnection = nil end
    if FastClickHeartbeatConnection then FastClickHeartbeatConnection:Disconnect() FastClickHeartbeatConnection = nil end
    print("[For Event Drop Egg] Fast Click: OFF")
end
local function GetDropHeldEgg()
    local PG = Player:FindFirstChild("PlayerGui")
    if not PG then return nil end
    return PG:FindFirstChild("DropHeldEgg")
end

local function StartEggCheckThread()
    if EggCheckThread then
        pcall(function() task.cancel(EggCheckThread) end)
        EggCheckThread = nil
    end

    EggCheckThread = task.spawn(function()
        while Enabled do
            task.wait(CHECK_INTERVAL)

            if not DropHeldEgg or not DropHeldEgg.Parent then
                DropHeldEgg = GetDropHeldEgg()
            end

            if DropHeldEgg then
                local IsCollected = DropHeldEgg.Enabled == true

                if IsCollected and not EggCollectTriggered then
                    EggCollectTriggered = true
                    print("[For Event Drop Egg]  Egg Collect = TRUE  Start Fly Loop")
                    if StartFlyLoop then StartFlyLoop() end
                elseif not IsCollected and EggCollectTriggered then
                    EggCollectTriggered = false
                    print("[For Event Drop Egg]  Egg Collect = FALSE  Stop Fly Loop")
                    if StopFly then StopFly() end
                end
            end
        end
    end)

    print("[For Event Drop Egg] Egg Check Thread: STARTED")
end

local function StopEggCheckThread()
    if EggCheckThread then
        pcall(function() task.cancel(EggCheckThread) end)
        EggCheckThread = nil
    end
    print("[For Event Drop Egg] Egg Check Thread: STOPPED")
end
local function CleanupMovers(KeepPlatformStand)
    local Hum, Root = GetHumanoid()
    if Hum and not KeepPlatformStand then
        pcall(function()
            Hum.PlatformStand = false
            Hum.Sit = false
        end)
    end
    if Root then
        pcall(function()
            Root.AssemblyLinearVelocity = Vector3.zero
            Root.AssemblyAngularVelocity = Vector3.zero
        end)
    end
end
local function FlyTP(Destination, Callback)
    CleanupMovers()

    local Hum, Root = GetHumanoid()
    if not Hum or not Root or Hum.Health <= 0 then
        if Callback then Callback() end
        return
    end

    Hum.PlatformStand = true
    safeTeleport(Root, Destination)
    
    task.spawn(function()
        task.wait(0.1)
        CleanupMovers(true)
        if Callback then Callback() end
    end)
end
local function FlyLoopStep()
    if not Enabled or not FlyLoopRunning then return end

    if CurrentFlyStep == 1 then
        print("[For Event Drop Egg] Fly  Position 3")
        FlyTP(POSITION_3, function()
            if not Enabled or not FlyLoopRunning then return end
            task.wait(TELEPORT_DELAY)
            CurrentFlyStep = 2
            FlyLoopStep()
        end)
    else
        print("[For Event Drop Egg] Fly  Position 1")
        FlyTP(POSITION_1, function()
            if not Enabled or not FlyLoopRunning then return end
            task.wait(TELEPORT_DELAY)
            CurrentFlyStep = 1
            FlyLoopStep()
        end)
    end
end

StartFlyLoop = function()
    if FlyLoopRunning then return end
    FlyLoopRunning = true
    CurrentFlyStep = 1

    print("[For Event Drop Egg]  Teleport Loop STARTED (P3  P1  No Stop)")
    FlyLoopStep()
end

StopFly = function()
    FlyLoopRunning = false
    CleanupMovers()
    print("[For Event Drop Egg] Teleport Loop: STOPPED")
end
local function Enable()
    if Enabled then return end
    Enabled = true
    EggCollectTriggered = false
    CurrentFlyStep = 1

    StartWalkSpeed()
    StartFastClick()
    StartEggCheckThread()

    print("[For Event Drop Egg] =========================")
    print("[For Event Drop Egg] COMBO: ON")
    print("[For Event Drop Egg] TELEPORT MODE (Instant)")
    print("[For Event Drop Egg] =========================")
end

local function Disable()
    if not Enabled then return end
    Enabled = false
    EggCollectTriggered = false

    StopWalkSpeed()
    StopFastClick()
    StopEggCheckThread()
    StopFly()

    DropHeldEgg = nil

    print("[For Event Drop Egg] COMBO: OFF")
end

local function Toggle()
    if Enabled then Disable() else Enable() end
end
_G.JAYJAY_DropEgg = {
    Enable = Enable,
    Disable = Disable,
    Toggle = Toggle,
    IsEnabled = function() return Enabled end,
    POSITION_1 = POSITION_1,
    POSITION_3 = POSITION_3,
    TELEPORT_DELAY = TELEPORT_DELAY,
}
if _G.JAYJAY_CharacterSystem then
    _G.JAYJAY_CharacterSystem:RegisterFeature({
        Name = "DropEgg",
        Enable = Enable,
        Disable = Disable,
        IsEnabled = function() return Enabled end,
        OnCharacterAdded = function(Char, Hum, Root)
            if Enabled then
                task.wait(1)
                StartWalkSpeed()
                StartFastClick()
                StartEggCheckThread()
            end
        end
    })
end

print(" DropEgg Feature Loaded (For Event Drop Egg)")
