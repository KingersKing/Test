local Players = game:GetService("Players")
local player = Players.LocalPlayer

local function getRoot()
	local runningFolder = workspace:FindFirstChild("RunningModels")
	local runningModel = runningFolder and runningFolder:FindFirstChild(tostring(player.UserId))

	if not runningModel then
		return nil
	end

	return runningModel:FindFirstChild("HumanoidRootPart")
		or runningModel:FindFirstChildWhichIsA("BasePart")
end

while true do
	local root = getRoot()

	-- ONLY works if running model exists AND is past X = 700
	if root and root.Position.X > 700 then
		for _, obj in pairs(workspace:GetChildren()) do
			if obj:IsA("Model") and string.match(obj.Name, "^EGG%d+$") then

				for _, v in pairs(obj:GetDescendants()) do
					if v:IsA("BasePart") then
						v.CFrame = root.CFrame
						v.AssemblyLinearVelocity = Vector3.zero
						v.AssemblyAngularVelocity = Vector3.zero
					end
				end

			end
		end
	end

	task.wait(0.2)
end
