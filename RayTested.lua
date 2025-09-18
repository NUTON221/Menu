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

---------------------------------------------------------
-- Телепорт в осаду 1 
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
    end
})

---------------------------------------------------------
-- Телепорт в осаду 2
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
-- Вкладка Main
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

-- исправленный поиск панелей
main:CreateButton({
    Name = "Переключить range панель",
    Callback = function()
        local player = game:GetService("Players").LocalPlayer
        local playerGui = player:WaitForChild("PlayerGui")
        local panel = playerGui:WaitForChild("HeroEquipGradePanel")
        if panel and typeof(panel.Enabled) == "boolean" then
            panel.Enabled = not panel.Enabled
            print("HeroEquipGradePanel Enabled =", panel.Enabled)
        else
            warn("HeroEquipGradePanel не имеет свойства Enabled")
        end
    end
})

main:CreateButton({
    Name = "Переключить enchant панель",
    Callback = function()
        local player = game:GetService("Players").LocalPlayer
        local playerGui = player:WaitForChild("PlayerGui")
        local panel = playerGui:WaitForChild("QuirkNewPanel")
        if panel and typeof(panel.Enabled) == "boolean" then
            panel.Enabled = not panel.Enabled
            print("QuirkNewPanel Enabled =", panel.Enabled)
        else
            warn("QuirkNewPanel не имеет свойства Enabled")
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
