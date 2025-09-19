local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "NeytronHub",
   Icon = 0,
   LoadingTitle = "Загрузка...",
   LoadingSubtitle = "NUTON221",
   ShowText = "NeytronHub",
   Theme = "Amethyst",
   ToggleUIKeybind = "V",
   ConfigurationSaving = {
      Enabled = true,
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
-- Вкладка 1: 🗺 Teleport
---------------------------------------------------------
local TeleportTab = Window:CreateTab("Teleport", 4483362458)

TeleportTab:CreateLabel("🌍 Телепорты по точкам миров 🌍")

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
local Options = {}
for name in pairs(TeleportLocations) do table.insert(Options, name) end
table.sort(Options, function(a,b)
    local na,pa = string.match(a,"Мир (%d+) %- Точка (%d+)")
    local nb,pb = string.match(b,"Мир (%d+) %- Точка (%d+)")
    na,pa,nb,pb = tonumber(na),tonumber(pa),tonumber(nb),tonumber(pb)
    return (na==nb) and pa<pb or na<nb
end)

TeleportTab:CreateDropdown({
    Name = "Выбери точку",
    Options = Options,
    CurrentOption = {SelectedTP},
    Callback = function(option)
        SelectedTP = option[1]
    end,
})

TeleportTab:CreateButton({
    Name = "Телепортироваться",
    Callback = function()
        local player = game.Players.LocalPlayer
        local hrp = player.Character:WaitForChild("HumanoidRootPart")
        local data = TeleportLocations[SelectedTP]
        if data then
            Remotes.StartLocalPlayerTeleport:FireServer({mapId = data.mapId})
            task.wait(1.5)
            hrp.CFrame = data.cf
        end
    end
})
TeleportTab:CreateLabel("⚔️ Телепорты в осады ⚔️")

local function teleportToRaidEnemy()
    local enemiesFolder = workspace:FindFirstChild("Enemys")
    if not enemiesFolder then
        print("Папка Enemys не найдена")
        return
    end

    local mob1 = enemiesFolder:FindFirstChild("Legia")
    local mob2 = enemiesFolder:FindFirstChild("Frostborne")
    local target = mob1 or mob2

    if target and target:FindFirstChild("HumanoidRootPart") then
        game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(target.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0))
        print("Телепорт к мобу: " .. target.Name)
    else
        print("Ни один из нужных мобов не найден")
    end
end

TeleportTab:CreateButton({
    Name = "ТП в осаду 1",
    Callback = function()
        Remotes.LocalPlayerTeleport:FireServer({mapId = 50003})
        task.wait(1.5)
        Remotes.EnterCityRaidMap:FireServer(1000001)
        Remotes.StartLocalPlayerTeleport:FireServer({mapId = 50201})
        task.wait(3)
        teleportToRaidEnemy()
    end
})

TeleportTab:CreateButton({
    Name = "ТП в осаду 2",
    Callback = function()
        Remotes.LocalPlayerTeleport:FireServer({mapId = 50007})
        task.wait(1.5)
        Remotes.EnterCityRaidMap:FireServer(1000002)
        Remotes.StartLocalPlayerTeleport:FireServer({mapId = 50202})
        task.wait(3)
        teleportToRaidEnemy()
    end
})
---------------------------------------------------------
-- Вкладка 2: ⚙️ Main
---------------------------------------------------------
local MainTab = Window:CreateTab("Main", 4483362458)

MainTab:CreateLabel("🦸‍♂️ Вызов героев 🦸‍♂️")

local function teleportHeroes(folderName)
    local hrp = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
    local folder = workspace:WaitForChild("Heros"):FindFirstChild(folderName)
    if not folder then return end
    for _, hero in ipairs(folder:GetChildren()) do
        if hero:IsA("Model") and hero:FindFirstChild("HumanoidRootPart") then
            hero:MoveTo(hrp.Position + Vector3.new(math.random(-5,5),0,math.random(-5,5)))
        end
    end
end

MainTab:CreateButton({Name = "arise nuton", Callback = function() teleportHeroes("Hero_1420811697") end})
MainTab:CreateButton({Name = "arise ivan", Callback = function() teleportHeroes("Hero_8694797078") end})
MainTab:CreateButton({Name = "arise dvoynik", Callback = function() teleportHeroes("Hero_774897891") end})

local gui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
local func1Panel = gui:WaitForChild("HeroEquipGradePanel",10)
local func2Panel = gui:WaitForChild("QuirkNewPanel",10)

MainTab:CreateLabel("🎛UI toggle🎛 ")

MainTab:CreateButton({
    Name = "Переключить range панель",
    Callback = function() if func1Panel then func1Panel.Enabled = not func1Panel.Enabled end end
})
MainTab:CreateButton({
    Name = "Переключить enchant панель",
    Callback = function() if func2Panel then func2Panel.Enabled = not func2Panel.Enabled end end
})

---------------------------------------------------------
-- Вкладка 3: 🧪 Potion
---------------------------------------------------------
local PotionTab = Window:CreateTab("Potion", 4483362458)

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
    Callback = function(option) SelectedPotion = option[1] end,
})

PotionTab:CreateSlider({
    Name = "Количество",
    Range = {1, 5},
    Increment = 1,
    CurrentValue = 1,
    Callback = function(value) PotionCount = value end,
})

PotionTab:CreateButton({
    Name = "Скрафтить",
    Callback = function()
        Remotes.PotionMerge:InvokeServer({id=PotionIds[SelectedPotion], count=PotionCount})
    end
})

---------------------------------------------------------
-- Вкладка 4: ⚡ Misc
---------------------------------------------------------
local MiscTab = Window:CreateTab("Misc", 4483362458)

MiscTab:CreateLabel("⏱ Цикл телепорта 1-10 ⏱")

local loopEnabled = false
local delayTime = 15

MiscTab:CreateSlider({
    Name = "Время между тп",
    Range = {1, 60},
    Increment = 1,
    CurrentValue = 15,
    Callback = function(value) delayTime = value end,
})

MiscTab:CreateToggle({
    Name = "Цикл телепорта 50001-50010",
    CurrentValue = false,
    Callback = function(state)
        loopEnabled = state
        if loopEnabled then
            task.spawn(function()
                while loopEnabled do
                    for id=50001,50010 do
                        if not loopEnabled then break end
                        StartLocalPlayerTeleport:FireServer({mapId=id})
                        local t=0
                        while t<delayTime and loopEnabled do
                            task.wait(0.25) t+=0.25
                        end
                    end
                end
            end)
        end
    end
})
Rayfield:LoadConfiguration()
