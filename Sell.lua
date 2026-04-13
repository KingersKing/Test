local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

local sellRemote = ReplicatedStorage
    :WaitForChild("Packages")
    :WaitForChild("_Index")
    :WaitForChild("sleitnick_knit@1.7.0")
    :WaitForChild("knit")
    :WaitForChild("Services")
    :WaitForChild("InventoryService")
    :WaitForChild("RF")
    :WaitForChild("SellBrainrot")

local enabled = false

local function trySellTool(tool)
    if not tool:IsA("Tool") then return end

    local entityId = tool:GetAttribute("EntityId")
    local mutation = tool:GetAttribute("Mutation")

    if not entityId then return end
    if mutation == "VOID" then return end

    pcall(function()
        sellRemote:InvokeServer(entityId)
    end)
end

local function scanContainer(container)
    if not container then return end
    for _, obj in ipairs(container:GetChildren()) do
        trySellTool(obj)
    end
end

-- Toggle with F
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.F then
        enabled = not enabled
        print("Auto Sell:", enabled and "ON" or "OFF")
    end
end)

-- Loop
task.spawn(function()
    while true do
        if enabled then
            scanContainer(player:FindFirstChild("Backpack"))
            scanContainer(player.Character)
        end
        task.wait(0.2)
    end
end)
