local Services = {
    Players = game:GetService("Players"),
    TweenService = game:GetService("TweenService"),
    UserInputService = game:GetService("UserInputService"),
    RunService = game:GetService("RunService"),
    CoreGui = game:GetService("CoreGui"),
    ContentProvider = game:GetService("ContentProvider"),
}

local Settings = _G.JAYJAY
Settings.Name = "JAYJAY HUB"
Settings.Version = "PREMIUM EDITION"
Settings.UI = Settings.UI or {}
Settings.UI.Theme = Settings.UI.Theme or {}
local Theme = Settings.UI.Theme

-- Luxury Neo Purple-Pink (Light Theme)
Theme.Background = Color3.fromRGB(248, 246, 252) -- Soft Neutral Background
Theme.Sidebar = Color3.fromRGB(255, 255, 255) -- Pure White Sidebar
Theme.TopBar = Color3.fromRGB(255, 255, 255) -- Pure White TopBar
Theme.Text = Color3.fromRGB(33, 26, 46) -- Deep Dark Purple
Theme.SubText = Color3.fromRGB(155, 147, 166) -- Soft Gray Purple
Theme.Border = Color3.fromRGB(235, 230, 245) -- Very soft border
Theme.Primary = Color3.fromRGB(124, 58, 237) -- Primary Purple
Theme.Accent = Color3.fromRGB(236, 72, 153) -- Primary Pink
Theme.Hover = Color3.fromRGB(245, 240, 255)

local GuiParent = Services.CoreGui
pcall(function()
    if type(gethui) == "function" then
        local HUI = gethui()
        if HUI then GuiParent = HUI end
    end
end)

pcall(function()
    local Old = GuiParent:FindFirstChild("JAYJAY_HUB")
    if Old then Old:Destroy() end
    local OldToggle = GuiParent:FindFirstChild("ToggleGUI")
    if OldToggle then OldToggle:Destroy() end
end)

local ASSET_ID = Settings.AssetID or "rbxassetid://0"
pcall(function() Services.ContentProvider:PreloadAsync({ASSET_ID}) end)

-- ==================================================
-- TOGGLE GUI
-- ==================================================
local ToggleScreenGui = Instance.new("ScreenGui")
ToggleScreenGui.Name = "ToggleGUI"
ToggleScreenGui.ResetOnSpawn = false
ToggleScreenGui.IgnoreGuiInset = true
ToggleScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ToggleScreenGui.Parent = GuiParent

local Toggle = Instance.new("ImageButton")
Toggle.Name = "Y"
Toggle.Size = UDim2.new(0, 50, 0, 50)
Toggle.Position = UDim2.new(0.02, 0, 0.5, -25)
Toggle.BackgroundColor3 = Theme.Sidebar
Toggle.BorderSizePixel = 0
Toggle.Image = ASSET_ID
Toggle.ZIndex = 999
Toggle.Parent = ToggleScreenGui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(1, 0)
ToggleCorner.Parent = Toggle

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Color = Theme.Primary
ToggleStroke.Thickness = 2
ToggleStroke.Transparency = 0.2
ToggleStroke.Parent = Toggle

local ToggleShadow = Instance.new("ImageLabel")
ToggleShadow.Name = "Shadow"
ToggleShadow.AnchorPoint = Vector2.new(0.5, 0.5)
ToggleShadow.BackgroundTransparency = 1
ToggleShadow.Position = UDim2.new(0.5, 0, 0.5, 4)
ToggleShadow.Size = UDim2.new(1, 20, 1, 20)
ToggleShadow.Image = "rbxassetid://4743306510"
ToggleShadow.ImageColor3 = Theme.Primary
ToggleShadow.ImageTransparency = 0.5
ToggleShadow.ZIndex = 998
ToggleShadow.Parent = Toggle

-- ==================================================
-- MAIN GUI
-- ==================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "JAYJAY_HUB"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 999
ScreenGui.Parent = GuiParent

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, Settings.UI.Width or 600, 0, Settings.UI.Height or 400)
Main.Position = UDim2.new(0.5, -(Settings.UI.Width or 600) / 2, 0.5, -(Settings.UI.Height or 400) / 2)
Main.BackgroundColor3 = Theme.Background
Main.BorderSizePixel = 0
Main.ClipsDescendants = false
Main.Active = true
Main.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = Main

local MainShadow = Instance.new("ImageLabel")
MainShadow.Name = "DropShadow"
MainShadow.AnchorPoint = Vector2.new(0.5, 0.5)
MainShadow.BackgroundTransparency = 1
MainShadow.Position = UDim2.new(0.5, 0, 0.5, 10)
MainShadow.Size = UDim2.new(1, 60, 1, 60)
MainShadow.Image = "rbxassetid://4743306510"
MainShadow.ImageColor3 = Color3.fromRGB(20, 15, 30)
MainShadow.ImageTransparency = 0.7
MainShadow.ZIndex = -1
MainShadow.Parent = Main

local MainBorder = Instance.new("UIStroke")
MainBorder.Color = Theme.Border
MainBorder.Thickness = 1
MainBorder.Transparency = 0
MainBorder.Parent = Main

