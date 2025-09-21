    local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

    local Window = Rayfield:CreateWindow({
    Name = "NeytronHub",
    Icon = 0,
    LoadingTitle = "Загрузка...",
    LoadingSubtitle = "NUTON221",
    ShowText = "NeytronHub",
    Theme = "AmberGlow",
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

    -- Новый модуль с поддержкой транспорта
    local function teleportToRaidEnemy()
        local enemiesFolder = workspace:FindFirstChild("Enemys")
        if not enemiesFolder then
            warn("❌ Папка Enemys не найдена")
            return
        end

        local mob1 = enemiesFolder:FindFirstChild("Legia")
        local mob2 = enemiesFolder:FindFirstChild("Frostborne")
        local target = mob1 or mob2

        if not target or not target:FindFirstChild("HumanoidRootPart") then
            warn("❌ Ни один из нужных мобов не найден")
            return
        end

        local player = game.Players.LocalPlayer
        local character = player.Character
        local hrp = character and character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        -- Проверяем, есть ли транспорт
        local seat = hrp:FindFirstChildWhichIsA("VehicleSeat") or hrp:FindFirstChildWhichIsA("Seat")
        if seat and seat:IsA("BasePart") then
            seat.CFrame = target.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
            print("✅ Телепорт транспорта к мобу:", target.Name)
        else
            character:SetPrimaryPartCFrame(target.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0))
            print("✅ Телепорт игрока к мобу:", target.Name)
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

-- список героев
local Heroes = {
    ["arise nuton"] = "Hero_1420811697",
    ["arise ivan"] = "Hero_8694797078",
    ["arise dvoynik"] = "Hero_774897891"
}

local SelectedHero = "arise nuton"

-- функция вызова
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

-- создаем GUI с кнопкой (изначально скрыт)
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.Enabled = false

local Button = Instance.new("TextButton")
Button.Size = UDim2.new(0, 120, 0, 50)
Button.Position = UDim2.new(0.5, -60, 0.5, -25)
Button.Text = "Arise"
Button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Button.TextColor3 = Color3.fromRGB(230, 230, 230)
Button.Font = Enum.Font.SourceSansBold
Button.TextSize = 20
Button.BackgroundTransparency = 0.2
Button.Parent = ScreenGui

-- крестик
local Close = Instance.new("TextButton")
Close.Size = UDim2.new(0, 20, 0, 20)
Close.Position = UDim2.new(1, -24, 0, 2)
Close.Text = "X"
Close.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
Close.TextColor3 = Color3.fromRGB(255, 100, 100)
Close.Font = Enum.Font.SourceSansBold
Close.TextSize = 16
Close.BackgroundTransparency = 0.3
Close.Parent = Button

-- закрытие крестиком
Close.MouseButton1Click:Connect(function()
    ScreenGui.Enabled = false
end)

-- действие кнопки
local function callHero()
    local heroFolder = Heroes[SelectedHero]
    if heroFolder then
        teleportHeroes(heroFolder)
    end
end

Button.MouseButton1Click:Connect(function(x, y)
    -- если клик был не по крестику
    local pos = UserInputService:GetMouseLocation()
    if not (pos.X > Close.AbsolutePosition.X 
        and pos.X < Close.AbsolutePosition.X + Close.AbsoluteSize.X
        and pos.Y > Close.AbsolutePosition.Y
        and pos.Y < Close.AbsolutePosition.Y + Close.AbsoluteSize.Y) then
        callHero()
    end
end)

-- биндим на клавишу E
UserInputService.InputBegan:Connect(function(input, gp)
    if not gp and input.KeyCode == Enum.KeyCode.E then
        callHero()
    end
end)

-- перетаскивание
local dragging = false
local dragStart, startPos
local function update(input)
    local delta = input.Position - dragStart
    Button.Position = UDim2.new(
        startPos.X.Scale, startPos.X.Offset + delta.X,
        startPos.Y.Scale, startPos.Y.Offset + delta.Y
    )
end
Button.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        -- не даём тянуть, если жмут по крестику
        if input.Position.X > Close.AbsolutePosition.X 
        and input.Position.X < Close.AbsolutePosition.X + Close.AbsoluteSize.X
        and input.Position.Y > Close.AbsolutePosition.Y
        and input.Position.Y < Close.AbsolutePosition.Y + Close.AbsoluteSize.Y then
            return
        end
        dragging = true
        dragStart = input.Position
        startPos = Button.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        update(input)
    end
end)

