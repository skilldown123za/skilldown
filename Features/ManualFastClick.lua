
local ProximityPromptService = game:GetService("ProximityPromptService")
local RunService = game:GetService("RunService")
local ManualFastClickEnabled = false
local PromptConnection = nil
local HeartbeatConnection = nil
local function ApplyHoldDuration(prompt)
    if not prompt then return end
    pcall(function()
        prompt.HoldDuration = 0
    end)
end
local function ScanAllPrompts()
    for _, descendant in ipairs(workspace:GetDescendants()) do
        if descendant:IsA("ProximityPrompt") then
            ApplyHoldDuration(descendant)
        end
    end
    local Player = game.Players.LocalPlayer
    if Player then
        local PlayerGui = Player:FindFirstChild("PlayerGui")
        if PlayerGui then
            for _, descendant in ipairs(PlayerGui:GetDescendants()) do
                if descendant:IsA("ProximityPrompt") then
                    ApplyHoldDuration(descendant)
                end
            end
        end
    end
end
local function EnableManualFastClick()
    if ManualFastClickEnabled then return end
    ManualFastClickEnabled = true
    ScanAllPrompts()
    if PromptConnection then
        PromptConnection:Disconnect()
        PromptConnection = nil
    end
    PromptConnection = ProximityPromptService.PromptShown:Connect(function(prompt)
        if not ManualFastClickEnabled then return end
        ApplyHoldDuration(prompt)
    end)
    if HeartbeatConnection then
        HeartbeatConnection:Disconnect()
        HeartbeatConnection = nil
    end
    local Counter = 0
    HeartbeatConnection = RunService.Heartbeat:Connect(function()
        if not ManualFastClickEnabled then return end
        Counter = Counter + 1
        if Counter >= 30 then --  ~0.5s
            Counter = 0
            ScanAllPrompts()
        end
    end)

    print("[JAYJAY] Manual Fast Click: ON")
end
local function DisableManualFastClick()
    if not ManualFastClickEnabled then return end
    ManualFastClickEnabled = false

    if PromptConnection then
        PromptConnection:Disconnect()
        PromptConnection = nil
    end
    if HeartbeatConnection then
        HeartbeatConnection:Disconnect()
        HeartbeatConnection = nil
    end

    print("[JAYJAY] Manual Fast Click: OFF")
end
local function ToggleManualFastClick()
    if ManualFastClickEnabled then
        DisableManualFastClick()
    else
        EnableManualFastClick()
    end
end
_G.JAYJAY_ManualFastClick = {
    Enable = EnableManualFastClick,
    Disable = DisableManualFastClick,
    Toggle = ToggleManualFastClick,
    IsEnabled = function() return ManualFastClickEnabled end,
    ScanAllPrompts = ScanAllPrompts,
    ApplyHoldDuration = ApplyHoldDuration
}

print(" ManualFastClick Feature Loaded")
