
local TabsManager = _G.JAYJAY_TabsManager or (getgenv and type(getgenv) == "function" and getgenv().JAYJAY_TabsManager)
local TweenService = game:GetService("TweenService")
local CreateSectionTitle = CreateSectionTitle or _G.CreateSectionTitle or (getgenv and type(getgenv) == "function" and getgenv().CreateSectionTitle)

local EventTab, EventPage = TabsManager:RegisterTab("Event", 5, "EVENT")
CreateSectionTitle(EventPage, "Event", 1)
local ManagerHolder = Instance.new("Frame")
ManagerHolder.Size = UDim2.new(1, 0, 0, 52)
ManagerHolder.BackgroundTransparency = 1
ManagerHolder.LayoutOrder = 2
ManagerHolder.Parent = EventPage

local ManagerLabel = Instance.new("TextLabel")
ManagerLabel.Size = UDim2.new(1, -50, 0, 20)
ManagerLabel.Position = UDim2.new(0, 0, 0, 2)
ManagerLabel.BackgroundTransparency = 1
ManagerLabel.Text = "Auto Attack Drone"
ManagerLabel.TextColor3 = Color3.fromRGB(220, 220, 235)
ManagerLabel.TextSize = 13
ManagerLabel.TextXAlignment = Enum.TextXAlignment.Left
ManagerLabel.TextYAlignment = Enum.TextYAlignment.Center
ManagerLabel.Font = Enum.Font.GothamBold
ManagerLabel.Parent = ManagerHolder

local ManagerSub = Instance.new("TextLabel")
ManagerSub.Size = UDim2.new(1, -50, 0, 18)
ManagerSub.Position = UDim2.new(0, 0, 0, 24)
ManagerSub.BackgroundTransparency = 1
ManagerSub.Text = "AFK Farm Drone"
ManagerSub.TextColor3 = Color3.fromRGB(150, 150, 170)
ManagerSub.TextSize = 10
ManagerSub.TextXAlignment = Enum.TextXAlignment.Left
ManagerSub.Font = Enum.Font.Gotham
ManagerSub.Parent = ManagerHolder

local ManagerButton = Instance.new("TextButton")
ManagerButton.Size = UDim2.new(0, 26, 0, 26)
ManagerButton.Position = UDim2.new(1, -26, 0.5, -13)
ManagerButton.BackgroundColor3 = Color3.fromRGB(28, 29, 39)
ManagerButton.BorderSizePixel = 0
ManagerButton.Text = ""
ManagerButton.AutoButtonColor = false
ManagerButton.Parent = ManagerHolder

local ManagerCorner = Instance.new("UICorner")
ManagerCorner.CornerRadius = UDim.new(0, 6)
ManagerCorner.Parent = ManagerButton

local ManagerStroke = Instance.new("UIStroke")
ManagerStroke.Color = Color3.fromRGB(200, 200, 220)
ManagerStroke.Thickness = 1.5
ManagerStroke.Parent = ManagerButton

local ManagerCheck = Instance.new("TextLabel")
ManagerCheck.Size = UDim2.new(1, 0, 1, 0)
ManagerCheck.BackgroundTransparency = 1
ManagerCheck.Text = ""
ManagerCheck.TextColor3 = Color3.fromRGB(255, 255, 255)
ManagerCheck.TextSize = 18
ManagerCheck.Font = Enum.Font.GothamBold
ManagerCheck.Visible = false
ManagerCheck.Parent = ManagerButton
local function UpdateManagerUI(State)
    ManagerCheck.Visible = State
    if State then
        ManagerButton.BackgroundColor3 = Color3.fromRGB(105, 90, 190)
        ManagerStroke.Color = Color3.fromRGB(135, 120, 225)
    else
        ManagerButton.BackgroundColor3 = Color3.fromRGB(28, 29, 39)
        ManagerStroke.Color = Color3.fromRGB(200, 200, 220)
    end
end

ManagerButton.MouseButton1Click:Connect(function()
    if not _G.JAYJAY_ManagerDrone then
        warn("[JAYJAY] ManagerDrone not loaded!")
        return
    end

    local NewState = not _G.JAYJAY_ManagerDrone.IsEnabled()
    UpdateManagerUI(NewState)
    if NewState then
        _G.JAYJAY_ManagerDrone.Enable()
    else
        _G.JAYJAY_ManagerDrone.Disable()
    end
end)
task.spawn(function()
    task.wait(1)
    if _G.JAYJAY_ManagerDrone then
        local State = _G.JAYJAY_ManagerDrone.IsEnabled()
        UpdateManagerUI(State)
    end
end)
_G.JAYJAY_RefreshEventUI = function()
    if _G.JAYJAY_ManagerDrone then
        local State = _G.JAYJAY_ManagerDrone.IsEnabled()
        UpdateManagerUI(State)
        print("[JAYJAY] Event Tab UI Refreshed | State: " .. tostring(State))
    end
end
task.spawn(function()
    while task.wait(1) do
        if _G.JAYJAY_ManagerDrone then
            local CurrentState = _G.JAYJAY_ManagerDrone.IsEnabled()
            local UIState = ManagerCheck.Visible

            if CurrentState ~= UIState then
                UpdateManagerUI(CurrentState)
                print("[JAYJAY] Event UI Sync | State: " .. tostring(CurrentState))
            end
        end
    end
end)

print(" Event Tab Loaded")