-- ==================================================
-- SIDEBAR (StarHub Style - Left Minimalist)
-- ==================================================
local SidebarWidth = 170

local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, SidebarWidth, 1, 0)
Sidebar.Position = UDim2.new(0, 0, 0, 0)
Sidebar.BackgroundColor3 = Theme.Sidebar
Sidebar.BorderSizePixel = 0
Sidebar.ZIndex = 10
Sidebar.Parent = Main

local SidebarCorner = Instance.new("UICorner")
SidebarCorner.CornerRadius = UDim.new(0, 12)
SidebarCorner.Parent = Sidebar

local SidebarCover = Instance.new("Frame")
SidebarCover.Name = "SidebarCover"
SidebarCover.Size = UDim2.new(0, 12, 1, 0)
SidebarCover.Position = UDim2.new(1, -12, 0, 0)
SidebarCover.BackgroundColor3 = Theme.Sidebar
SidebarCover.BorderSizePixel = 0
SidebarCover.ZIndex = 10
SidebarCover.Parent = Sidebar

local SidebarLine = Instance.new("Frame")
SidebarLine.Name = "SidebarLine"
SidebarLine.Size = UDim2.new(0, 1, 1, 0)
SidebarLine.Position = UDim2.new(1, -1, 0, 0)
SidebarLine.BackgroundColor3 = Theme.Border
SidebarLine.BorderSizePixel = 0
SidebarLine.ZIndex = 11
SidebarLine.Parent = Sidebar

local LogoArea = Instance.new("Frame")
LogoArea.Name = "LogoArea"
LogoArea.Size = UDim2.new(1, 0, 0, 70)
LogoArea.BackgroundTransparency = 1
LogoArea.ZIndex = 12
LogoArea.Parent = Sidebar

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -20, 0, 30)
Title.Position = UDim2.new(0, 20, 0, 15)
Title.BackgroundTransparency = 1
Title.Text = Settings.Name
Title.TextColor3 = Theme.Text
Title.TextSize = 20
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Font = Enum.Font.GothamBold
Title.ZIndex = 12
Title.Parent = LogoArea

local TitleGradient = Instance.new("UIGradient")
TitleGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Theme.Primary),
    ColorSequenceKeypoint.new(1, Theme.Accent)
})
TitleGradient.Rotation = 45
TitleGradient.Parent = Title

local Subtitle = Instance.new("TextLabel")
Subtitle.Name = "Subtitle"
Subtitle.Size = UDim2.new(1, -20, 0, 15)
Subtitle.Position = UDim2.new(0, 20, 0, 42)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = Settings.Version
Subtitle.TextColor3 = Theme.SubText
Subtitle.TextSize = 10
Subtitle.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.Font = Enum.Font.GothamMedium
Subtitle.ZIndex = 12
Subtitle.Parent = LogoArea

local TabScroll = Instance.new("ScrollingFrame")
TabScroll.Name = "TabScroll"
TabScroll.Size = UDim2.new(1, 0, 1, -70)
TabScroll.Position = UDim2.new(0, 0, 0, 70)
TabScroll.BackgroundTransparency = 1
TabScroll.BorderSizePixel = 0
TabScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
TabScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
TabScroll.ScrollingDirection = Enum.ScrollingDirection.Y
TabScroll.ScrollBarThickness = 2
TabScroll.ScrollBarImageColor3 = Theme.Border
TabScroll.ZIndex = 12
TabScroll.Parent = Sidebar

local TabPadding = Instance.new("UIPadding")
TabPadding.PaddingTop = UDim.new(0, 10)
TabPadding.PaddingBottom = UDim.new(0, 10)
TabPadding.PaddingLeft = UDim.new(0, 15)
TabPadding.PaddingRight = UDim.new(0, 15)
TabPadding.Parent = TabScroll

local TabList = Instance.new("UIListLayout")
TabList.Padding = UDim.new(0, 6)
TabList.SortOrder = Enum.SortOrder.LayoutOrder
TabList.Parent = TabScroll

-- ==================================================
-- CONTENT AREA
-- ==================================================
local Content = Instance.new("Frame")
Content.Name = "Content"
Content.Size = UDim2.new(1, -SidebarWidth, 1, 0)
Content.Position = UDim2.new(0, SidebarWidth, 0, 0)
Content.BackgroundTransparency = 1
Content.ZIndex = 5
Content.Parent = Main

-- TopBar for Content (Invisible Drag Area + Exit)
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 50)
TopBar.BackgroundTransparency = 1
TopBar.Active = true
TopBar.ZIndex = 20
TopBar.Parent = Content

_G.JAYJAY_Main = Main
_G.JAYJAY_TopBar = TopBar -- Used for dragging
_G.JAYJAY_Sidebar = Sidebar
_G.JAYJAY_TabScroll = TabScroll
_G.JAYJAY_Content = Content
_G.JAYJAY_ScreenGui = ScreenGui
_G.JAYJAY_Toggle = Toggle
_G.JAYJAY_GuiParent = GuiParent

-- ==================================================
-- DRAGGING LOGIC
-- ==================================================
local Dragging = false
local DragStart = nil
local StartPosition = nil
local ActiveTouch = nil

