
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local WalkSpeedEnabled = false
local WalkSpeedValue = 50
local OriginalWalkSpeed = 16
local Connection = nil
local function GetHumanoid()
    local Char = Player.Character
    if not Char then return nil end
    return Char:FindFirstChildOfClass("Humanoid")
end
local function ApplyWalkSpeed()
    local Hum = GetHumanoid()
    if Hum then
        Hum.WalkSpeed = WalkSpeedValue
    end
end
local function StopWalkSpeed()
    local Hum = GetHumanoid()
    if Hum then
        Hum.WalkSpeed = OriginalWalkSpeed
    end
    if Connection then
        Connection:Disconnect()
        Connection = nil
    end
end
local function StartWalkSpeed()
    local Hum = GetHumanoid()
    if Hum then
        OriginalWalkSpeed = Hum.WalkSpeed
    end
    
    ApplyWalkSpeed()
    
    if Connection then
        Connection:Disconnect()
    end
    
    Connection = RunService.Heartbeat:Connect(function()
        if WalkSpeedEnabled then
            ApplyWalkSpeed()
        end
    end)
end
local function SetWalkSpeedValue(Value)
    WalkSpeedValue = math.clamp(Value, 50, 1000)
    if WalkSpeedEnabled then
        ApplyWalkSpeed()
    end
    print("[JAYJAY] Walk Speed Value: " .. WalkSpeedValue)
end
local function ToggleWalkSpeed()
    WalkSpeedEnabled = not WalkSpeedEnabled
    
    if WalkSpeedEnabled then
        StartWalkSpeed()
        print("[JAYJAY] Walk Speed: ON (" .. WalkSpeedValue .. ")")
    else
        StopWalkSpeed()
        print("[JAYJAY] Walk Speed: OFF")
    end
end
local function EnableWalkSpeed()
    WalkSpeedEnabled = true
    StartWalkSpeed()
    print("[JAYJAY] Walk Speed: ON (" .. WalkSpeedValue .. ")")
end

local function DisableWalkSpeed()
    WalkSpeedEnabled = false
    StopWalkSpeed()
    print("[JAYJAY] Walk Speed: OFF")
end
_G.JAYJAY_WalkSpeed = {
    Toggle = ToggleWalkSpeed,
    Enable = EnableWalkSpeed,
    Disable = DisableWalkSpeed,
    SetValue = SetWalkSpeedValue,
    IsEnabled = function() return WalkSpeedEnabled end,
    GetValue = function() return WalkSpeedValue end
}



print(" WalkSpeed Feature Loaded (Register)")
