
local TweenService = game:GetService("TweenService")

local function Resolve(name)
    return getfenv()[name] or _G[name] or (getgenv and type(getgenv) == "function" and getgenv()[name])
end

local CreateTab = CreateTab or Resolve("CreateTab")
local CreatePage = CreatePage or Resolve("CreatePage")
local CreateSectionTitle = CreateSectionTitle or Resolve("CreateSectionTitle")
local CreateCheckbox = CreateCheckbox or Resolve("CreateCheckbox")
local CreateTextBoxWithCheckbox = CreateTextBoxWithCheckbox or Resolve("CreateTextBoxWithCheckbox")
local CreateSmartCheckbox = CreateSmartCheckbox or Resolve("CreateSmartCheckbox")

local TabsManager = {}
TabsManager.Tabs = {}
TabsManager.Pages = {}
TabsManager.ActiveTab = nil
TabsManager.ActivePage = nil

function TabsManager:RegisterTab(Name, Order, PageName)
    local tabFn = CreateTab or Resolve("CreateTab")
    local pageFn = CreatePage or Resolve("CreatePage")
    
    if not tabFn or not pageFn then
        warn("❌ TabsManager: CreateTab or CreatePage not available for " .. tostring(Name))
        return nil, nil
    end

    local Tab = tabFn(Name, Order)
    local Page = pageFn(PageName or Name:upper())
    
    table.insert(self.Tabs, { Tab = Tab, Page = Page, Name = Name })
    
    Tab.MouseButton1Click:Connect(function()
        self:SelectTab(Tab, Page)
    end)
    
    return Tab, Page
end

function TabsManager:SelectTab(SelectedTab, SelectedPage)
    for _, data in ipairs(self.Tabs) do
        data.Page.Visible = false
        local Indicator = data.Tab:FindFirstChild("Indicator")
        local TabText = data.Tab:FindFirstChild("TabText")
        TweenService:Create(data.Tab, TweenInfo.new(0.15), {BackgroundTransparency = 1}):Play()
        if Indicator then
            TweenService:Create(Indicator, TweenInfo.new(0.15), {Size = UDim2.new(0, 4, 0, 0), BackgroundTransparency = 1}):Play()
        end
        if TabText then
            TweenService:Create(TabText, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(155, 155, 175)}):Play()
        end
    end

    SelectedPage.Visible = true
    task.wait(0.05)
    pcall(function()
        SelectedPage.CanvasPosition = Vector2.new(0, 0)
    end)

    TweenService:Create(SelectedTab, TweenInfo.new(0.15), {BackgroundTransparency = 0}):Play()
    local Indicator = SelectedTab:FindFirstChild("Indicator")
    local TabText = SelectedTab:FindFirstChild("TabText")
    if Indicator then
        TweenService:Create(Indicator, TweenInfo.new(0.15), {Size = UDim2.new(0, 4, 0, 20), BackgroundTransparency = 0}):Play()
    end
    if TabText then
        TweenService:Create(TabText, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
    end

    self.ActiveTab = SelectedTab
    self.ActivePage = SelectedPage
end
function TabsManager:GetTab(Name)
    for _, data in ipairs(self.Tabs) do
        if data.Name == Name then
            return data.Tab, data.Page
        end
    end
    return nil, nil
end
function TabsManager:SelectTabByName(Name)
    local Tab, Page = self:GetTab(Name)
    if Tab and Page then
        self:SelectTab(Tab, Page)
    end
end
_G.JAYJAY_TabsManager = TabsManager

print(" Tabs Manager Loaded")
