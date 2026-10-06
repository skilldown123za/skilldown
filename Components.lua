local TweenService = game:GetService("TweenService")
local Settings = _G.JAYJAY
local Theme = Settings.UI.Theme

local function GetTabTextSize(Name)
    local Length = #Name
    if Length >= 16 then return 11
    elseif Length >= 13 then return 12
    elseif Length >= 9 then return 13
    else return 14 end
end

local function Tween(obj, props, time)
    TweenService:Create(obj, TweenInfo.new(time or 0.2, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), props):Play()
end

function CreateTab(Name, Order)
    local TabScroll = _G.JAYJAY_TabScroll
    local Tab = Instance.new("TextButton")
    Tab.Name = Name:gsub("%s+", "_") .. "_Tab"
    Tab.Size = UDim2.new(1, 0, 0, 38)
    Tab.BackgroundColor3 = Theme.Hover
    Tab.BackgroundTransparency = 1
    Tab.BorderSizePixel = 0
    Tab.Text = ""
    Tab.AutoButtonColor = false
    Tab.LayoutOrder = Order or 1
    Tab.ZIndex = 13
    Tab.Parent = TabScroll

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Tab

    local Indicator = Instance.new("Frame")
    Indicator.Name = "Indicator"
    Indicator.Size = UDim2.new(0, 4, 0, 0) -- Starts at 0 height
    Indicator.Position = UDim2.new(0, 0, 0.5, 0)
    Indicator.AnchorPoint = Vector2.new(0, 0.5)
    Indicator.BackgroundColor3 = Theme.Primary
    Indicator.BorderSizePixel = 0
    Indicator.ZIndex = 14
    Indicator.Parent = Tab

    local IndicatorCorner = Instance.new("UICorner")
    IndicatorCorner.CornerRadius = UDim.new(1, 0)
    IndicatorCorner.Parent = Indicator

    local Text = Instance.new("TextLabel")
    Text.Name = "TabText"
    Text.Size = UDim2.new(1, -20, 1, 0)
    Text.Position = UDim2.new(0, 15, 0, 0)
    Text.BackgroundTransparency = 1
    Text.Text = Name
    Text.TextColor3 = Theme.SubText
    Text.TextSize = GetTabTextSize(Name)
    Text.TextXAlignment = Enum.TextXAlignment.Left
    Text.TextYAlignment = Enum.TextYAlignment.Center
    Text.Font = Enum.Font.GothamMedium
    Text.TextTruncate = Enum.TextTruncate.AtEnd
    Text.ZIndex = 14
    Text.Parent = Tab

    -- Hover animation
    Tab.MouseEnter:Connect(function()
        if not Text.Active then -- If not selected
            Tween(Tab, {BackgroundTransparency = 0.5})
            Tween(Text, {TextColor3 = Theme.Text})
        end
    end)
    
    Tab.MouseLeave:Connect(function()
        if not Text.Active then
            Tween(Tab, {BackgroundTransparency = 1})
            Tween(Text, {TextColor3 = Theme.SubText})
        end
    end)

    return Tab
end

function CreatePage(Name)
    local Content = _G.JAYJAY_Content
    local Page = Instance.new("ScrollingFrame")
    Page.Name = Name .. "_Page"
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.BorderSizePixel = 0
    Page.Visible = false
    Page.CanvasSize = UDim2.new(0, 0, 0, 0)
    Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Page.ScrollingDirection = Enum.ScrollingDirection.Y
    Page.ScrollBarThickness = 3
    Page.ScrollBarImageColor3 = Theme.Border
    Page.ScrollBarImageTransparency = 0
    Page.VerticalScrollBarInset = Enum.ScrollBarInset.Always
    Page.ZIndex = 6
    Page.Parent = Content

    local Padding = Instance.new("UIPadding")
    Padding.PaddingTop = UDim.new(0, 15)
    Padding.PaddingBottom = UDim.new(0, 20)
    Padding.PaddingLeft = UDim.new(0, 20)
    Padding.PaddingRight = UDim.new(0, 15)
    Padding.Parent = Page

    local List = Instance.new("UIListLayout")
    List.Padding = UDim.new(0, 8)
    List.SortOrder = Enum.SortOrder.LayoutOrder
    List.Parent = Page

    return Page
