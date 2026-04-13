local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local backpack = player:WaitForChild("Backpack")

local knit = ReplicatedStorage:WaitForChild("Packages")
    :WaitForChild("_Index")
    :WaitForChild("sleitnick_knit@1.7.0")
    :WaitForChild("knit")

local pickupRemote = knit:WaitForChild("Services"):WaitForChild("ContainerService"):WaitForChild("RF"):WaitForChild("PickupBrainrot")
local placeRemote = knit:WaitForChild("Services"):WaitForChild("ContainerService"):WaitForChild("RF"):WaitForChild("Place")
local openRemote = knit:WaitForChild("Services"):WaitForChild("LuckyBlockService"):WaitForChild("RF"):WaitForChild("Open")

local enabled = false

-- Function to check Backpack AND Character (in case item is equipped)
local function hasLuckyBlocks()
    local char = player.Character
    
    -- Check Backpack
    for _, item in ipairs(backpack:GetChildren()) do
        if item.Name:find("LuckyBlock") then return true end
    end
    
    -- Check Character (Equipped items)
    if char then
        for _, item in ipairs(char:GetChildren()) do
            if item:IsA("Tool") and item.Name:find("LuckyBlock") then return true end
        end
    end
    
    return false
end

-- Toggle with V
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    
    if input.KeyCode == Enum.KeyCode.V then
        if not enabled then
            -- HARD BLOCK: If search returns false, we stop here.
            if not hasLuckyBlocks() then
                warn("❌ ACTION REJECTED: No LuckyBlocks found in inventory or equipped!")
                return 
            end
            
            enabled = true
            print("✅ LuckyBlock loop: STARTED")
        else
            enabled = false
            print("🛑 LuckyBlock loop: STOPPED")
        end
    end
end)

task.spawn(function()
    while true do
        if enabled then
            -- STEP 1: Pickup slots 1-30
            for i = 1,30 do
                pcall(function()
                    pickupRemote:InvokeServer(tostring(i))
                end)
            end

            task.wait(0.25)

            local foundIds = {}
            local slot = 1

            -- STEP 2: scan backpack (items usually go here after pickup)
            for _,item in ipairs(backpack:GetChildren()) do
                if slot > 30 then break end
                if item.Name:find("LuckyBlock") then
                    local id = item:GetAttribute("EntityId")
                    if id then
                        table.insert(foundIds, id)
                        pcall(function()
                            placeRemote:InvokeServer(id, tostring(slot))
                        end)
                        slot += 1
                    end
                end
            end

            -- If nothing was found after the pickup attempt, kill the loop
            if #foundIds == 0 then
                warn("Empty: Auto-disabling.")
                enabled = false
            else
                task.wait(0.25)
                -- STEP 3: open placed blocks
                for _,id in ipairs(foundIds) do
                    pcall(function()
                        openRemote:InvokeServer(id)
                    end)
                end
                task.wait(10)
            end
        else
            task.wait(0.1)
        end
    end
end)
