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
      Enabled = false,
      FolderName = "NeytronHub",
      FileName = "Settings"
   },
   Discord = { Enabled = false },
   KeySystem = false
})

---------------------------------------------------------
-- Сервисы
---------------------------------------------------------
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local StartLocalPlayerTeleport = Remotes:WaitForChild("StartLocalPlayerTeleport")

---------------------------------------------------------
-- Функции для телепорта
---------------------------------------------------------
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

---------------------------------------------------------
-- Вкладка Teleport
---------------------------------------------------------
local autoteleport = Window:CreateTab("teleport", 4483362458)

---------------------------------------------------------
-- 📍 Цикл телепортов 📍
---------------------------------------------------------
autoteleport:CreateLabel("📍 Цикл телепортов 📍")

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

---------------------------------------------------------
-- ⚔️ Телепорты в осады ⚔️
---------------------------------------------------------
autoteleport:CreateLabel("⚔️ Телепорты в осады ⚔️")

autoteleport:CreateButton({
    Name = "ТП в осаду 1",
    Callback = function()
        local Remotes = game:GetService("ReplicatedStorage"):WaitForChild("Remotes")

        Remotes:WaitForChild("LocalPlayerTeleport"):FireServer({mapId = 50003})
        print("Шаг 1: LocalPlayerTeleport (50003)")

        task.wait(3)

        Remotes:WaitForChild("EnterCityRaidMap"):FireServer(1000001)
        print("Шаг 2: EnterCityRaidMap (1000001)")

        Remotes:WaitForChild("StartLocalPlayerTeleport"):FireServer({mapId = 50201})
        print("Шаг 3: StartLocalPlayerTeleport (50201)")

    
        task.wait(1)
        local player = game.Players.LocalPlayer
        local char = player.Character or player.CharacterAdded:Wait()
        if char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = CFrame.new(450.82962, 3.06984854, 15998.3838) 
        end
        print("Шаг 4: Телепорт по CFrame выполнен")
    end
})

autoteleport:CreateButton({
    Name = "ТП в осаду 2",
    Callback = function()
        local Remotes = game:GetService("ReplicatedStorage"):WaitForChild("Remotes")

        Remotes:WaitForChild("LocalPlayerTeleport"):FireServer({mapId = 50007})
        print("Шаг 1: LocalPlayerTeleport (50007)")

        task.wait(3)

        Remotes:WaitForChild("EnterCityRaidMap"):FireServer(1000002)
        print("Шаг 2: EnterCityRaidMap (1000002)")

        Remotes:WaitForChild("StartLocalPlayerTeleport"):FireServer({mapId = 50202})
        print("Шаг 3: StartLocalPlayerTeleport (50202)")

        -- 🟢 Новый шаг: ожидание 1 сек и телепорт по CFrame
        task.wait(1)
        local player = game.Players.LocalPlayer
        local char = player.Character or player.CharacterAdded:Wait()
        if char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = CFrame.new(0, 10, 0) -- ⬅ сюда твои координаты
        end
        print("Шаг 4: Телепорт по CFrame выполнен")
    end
})

---------------------------------------------------------
-- 🌍 Телепорты по точкам миров 🌍
---------------------------------------------------------
autoteleport:CreateLabel("🌍 Телепорты по точкам миров 🌍")

-- Таблица: каждая точка = { mapId, CFrame }
local TeleportLocations = {
    ["Мир 1 - Точка 1"] = {mapId = 50001, cf = CFrame.new(-60.3167725, 3.52404737, 6179.13232)},
    ["Мир 1 - Точка 2"] = {mapId = 50001, cf = CFrame.new(84.9751816, 29.0378189, 6043.15576)},

    ["Мир 2 - Точка 1"] = {mapId = 50002, cf = CFrame.new(2025.04004, 1.59309697, 5672.15625)},
    ["Мир 2 - Точка 2"] = {mapId = 50002, cf = CFrame.new(1658.41565, 1.59309697, 5914.8916)},

    ["Мир 3 - Точка 1"] = {mapId = 50003, cf = CFrame.new(3960.06641, -3.84654474, 5931.3916)},
    ["Мир 3 - Точка 2"] = {mapId = 50003, cf = CFrame.new(3712.8833, 2.27105761, 5912.89014)},

    ["Мир 4 - Точка 1"] = {mapId = 50004, cf = CFrame.new(5974.3999, 24.382719, 8168.91797)},
    ["Мир 4 - Точка 2"] = {mapId = 50004, cf = CFrame.new(6030.479, 5.86975908, 7871.34375)},

    ["Мир 5 - Точка 1"] = {mapId = 50005, cf = CFrame.new(126.561058, 2.68308091, 7971.30664)},
    ["Мир 5 - Точка 2"] = {mapId = 50005, cf = CFrame.new(-128.22403, 2.68308115, 7844.58545)},

    ["Мир 6 - Точка 1"] = {mapId = 50006, cf = CFrame.new(2005.61133, 1.05377722, 8015.82422)},
   
    ["Мир 7 - Точка 1"] = {mapId = 50007, cf = CFrame.new(3867.75464, 1.48300767, 7901.0918)},
    ["Мир 7 - Точка 2"] = {mapId = 50007, cf = CFrame.new(3965.06079, 27.0371304, 8071.63477)},

    ["Мир 8 - Точка 1"] = {mapId = 50008, cf = CFrame.new(5177.2793, -403.153809, 8880.75781)},
    ["Мир 8 - Точка 2"] = {mapId = 50008, cf = CFrame.new(4815.97461, -403.153839, 8651.83008)},

    ["Мир 9 - Точка 1"] = {mapId = 50009, cf = CFrame.new(-3.31273031, 5.81415415, 10240.6885)},

    ["Мир 10 - Точка 1"] = {mapId = 50010, cf = CFrame.new(1763.28625, 1.14412689, 10277.6768)},
    
}

