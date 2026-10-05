-- ==================================================
-- YOKUDO HUB | FEATURE | Anti Trap
-- ✅ Remove ONLY "PlayerTrap" Prefix in workspace.Transient
-- ✅ Loop រាល់ 0.5s
-- ==================================================

local AntiTrapEnabled = false
local RemoveThread = nil

-- ==================================================
-- PREFIX FILTER
-- ==================================================
local TRAP_PREFIX = "PlayerTrap"

-- ==================================================
-- REMOVE ONLY TRAP CHILDREN
-- ==================================================
local function RemoveTrapChildren()
    local Transient = workspace:FindFirstChild("Transient")
    if not Transient then return 0 end

    local Count = 0
    for _, child in ipairs(Transient:GetChildren()) do
        if child.Name:sub(1, #TRAP_PREFIX) == TRAP_PREFIX then
            pcall(function()
                child:Destroy()
                Count = Count + 1
            end)
        end
    end

    return Count
end

-- ==================================================
-- ENABLE
-- ==================================================
local function EnableAntiTrap()
    if AntiTrapEnabled then return end
    AntiTrapEnabled = true

    -- ✅ លុបភ្លាមម្តង
    RemoveTrapChildren()

    -- ✅ Loop រាល់ 0.5s
    if RemoveThread then
        pcall(function() task.cancel(RemoveThread) end)
        RemoveThread = nil
    end

    RemoveThread = task.spawn(function()
        while AntiTrapEnabled do
            task.wait(0.5)
            if AntiTrapEnabled then
                local T = RemoveTrapChildren()
                if T > 0 then
                    print("[AntiTrap] Removed", T, "PlayerTrap(s)")
                end
            end
        end
    end)

    print("[AntiTrap] ON")
end

-- ==================================================
-- DISABLE
-- ==================================================
local function DisableAntiTrap()
    if not AntiTrapEnabled then return end
    AntiTrapEnabled = false

    if RemoveThread then
        pcall(function() task.cancel(RemoveThread) end)
        RemoveThread = nil
    end

    print("[AntiTrap] OFF")
end

-- ==================================================
-- TOGGLE
-- ==================================================
local function ToggleAntiTrap()
    if AntiTrapEnabled then
        DisableAntiTrap()
    else
        EnableAntiTrap()
    end
end

-- ==================================================
-- EXPORT
-- ==================================================
_G.YOKUDO_AntiTrap = {
    Toggle = ToggleAntiTrap,
    Enable = EnableAntiTrap,
    Disable = DisableAntiTrap,
    IsEnabled = function() return AntiTrapEnabled end,
    RemoveTrapChildren = RemoveTrapChildren,
    TRAP_PREFIX = TRAP_PREFIX,
}

print("✅ AntiTrap Feature Loaded (PlayerTrap Only)")