local function StartDrag(Input)
    if Dragging then return end
    if Input.UserInputType == Enum.UserInputType.Touch then
        ActiveTouch = Input
    end
    Dragging = true
    DragStart = Input.Position
    StartPosition = Main.Position
end

local function StopDrag()
    Dragging = false
    ActiveTouch = nil
    DragStart = nil
    StartPosition = nil
end

-- Drag from TopBar
TopBar.InputBegan:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1 or
       Input.UserInputType == Enum.UserInputType.Touch then
        StartDrag(Input)
    end
end)

-- Drag from LogoArea (Sidebar Top)
LogoArea.InputBegan:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1 or
       Input.UserInputType == Enum.UserInputType.Touch then
        StartDrag(Input)
    end
end)

Services.UserInputService.InputChanged:Connect(function(Input)
    if not Dragging then return end
    if Input.UserInputType == Enum.UserInputType.Touch then
        if ActiveTouch and Input ~= ActiveTouch then return end
    end
    if not DragStart or not StartPosition then return end
    if Input.UserInputType ~= Enum.UserInputType.MouseMovement and
       Input.UserInputType ~= Enum.UserInputType.Touch then return end

    local Delta = Input.Position - DragStart
    Main.Position = UDim2.new(
        StartPosition.X.Scale,
        StartPosition.X.Offset + Delta.X,
        StartPosition.Y.Scale,
        StartPosition.Y.Offset + Delta.Y
    )
end)

Services.UserInputService.InputEnded:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.Touch then
        if ActiveTouch and Input == ActiveTouch then
            StopDrag()
        end
        return
    end
    if Input.UserInputType == Enum.UserInputType.MouseButton1 then
        if Dragging then StopDrag() end
    end
end)

-- ==================================================
-- TOGGLE DRAG & CLICK LOGIC
-- ==================================================
local ToggleDragging = false
local ToggleDragStart = nil
local ToggleStartPos = nil
local ToggleActiveTouch = nil

local function StartToggleDrag(Input)
    if ToggleDragging then return end
    if Input.UserInputType == Enum.UserInputType.Touch then
        ToggleActiveTouch = Input
    end
    ToggleDragging = true
    ToggleDragStart = Input.Position
    ToggleStartPos = Toggle.Position
end

local function StopToggleDrag()
    ToggleDragging = false
    ToggleActiveTouch = nil
    ToggleDragStart = nil
    ToggleStartPos = nil
end

Toggle.InputBegan:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1 or
       Input.UserInputType == Enum.UserInputType.Touch then
        StartToggleDrag(Input)
    end
end)

Services.UserInputService.InputChanged:Connect(function(Input)
    if not ToggleDragging then return end
    if Input.UserInputType == Enum.UserInputType.Touch then
        if ToggleActiveTouch and Input ~= ToggleActiveTouch then return end
    end
    if not ToggleDragStart or not ToggleStartPos then return end
    if Input.UserInputType ~= Enum.UserInputType.MouseMovement and
       Input.UserInputType ~= Enum.UserInputType.Touch then return end

    local Delta = Input.Position - ToggleDragStart
    Toggle.Position = UDim2.new(
        ToggleStartPos.X.Scale,
        ToggleStartPos.X.Offset + Delta.X,
        ToggleStartPos.Y.Scale,
        ToggleStartPos.Y.Offset + Delta.Y
    )
end)

Services.UserInputService.InputEnded:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.Touch then
        if ToggleActiveTouch and Input == ToggleActiveTouch then
            StopToggleDrag()
        end
        return
    end
    if Input.UserInputType == Enum.UserInputType.MouseButton1 then
        if ToggleDragging then StopToggleDrag() end
    end
end)

local isUIVisible = true
local ToggleClickTime = 0

Toggle.MouseButton1Down:Connect(function()
    ToggleClickTime = tick()
end)

Toggle.MouseButton1Up:Connect(function()
    if tick() - ToggleClickTime < 0.2 then
        isUIVisible = not isUIVisible
        
        -- Smooth fade in/out
        if isUIVisible then
            ScreenGui.Enabled = true
            Services.TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, Settings.UI.Width or 600, 0, Settings.UI.Height or 400),
                BackgroundTransparency = 0
            }):Play()
        else
            local fadeOut = Services.TweenService:Create(Main, TweenInfo.new(0.2, Enum.EasingStyle.Cubic, Enum.EasingDirection.In), {
                Size = UDim2.new(0, (Settings.UI.Width or 600) * 0.9, 0, (Settings.UI.Height or 400) * 0.9),
                BackgroundTransparency = 1
            })
            fadeOut:Play()
            fadeOut.Completed:Connect(function()
                if not isUIVisible then
                    ScreenGui.Enabled = false
                end
            end)
        end

        -- Bounce animation on Toggle button
        Services.TweenService:Create(Toggle, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 40, 0, 40)
        }):Play()
        task.wait(0.1)
        Services.TweenService:Create(Toggle, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 50, 0, 50)
        }):Play()
    end
end)

print(" UI Loaded (StarHub Premium Style)")
