local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

local selectedBase = 15
local loopEnabled = false

local cooldownUntil = 0 -- << ADD THIS

local baseCFrames = {
	[1] = CFrame.new(651.586548, 53.5382652, -2123.02686),
	[2] = CFrame.new(560.892456, 53.5382652, -2123.02686),
	[3] = CFrame.new(474.647186, 53.5382652, -2123.02686),
	[4] = CFrame.new(387.586548, 53.5382652, -2123.02686),
	[5] = CFrame.new(293.892456, 53.5382652, -2123.02686),
	[6] = CFrame.new(207.647186, 53.5382652, -2123.02686),
	[7] = CFrame.new(126.586548, 53.5382652, -2123.02686),
	[8] = CFrame.new(44.892456, 53.5382652, -2123.02686),
	[9] = CFrame.new(-48.647186, 53.5382652, -2123.02686),
	[10] = CFrame.new(-137.586548, 53.5382652, -2123.02686),
	[11] = CFrame.new(-217.892456, 53.5382652, -2123.02686),
	[12] = CFrame.new(-291.647186, 53.5382652, -2123.02686),
	[13] = CFrame.new(-356.892456, 53.5382652, -2123.02686),
	[14] = CFrame.new(-428.647186, 53.5382652, -2123.02686),
	[15] = CFrame.new(-518.190002, 53.5382652, -2123.02686)
}

local secondCFrame = CFrame.new(741, 38, -2066)
local fallbackCFrame = CFrame.new(690, 38, -2121)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end

	if input.KeyCode == Enum.KeyCode.C then
		loopEnabled = not loopEnabled
		print("Base loop:", loopEnabled and "STARTED" or "STOPPED")
	end
end)

RunService.Heartbeat:Connect(function()
	if not loopEnabled then return end

	-- 🔥 GLOBAL COOLDOWN BLOCK
	if os.clock() < cooldownUntil then
		return
	end

	local originalFirstCFrame = baseCFrames[selectedBase] or baseCFrames[15]

	local character = player.Character
	local hrp = character and character:FindFirstChild("HumanoidRootPart")

	local runningModelsFolder = workspace:FindFirstChild("RunningModels")
	local runningModel = runningModelsFolder and runningModelsFolder:FindFirstChild(tostring(player.UserId))

	if runningModel then
		for _, part in ipairs(runningModel:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CFrame = originalFirstCFrame
			end
		end
		return
	end

	if hrp then
		local chasedSign = hrp:FindFirstChild("PlayerChasedSign")

		if chasedSign and (
			chasedSign:IsA("BillboardGui")
			or chasedSign:IsA("SurfaceGui")
			or chasedSign:IsA("ScreenGui")
		) then
			if chasedSign.Enabled then
				hrp.CFrame = secondCFrame
			else
				hrp.CFrame = originalFirstCFrame
				return
			end
			return
		end
	end

	-- ✅ FALLBACK (this is now the trigger)
	if hrp then
		hrp.CFrame = fallbackCFrame
		cooldownUntil = os.clock() + 1.25
	end
end)
