local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "NeytronHub",
   Icon = 0,
   LoadingTitle = "Загрузка...",
   LoadingSubtitle = "NUTON221",
   ShowText = "NeytronHub",
   Theme = "Amethyst",
   ToggleUIKeybind = "K",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "NeytronHub",
      FileName = "Settings"
   },
   Discord = { Enabled = false },
   KeySystem = false
})

---------------------------------------------------------
-- Телепорты по mapId (циклично)
---------------------------------------------------------
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local StartLocalPlayerTeleport = Remotes:WaitForChild("StartLocalPlayerTeleport")

local loopEnabled = false
local delayTime = 15

local function safeFire(mapId)
    local args = { { mapId = mapId } }
    local ok, err = pcall(function()
        StartLocalPlayerTeleport:FireServer(unpack(args))
    end)
    if not ok then
        warn("Ошибка при отправке StartLocalPlayerTeleport:", err)
    end
end

local autoteleport = Window:CreateTab("teleport", 4483362458)

autoteleport:CreateSlider({
    Name = "Время между тп",
    Range = {1, 60},
    Increment = 1,
    Suffix = "сек",
    CurrentValue = 15,
    Flag = "DelayTime",
    Callback = function(value)
        delayTime = value
        print("Новая задержка:", delayTime, "секунд")
    end,
})

autoteleport:CreateToggle({
    Name = "Цикл телепорта 50001-50010",
    CurrentValue = false,
    Flag = "TeleportLoop",
    Callback = function(state)
        loopEnabled = state
        if loopEnabled then
            print("Цикл телепорта запущён")
            task.spawn(function()
                while loopEnabled do
                    for id = 50001, 50010 do
                        if not loopEnabled then break end
                        safeFire(id)
                        print("Отправлен mapId:", id)
                        local step = 0.25
                        local elapsed = 0
                        while elapsed < delayTime and loopEnabled do
                            task.wait(step)
                            elapsed += step
                        end
                        if not loopEnabled then break end
                    end
                end
                print("Цикл телепорта остановлен")
            end)
        else
            print("Цикл телепорта выключен")
        end
    end
})

-- 🔹 Новая кнопка: телепорт в осаду 1
autoteleport:CreateButton({
    Name = "ТП в осаду 1",
    Callback = function()
        local Remotes = game:GetService("ReplicatedStorage"):WaitForChild("Remotes")

        Remotes:WaitForChild("EnterCityRaidMap"):FireServer(1000001)

        print("✅ Телепорт в осаду 1 выполнен")
    end
})


-- 🔹 Новая кнопка: телепорт в осаду 2 (повтор)
autoteleport:CreateButton({
    Name = "ТП в осаду 2",
    Callback = function()
        local Remotes = game:GetService("ReplicatedStorage"):WaitForChild("Remotes")

        -- шаг 1
        Remotes:WaitForChild("EnterCityRaidMap"):FireServer(1000002)

        print("✅ Телепорт в осаду 1 выполнен")
    end
})

---------------------------------------------------------
-- Телепорт героев из папки к игроку
---------------------------------------------------------
local function teleportHeroes(folderName)
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local hrp = character:WaitForChild("HumanoidRootPart")

    local heroesFolder = workspace:WaitForChild("Heros"):FindFirstChild(folderName)
    if not heroesFolder then
        warn("Папка "..folderName.." не найдена в workspace.Heros")
        return
    end

    for _, hero in ipairs(heroesFolder:GetChildren()) do
        if hero:IsA("Model") and hero:FindFirstChild("HumanoidRootPart") then
            hero:MoveTo(hrp.Position + Vector3.new(math.random(-5,5), 0, math.random(-5,5)))
        end
    end
end

---------------------------------------------------------
-- Вкладка Main с кнопками arise + осада
---------------------------------------------------------
local main = Window:CreateTab("Main", 4483362458)

main:CreateButton({
    Name = "arise nuton",
    Callback = function()
        teleportHeroes("Hero_1420811697")
    end
})

main:CreateButton({
    Name = "arise ivan",
    Callback = function()
        teleportHeroes("Hero_8694797078")
    end
})

main:CreateButton({
    Name = "arise dvoynik",
    Callback = function()
        teleportHeroes("Hero_774897891")
    end
})


---------------------------------------------------------
-- Кнопки для HeroEquipGradePanel и QuirkNewPanel
---------------------------------------------------------
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local func1Panel = playerGui:WaitForChild("HeroEquipGradePanel", 10)
local func2Panel = playerGui:WaitForChild("QuirkNewPanel", 10)

main:CreateButton({
    Name = "Переключить range панель",
    Callback = function()
        if func1Panel and typeof(func1Panel.Enabled) == "boolean" then
            func1Panel.Enabled = not func1Panel.Enabled
            print("HeroEquipGradePanel Enabled =", func1Panel.Enabled)
        else
            warn("HeroEquipGradePanel не найдена или не имеет свойства Enabled")
        end
    end
})

main:CreateButton({
    Name = "Переключить enchant панель",
    Callback = function()
        if func2Panel and typeof(func2Panel.Enabled) == "boolean" then
            func2Panel.Enabled = not func2Panel.Enabled
            print("QuirkNewPanel Enabled =", func2Panel.Enabled)
        else
            warn("QuirkNewPanel не найдена или не имеет свойства Enabled")
        end
    end
})

Rayfield:LoadConfiguration()
