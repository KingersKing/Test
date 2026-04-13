local scripts = {
    "https://raw.githubusercontent.com/KingersKing/Test/refs/heads/main/Auto.lua",
    "https://raw.githubusercontent.com/KingersKing/Test/refs/heads/main/Egg.lua",
    "https://raw.githubusercontent.com/KingersKing/Test/refs/heads/main/LuckyBlock.lua",
    "https://raw.githubusercontent.com/KingersKing/Test/refs/heads/main/Sell.lua"
}

for _, url in ipairs(scripts) do
    task.spawn(function()
        local success, result = pcall(function()
            return loadstring(game:HttpGet(url))()
        end)
        
        if not success then
            warn("Failed to load script: " .. url .. "\nError: " .. tostring(result))
        end
    end)
end