end

function CreateSectionTitle(Parent, TextValue, Order)
    local Holder = Instance.new("Frame")
    Holder.Name = "SectionTitleHolder"
    Holder.Size = UDim2.new(1, 0, 0, 35)
    Holder.BackgroundTransparency = 1
    Holder.LayoutOrder = Order or 1
    Holder.ZIndex = 8
    Holder.Parent = Parent

    local Label = Instance.new("TextLabel")
    Label.Name = "SectionTitle"
    Label.Size = UDim2.new(1, -10, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = TextValue
    Label.TextColor3 = Theme.Primary
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.TextYAlignment = Enum.TextYAlignment.Center
    Label.Font = Enum.Font.GothamBold
    Label.ZIndex = 9
    Label.Parent = Holder

    local Dot = Instance.new("Frame")
    Dot.Size = UDim2.new(0, 4, 0, 14)
    Dot.Position = UDim2.new(0, 0, 0.5, -7)
    Dot.BackgroundColor3 = Theme.Accent
    Dot.BorderSizePixel = 0
    Dot.ZIndex = 9
    Dot.Parent = Holder

    local DotCorner = Instance.new("UICorner")
    DotCorner.CornerRadius = UDim.new(1, 0)
    DotCorner.Parent = Dot

    return Label
end

function CreateCheckbox(Parent, TextValue, Order)
    local Holder = Instance.new("Frame")
    Holder.Name = TextValue:gsub("%s+", "_")
    Holder.Size = UDim2.new(1, 0, 0, 36)
    Holder.BackgroundColor3 = Theme.Sidebar
    Holder.BorderSizePixel = 0
    Holder.LayoutOrder = Order or 1
    Holder.ZIndex = 9
    Holder.Parent = Parent

    local HolderCorner = Instance.new("UICorner")
    HolderCorner.CornerRadius = UDim.new(0, 8)
    HolderCorner.Parent = Holder

    local HolderStroke = Instance.new("UIStroke")
    HolderStroke.Color = Theme.Border
    HolderStroke.Thickness = 1
    HolderStroke.Parent = Holder

    local Label = Instance.new("TextLabel")
    Label.Name = "Label"
    Label.Size = UDim2.new(1, -50, 1, 0)
    Label.Position = UDim2.new(0, 12, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = TextValue
    Label.TextColor3 = Theme.Text
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.TextYAlignment = Enum.TextYAlignment.Center
    Label.Font = Enum.Font.GothamMedium
    Label.ZIndex = 10
    Label.Parent = Holder

    local CheckButton = Instance.new("TextButton")
    CheckButton.Name = "CheckBox"
    CheckButton.Size = UDim2.new(0, 40, 0, 20)
    CheckButton.Position = UDim2.new(1, -52, 0.5, -10)
    CheckButton.BackgroundColor3 = Theme.Border
    CheckButton.BorderSizePixel = 0
    CheckButton.Text = ""
    CheckButton.AutoButtonColor = false
    CheckButton.ZIndex = 20
    CheckButton.Parent = Holder

    local BoxCorner = Instance.new("UICorner")
    BoxCorner.CornerRadius = UDim.new(1, 0)
    BoxCorner.Parent = CheckButton

    local Circle = Instance.new("Frame")
    Circle.Size = UDim2.new(0, 16, 0, 16)
    Circle.Position = UDim2.new(0, 2, 0.5, -8)
    Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Circle.BorderSizePixel = 0
    Circle.ZIndex = 21
    Circle.Parent = CheckButton

    local CircleCorner = Instance.new("UICorner")
    CircleCorner.CornerRadius = UDim.new(1, 0)
    CircleCorner.Parent = Circle

    local CircleShadow = Instance.new("ImageLabel")
    CircleShadow.BackgroundTransparency = 1
    CircleShadow.Position = UDim2.new(0.5, 0, 0.5, 2)
    CircleShadow.AnchorPoint = Vector2.new(0.5, 0.5)
    CircleShadow.Size = UDim2.new(1, 10, 1, 10)
    CircleShadow.Image = "rbxassetid://4743306510"
    CircleShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    CircleShadow.ImageTransparency = 0.8
    CircleShadow.ZIndex = 20
    CircleShadow.Parent = Circle

    local Enabled = false

    local function Toggle()
        Enabled = not Enabled
        if Enabled then
            Tween(CheckButton, {BackgroundColor3 = Theme.Primary})
            Tween(Circle, {Position = UDim2.new(1, -18, 0.5, -8)})
            Tween(HolderStroke, {Color = Theme.Primary, Transparency = 0.5})
        else
            Tween(CheckButton, {BackgroundColor3 = Theme.Border})
            Tween(Circle, {Position = UDim2.new(0, 2, 0.5, -8)})
            Tween(HolderStroke, {Color = Theme.Border, Transparency = 0})
        end
    end

    CheckButton.MouseButton1Click:Connect(Toggle)
    return Holder, CheckButton, function() return Enabled end
end

function CreateTextBoxWithCheckbox(Parent, TextValue, Order, DefaultValue, MinValue, MaxValue)
    DefaultValue = DefaultValue or 50
    MinValue = MinValue or 0
    MaxValue = MaxValue or 1000

    local Holder = Instance.new("Frame")
    Holder.Name = TextValue:gsub("%s+", "_")
    Holder.Size = UDim2.new(1, 0, 0, 42)
    Holder.BackgroundColor3 = Theme.Sidebar
    Holder.BorderSizePixel = 0
    Holder.LayoutOrder = Order or 1
    Holder.ZIndex = 9
    Holder.Parent = Parent

    local HolderCorner = Instance.new("UICorner")
    HolderCorner.CornerRadius = UDim.new(0, 8)
    HolderCorner.Parent = Holder

    local HolderStroke = Instance.new("UIStroke")
    HolderStroke.Color = Theme.Border
    HolderStroke.Thickness = 1
    HolderStroke.Parent = Holder

    local Label = Instance.new("TextLabel")
    Label.Name = "Label"
    Label.Size = UDim2.new(0, 120, 1, 0)
    Label.Position = UDim2.new(0, 12, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = TextValue
    Label.TextColor3 = Theme.Text
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.TextYAlignment = Enum.TextYAlignment.Center
    Label.Font = Enum.Font.GothamMedium
    Label.ZIndex = 10
    Label.Parent = Holder

    local TextBox = Instance.new("TextBox")
    TextBox.Name = "TextBox"
    TextBox.Size = UDim2.new(0, 70, 0, 26)
    TextBox.Position = UDim2.new(1, -135, 0.5, -13)
    TextBox.BackgroundColor3 = Theme.Background
    TextBox.BorderSizePixel = 0
    TextBox.Text = tostring(DefaultValue)
    TextBox.TextColor3 = Theme.Text
    TextBox.TextSize = 12
    TextBox.TextXAlignment = Enum.TextXAlignment.Center
    TextBox.TextYAlignment = Enum.TextYAlignment.Center
    TextBox.Font = Enum.Font.GothamBold
    TextBox.ZIndex = 11
    TextBox.Parent = Holder

    local TBoxCorner = Instance.new("UICorner")
    TBoxCorner.CornerRadius = UDim.new(0, 6)
    TBoxCorner.Parent = TextBox

    local TBoxStroke = Instance.new("UIStroke")
    TBoxStroke.Color = Theme.Border
    TBoxStroke.Thickness = 1
    TBoxStroke.Parent = TextBox

    local CheckButton = Instance.new("TextButton")
    CheckButton.Name = "CheckBox"
    CheckButton.Size = UDim2.new(0, 40, 0, 20)
    CheckButton.Position = UDim2.new(1, -52, 0.5, -10)
    CheckButton.BackgroundColor3 = Theme.Border
    CheckButton.BorderSizePixel = 0
    CheckButton.Text = ""
    CheckButton.AutoButtonColor = false
    CheckButton.ZIndex = 20
    CheckButton.Parent = Holder

    local BoxCorner = Instance.new("UICorner")
    BoxCorner.CornerRadius = UDim.new(1, 0)
    BoxCorner.Parent = CheckButton

    local Circle = Instance.new("Frame")
    Circle.Size = UDim2.new(0, 16, 0, 16)
    Circle.Position = UDim2.new(0, 2, 0.5, -8)
    Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Circle.BorderSizePixel = 0
    Circle.ZIndex = 21
    Circle.Parent = CheckButton

    local CircleCorner = Instance.new("UICorner")
    CircleCorner.CornerRadius = UDim.new(1, 0)
    CircleCorner.Parent = Circle

    local CircleShadow = Instance.new("ImageLabel")
    CircleShadow.BackgroundTransparency = 1
    CircleShadow.Position = UDim2.new(0.5, 0, 0.5, 2)
    CircleShadow.AnchorPoint = Vector2.new(0.5, 0.5)
    CircleShadow.Size = UDim2.new(1, 10, 1, 10)
    CircleShadow.Image = "rbxassetid://4743306510"
    CircleShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    CircleShadow.ImageTransparency = 0.8
    CircleShadow.ZIndex = 20
    CircleShadow.Parent = Circle

    local Enabled = false
    local CurrentValue = DefaultValue

    local function UpdateValue()
        local val = tonumber(TextBox.Text)
        if val then
            CurrentValue = math.clamp(val, MinValue, MaxValue)
            TextBox.Text = tostring(CurrentValue)
        else
            TextBox.Text = tostring(CurrentValue)
        end
    end

    local function Toggle()
        Enabled = not Enabled
        if Enabled then
            Tween(CheckButton, {BackgroundColor3 = Theme.Primary})
            Tween(Circle, {Position = UDim2.new(1, -18, 0.5, -8)})
            Tween(HolderStroke, {Color = Theme.Primary, Transparency = 0.5})
            Tween(TBoxStroke, {Color = Theme.Primary, Transparency = 0.5})
        else
            Tween(CheckButton, {BackgroundColor3 = Theme.Border})
            Tween(Circle, {Position = UDim2.new(0, 2, 0.5, -8)})
            Tween(HolderStroke, {Color = Theme.Border, Transparency = 0})
            Tween(TBoxStroke, {Color = Theme.Border, Transparency = 0})
        end
    end

    CheckButton.MouseButton1Click:Connect(Toggle)
    TextBox.FocusLost:Connect(UpdateValue)

    return Holder, CheckButton, function() return Enabled end, TextBox, function() return CurrentValue end
end

function CreateSmartCheckbox(Parent, LabelText, Order, ToggleFunction, GetStateFunction)
    local Holder = Instance.new("Frame")
    Holder.Name = LabelText:gsub("%s+", "_")
    Holder.Size = UDim2.new(1, 0, 0, 36)
    Holder.BackgroundColor3 = Theme.Sidebar
    Holder.BorderSizePixel = 0
    Holder.LayoutOrder = Order or 1
    Holder.ZIndex = 9
    Holder.Parent = Parent

    local HolderCorner = Instance.new("UICorner")
    HolderCorner.CornerRadius = UDim.new(0, 8)
    HolderCorner.Parent = Holder

    local HolderStroke = Instance.new("UIStroke")
    HolderStroke.Color = Theme.Border
    HolderStroke.Thickness = 1
    HolderStroke.Parent = Holder

    local Label = Instance.new("TextLabel")
    Label.Name = "Label"
    Label.Size = UDim2.new(1, -50, 1, 0)
    Label.Position = UDim2.new(0, 12, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = LabelText
    Label.TextColor3 = Theme.Text
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.TextYAlignment = Enum.TextYAlignment.Center
    Label.Font = Enum.Font.GothamMedium
    Label.ZIndex = 10
    Label.Parent = Holder

    local Button = Instance.new("TextButton")
    Button.Name = "CheckBox"
    Button.Size = UDim2.new(0, 40, 0, 20)
    Button.Position = UDim2.new(1, -52, 0.5, -10)
    Button.BackgroundColor3 = Theme.Border
    Button.BorderSizePixel = 0
    Button.Text = ""
    Button.AutoButtonColor = false
    Button.ZIndex = 20
    Button.Parent = Holder

    local BoxCorner = Instance.new("UICorner")
    BoxCorner.CornerRadius = UDim.new(1, 0)
    BoxCorner.Parent = Button

    local Circle = Instance.new("Frame")
    Circle.Size = UDim2.new(0, 16, 0, 16)
    Circle.Position = UDim2.new(0, 2, 0.5, -8)
    Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Circle.BorderSizePixel = 0
    Circle.ZIndex = 21
    Circle.Parent = Button

    local CircleCorner = Instance.new("UICorner")
    CircleCorner.CornerRadius = UDim.new(1, 0)
    CircleCorner.Parent = Circle

    local CircleShadow = Instance.new("ImageLabel")
    CircleShadow.BackgroundTransparency = 1
    CircleShadow.Position = UDim2.new(0.5, 0, 0.5, 2)
    CircleShadow.AnchorPoint = Vector2.new(0.5, 0.5)
    CircleShadow.Size = UDim2.new(1, 10, 1, 10)
    CircleShadow.Image = "rbxassetid://4743306510"
    CircleShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    CircleShadow.ImageTransparency = 0.8
    CircleShadow.ZIndex = 20
    CircleShadow.Parent = Circle

    local Enabled = false
    if GetStateFunction then
        Enabled = GetStateFunction()
        if Enabled then
            Button.BackgroundColor3 = Theme.Primary
            Circle.Position = UDim2.new(1, -18, 0.5, -8)
            HolderStroke.Color = Theme.Primary
            HolderStroke.Transparency = 0.5
        end
    end

    local function UpdateUI(state)
        Enabled = state
        if state then
            Tween(Button, {BackgroundColor3 = Theme.Primary})
            Tween(Circle, {Position = UDim2.new(1, -18, 0.5, -8)})
            Tween(HolderStroke, {Color = Theme.Primary, Transparency = 0.5})
        else
            Tween(Button, {BackgroundColor3 = Theme.Border})
            Tween(Circle, {Position = UDim2.new(0, 2, 0.5, -8)})
            Tween(HolderStroke, {Color = Theme.Border, Transparency = 0})
        end
    end

    Button.MouseButton1Click:Connect(function()
        if ToggleFunction then
            local currentState = GetStateFunction and GetStateFunction() or Enabled
            local newState = not currentState
            UpdateUI(newState)
            task.spawn(function()
                ToggleFunction()
            end)
        end
    end)

    return {
        Holder = Holder,
        Button = Button,
        GetState = function() return Enabled end,
        SetState = UpdateUI,
        Update = UpdateUI,
    }
end

-- Expose all component functions to _G for cross-loadstring access
_G.CreateTab = CreateTab
_G.CreatePage = CreatePage
_G.CreateSectionTitle = CreateSectionTitle
_G.CreateCheckbox = CreateCheckbox
_G.CreateTextBoxWithCheckbox = CreateTextBoxWithCheckbox
_G.CreateSmartCheckbox = CreateSmartCheckbox

print(" Components Loaded (JAYJAY Premium Style)")
