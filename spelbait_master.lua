local playersService = game:FindFirstChild("Players - Client") or game:FindFirstChild("Players")
local player = playersService and playersService.LocalPlayer
local targetName = "spelbait_master"
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

-- **🔁 Второй цикл (нажатие на кнопку "Rematch")**
spawn(function()
    while true do
        task.wait(1) -- Проверка кнопки каждую секунду

        if player then
            local guiPath = player:FindFirstChild("PlayerGui")
            if guiPath then
                local button = guiPath:FindFirstChild("MainGui", true)
                    and guiPath.MainGui:FindFirstChild("MainFrame", true)
                    and guiPath.MainGui.MainFrame:FindFirstChild("DuelInterfaces", true)
                    and guiPath.MainGui.MainFrame.DuelInterfaces:FindFirstChild("DuelInterface", true)
                    and guiPath.MainGui.MainFrame.DuelInterfaces.DuelInterface:FindFirstChild("GameResult", true)
                    and guiPath.MainGui.MainFrame.DuelInterfaces.DuelInterface.GameResult:FindFirstChild("Corner", true)
                    and guiPath.MainGui.MainFrame.DuelInterfaces.DuelInterface.GameResult.Corner:FindFirstChild("Buttons", true)
                    and guiPath.MainGui.MainFrame.DuelInterfaces.DuelInterface.GameResult.Corner.Buttons:FindFirstChild("Rematch", true)
                    and guiPath.MainGui.MainFrame.DuelInterfaces.DuelInterface.GameResult.Corner.Buttons.Rematch:FindFirstChild("Button", true)

                if button and button.Visible and button.Parent.Visible then
                    print("✅ Кнопка 'Rematch' видима! Нажимаю...")

                    -- **Настройка точности клика**
                    local correctionX = 0 -- Увеличь (15, 20) если нужно правее
                    local correctionY = 100  -- Чем больше число, тем ниже клик

                    -- **Расчет координат**
                    local clickX = button.AbsolutePosition.X + (button.AbsoluteSize.X / 2) + correctionX
                    local clickY = button.AbsolutePosition.Y + (button.AbsoluteSize.Y / 2) + correctionY

                    print("🎯 Координаты клика: X=" .. clickX .. " Y=" .. clickY)

                    local success, err = pcall(function()
                        -- Используем VirtualInputManager
                        VirtualInputManager:SendMouseButtonEvent(
                            clickX, clickY,
                            0, -- Левая кнопка мыши
                            true, -- Нажатие
                            game, 0
                        )
                        task.wait(0.1)
                        VirtualInputManager:SendMouseButtonEvent(
                            clickX, clickY,
                            0, -- Левая кнопка мыши
                            false, -- Отпускание
                            game, 0
                        )
                    end)

                    if not success then
                        warn("❌ Ошибка при нажатии кнопки: " .. tostring(err))
                    else
                        print("✅ Кнопка 'Rematch' успешно нажата!")
                    end
                else
                    print("⏳ Кнопка 'Rematch' пока НЕ видима. Жду...")
                end
            end
        end
    end
end)
