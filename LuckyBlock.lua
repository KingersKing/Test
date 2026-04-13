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

-- Toggle with V
UserInputService.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	if input.KeyCode == Enum.KeyCode.V then
		enabled = not enabled
		print("LuckyBlock loop:", enabled)
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

			-- STEP 2: scan backpack
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

			-- 🚨 If no LuckyBlocks found, pause script
			if #foundIds == 0 then
				print("No LuckyBlocks left. Script paused until re-enabled.")
				enabled = false
				continue
			end

			task.wait(0.25)

			-- STEP 3: open placed blocks
			for _,id in ipairs(foundIds) do
				pcall(function()
					openRemote:InvokeServer(id)
				end)
			end

			-- STEP 4: wait before repeating
			task.wait(10)

		else
			task.wait(0.05)
		end
	end
end)