-- Dropdown выбора героя
MainTab:CreateDropdown({
    Name = "Выбери Arise героя",
    Options = {"arise nuton","arise ivan","arise dvoynik"},
    CurrentOption = {"arise nuton"},
    Callback = function(option)
        SelectedHero = option[1]
        Button.Text = option[1] -- на кнопке пишем имя выбранного
    end,
})

-- Toggle для показа кнопки
MainTab:CreateToggle({
    Name = "Показать кнопку Arise",
    CurrentValue = false,
    Flag = "AriseToggle",
    Callback = function(state)
        ScreenGui.Enabled = state
    end
})

-- UI Toggle панелей
local gui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
local func1Panel = gui:WaitForChild("HeroEquipGradePanel",10)
local func2Panel = gui:WaitForChild("QuirkNewPanel",10)

MainTab:CreateLabel("🎛UI toggle🎛 ")

MainTab:CreateButton({
    Name = "Точильня аксов",
    Callback = function() if func1Panel then func1Panel.Enabled = not func1Panel.Enabled end end
})
MainTab:CreateButton({
    Name = "Перки Теней",
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
-- Вкладка 4: ⚡ Misc (цикл телепорта по порядку)
---------------------------------------------------------
local MiscTab = Window:CreateTab("Misc", 4483362458)

MiscTab:CreateLabel("⏱ Цикл телепорта по мирам ⏱")

local loopEnabled = false
local delayTime = 15
local SelectedWorlds = {"1"} -- по умолчанию

-- слайдер задержки
MiscTab:CreateSlider({
    Name = "Время между тп",
    Range = {1, 60},
    Increment = 1,
    CurrentValue = 15,
    Callback = function(value) delayTime = value end,
})

-- список миров 1..10
local WorldOptions = {}
for i = 1, 10 do table.insert(WorldOptions, tostring(i)) end

MiscTab:CreateDropdown({
    Name = "Выбери миры для цикла",
    Options = WorldOptions,
    CurrentOption = {"1"},
    MultipleOptions = true, -- множественный выбор
    Callback = function(option)
        SelectedWorlds = option
    end,
})

-- вспомогательная: парсим выбор и возвращаем отсортированный список чисел
local function getSortedWorldList(selection)
    local nums = {}
    if type(selection) == "table" then
        for _, v in ipairs(selection) do
            local n = tonumber(v)
            if n and n >= 1 and n <= 10 then table.insert(nums, n) end
        end
    else
        local n = tonumber(selection)
        if n and n >= 1 and n <= 10 then table.insert(nums, n) end
    end
    if #nums == 0 then return {} end
    table.sort(nums)
    -- убираем дубли
    local uniq = {}
    for i = 1, #nums do
        if nums[i] ~= nums[i-1] then table.insert(uniq, nums[i]) end
    end
    return uniq
end

-- toggle запуска/остановки цикла
MiscTab:CreateToggle({
    Name = "Запустить цикл телепорта",
    CurrentValue = false,
    Callback = function(state)
        loopEnabled = state
        if loopEnabled then
            task.spawn(function()
                while loopEnabled do
                    local worlds = getSortedWorldList(SelectedWorlds)
                    if #worlds == 0 then
                        warn("⚠️ Не выбран ни один мир для цикла.")
                        loopEnabled = false
                        break
                    end

                    for _, worldNum in ipairs(worlds) do
                        if not loopEnabled then break end
                        local id = 50000 + worldNum
                        StartLocalPlayerTeleport:FireServer({mapId = id})
                        -- ждать delayTime секунд
                        local t = 0
                        while t < delayTime and loopEnabled do
                            task.wait(0.25)
                            t = t + 0.25
                        end
                    end
                end
            end)
        end
    end,
})

    -- Загружаем сохранённые настройки
    Rayfield:LoadConfiguration()
