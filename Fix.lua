local ReplicatedStorage = game:GetService("ReplicatedStorage")

local remote = ReplicatedStorage
    :WaitForChild("Packages")
    :WaitForChild("_Index")
    :WaitForChild("sleitnick_knit@1.7.0")
    :WaitForChild("knit")
    :WaitForChild("Services")
    :WaitForChild("PlayerService")
    :WaitForChild("RF")
    :WaitForChild("ReloadCharacter")

local running = true

task.spawn(function()
    while running do
        pcall(function()
            remote:InvokeServer()
        end)

        task.wait(180) -- 3 minutes
    end
end)

-- optional stop function
_G.StopReloadLoop = function()
    running = false
end
