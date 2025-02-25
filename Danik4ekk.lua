local playersService = game:FindFirstChild("Players - Client") or game:FindFirstChild("Players")
local player = playersService and playersService.LocalPlayer
local targetName = "Danik4ekk"
local VirtualInputManager = game:GetService("VirtualInputManager")

-- ⏳ Ждем загрузки игрока
repeat
    print("⏳ Жду загрузки игрока...")
    task.wait(1)
    playersService = game:FindFirstChild("Players - Client") or game:FindFirstChild("Players")
    player = playersService and playersService.LocalPlayer
until player and player.Character and player.Character:FindFirstChild("HumanoidRootPart")

print("✅ Локальный игрок загружен!")

-- **🔁 Первый цикл (телепорт)**
spawn(function()
    while true do
        task.wait(0.1) -- Телепорт каждые 0.1 сек

        if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local rootPart = player.Character.HumanoidRootPart
            local targetPlayer = playersService:FindFirstChild(targetName)

            if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local targetCFrame = targetPlayer.Character.HumanoidRootPart.CFrame
                rootPart.CFrame = targetCFrame + Vector3.new(0, 3, 0) -- Поднимаем, чтобы не застрять
                print("✅ Телепорт к " .. targetName)
            else
                warn("❌ Игрок " .. targetName .. " не найден!")
            end
        else
            warn("❌ Локальный игрок не загружен! Жду перезагрузку...")
            repeat
                task.wait(1)
                print("⏳ Жду перезагрузку персонажа...")
            until player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        end
    end
end)