local SelectedTP = "Мир 1 - Точка 1"

-- Собираем все варианты
local Options = {}
for name in pairs(TeleportLocations) do
    table.insert(Options, name)
end

-- Сортировка: мир → точка
table.sort(Options, function(a, b)
    local numA, pointA = string.match(a, "Мир (%d+) %- Точка (%d+)")
    local numB, pointB = string.match(b, "Мир (%d+) %- Точка (%d+)")
    numA, pointA, numB, pointB = tonumber(numA), tonumber(pointA), tonumber(numB), tonumber(pointB)
    if numA == numB then
        return pointA < pointB
    else
        return numA < numB
    end
end)

autoteleport:CreateDropdown({
    Name = "Выбери точку",
    Options = Options,
    CurrentOption = {SelectedTP},
    Flag = "WorldTPOption",
    Callback = function(option)
        SelectedTP = option[1]
        print("Выбрана точка:", SelectedTP)
    end,
})

autoteleport:CreateButton({
    Name = "Телепортироваться",
    Callback = function()
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local hrp = character:WaitForChild("HumanoidRootPart")

        local data = TeleportLocations[SelectedTP]
        if data then
            -- Шаг 1: телепорт в мир
            Remotes:WaitForChild("StartLocalPlayerTeleport"):FireServer({mapId = data.mapId})
            print("Телепорт в мир:", data.mapId)

            -- Шаг 2: ждём 3 секунды и ставим CFrame
            task.wait(1.5)
            hrp.CFrame = data.cf
            print("Телепортирован в точку:", SelectedTP)
        else
            warn("Точка "..SelectedTP.." не найдена!")
        end
    end
})

---------------------------------------------------------
-- Вкладка Main
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

---------------------------------------------------------
-- Вкладка Potions
---------------------------------------------------------
local PotionTab = Window:CreateTab("Potions", 4483362458)

local PotionIds = {
    ["Средняя удачи"] = 10047,
    ["Средняя дмг"] = 10048,
    ["Средняя монет"] = 10049,
    ["Большая удачи"] = 10050,
    ["Большая дмг"] = 10051,
    ["Большая монет"] = 10052,
}

local SelectedPotion = "Средняя удачи"
local PotionCount = 1

PotionTab:CreateDropdown({
    Name = "Выбери зелье",
    Options = {"Средняя удачи","Средняя дмг","Средняя монет","Большая удачи","Большая дмг","Большая монет"},
    CurrentOption = {"Средняя удачи"},
    Flag = "PotionType",
    Callback = function(option)
        SelectedPotion = option[1]
        print("Выбрано зелье:", SelectedPotion, "ID:", PotionIds[SelectedPotion])
    end,
})

PotionTab:CreateSlider({
    Name = "Количество",
    Range = {1, 5},
    Increment = 1,
    CurrentValue = 1,
    Flag = "PotionCount",
    Callback = function(value)
        PotionCount = value
        print("Количество установлено:", PotionCount)
    end,
})

PotionTab:CreateButton({
    Name = "Скрафтить",
    Callback = function()
        local args = {{
            id = PotionIds[SelectedPotion],
            count = PotionCount
        }}
        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("PotionMerge"):InvokeServer(unpack(args))
        print("Скрафтил:", PotionCount, "x", SelectedPotion, "(ID:", PotionIds[SelectedPotion],")")
    end
})
