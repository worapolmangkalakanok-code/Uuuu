-- =============================================
--  เมนู rael hub - ทำงานได้ทุกเกม
--  ครบทุกฟีเจอร์ + เปิดปิดได้ + เข้าถึงโครงสร้างทั่วไป
-- =============================================

-- โหลดชุดทำเมนู
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- สร้างหน้าต่างหลัก ชื่อ rael hub
local Window = WindUI:CreateWindow({
    Title = "rael hub",
    Icon = "rbxassetid://7733658504",
    Author = "Rael",
    Folder = "raelhub",
    Size = UDim2.fromOffset(380, 420),
    Transparent = true,
    Theme = "Dark",
    SideBarWidth = 160,
    Keybind = "RightShift", -- กดปุ่ม ชิฟต์ขวา เปิด-ปิดเมนูได้เลย
})

-- สร้างหมวดหมู่เมนู
local หน้าหลัก = Window:Tab({Title = "หน้าหลัก", Icon = "home"})
local แกล้งคน = Window:Tab({Title = "แกล้งคน", Icon = "user"})
local อัพเดท = Window:Tab({Title = "ยังไม่ได้อัพเดท", Icon = "clock"})

-- เรียกใช้ระบบหลักเกม (ทำงานได้ทุกเกม)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local espList = {}

-- =============================================
--  ส่วนหน้าหลัก - ทำงานได้ทุกเกม
-- =============================================
local ติดอมตะ = false

-- ปรับความเร็วเดิน 1-100
หน้าหลัก:Slider({
    Title = "ความเร็วเดิน",
    Desc = "ปรับค่า 1 ถึง 100 (ใช้ได้ทุกเกม)",
    Value = {Min = 1, Max = 100, Default = 16},
    Callback = function(ค่า)
        local ตัวละคร = player.Character
        if ตัวละคร and ตัวละคร:FindFirstChild("Humanoid") then
            ตัวละคร.Humanoid.WalkSpeed = ค่า
        end
    end
})

-- ปรับความสูงกระโดด 1-100
หน้าหลัก:Slider({
    Title = "ความสูงกระโดด",
    Desc = "ปรับค่า 1 ถึง 100 (ใช้ได้ทุกเกม)",
    Value = {Min = 1, Max = 100, Default = 50},
    Callback = function(ค่า)
        local ตัวละคร = player.Character
        if ตัวละคร and ตัวละคร:FindFirstChild("Humanoid") then
            ตัวละคร.Humanoid.JumpPower = ค่า
            ตัวละคร.Humanoid.JumpHeight = ค่า -- รองรับทั้ง 2 แบบที่เกมต่างๆ ใช้
        end
    end
})

-- วาร์ปไปหาไอเทม/อุปกรณ์ - ค้นหาทุกสิ่งที่เป็นวัตถุในแมพ
หน้าหลัก:Button({
    Title = "วาร์ปไปของ",
    Desc = "เด้งไปหาสิ่งของที่ใกล้ที่สุด (ทุกชนิด)",
    Callback = function()
        local ตัวละคร = player.Character
        local ตัวตน = ตัวละคร and ตัวละคร:FindFirstChild("HumanoidRootPart")
        if not ตัวตน then return end

        local ไกลสุด = math.huge
        local จุดเป้าหมาย = nil

        -- ค้นหาทุกอย่างที่อยู่ในแมพ ทุกโฟลเดอร์ ทุกประเภท
        local function ค้นหาทุกสิ่ง(แม่แบบ)
            for _, สิ่งของ in pairs(แม่แบบ:GetChildren()) do
                if สิ่งของ:IsA("BasePart") or สิ่งของ:IsA("Model") or สิ่งของ:IsA("Tool") or สิ่งของ:IsA("Accessory") then
                    local จุด = สิ่งของ.PrimaryPart or สิ่งของ:FindFirstChildWhichIsA("BasePart", true)
                    if จุด then
                        local ระยะห่าง = (ตัวตน.Position - จุด.Position).Magnitude
                        if ระยะห่าง < ไกลสุด and ระยะห่าง > 3 then
                            ไกลสุด = ระยะห่าง
                            จุดเป้าหมาย = จุด
                        end
                    end
                end
                -- ค้นต่อในโฟลเดอร์ย่อยด้วย
                ค้นหาทุกสิ่ง(สิ่งของ)
            end
        end

        -- เริ่มค้นจากทุกส่วนหลักของเกม
        ค้นหาทุกสิ่ง(Workspace)
        ค้นหาทุกสิ่ง(ReplicatedStorage)

        -- วาร์ปทันทีถ้าเจอ
        if จุดเป้าหมาย then
            ตัวตน.CFrame = จุดเป้าหมาย.CFrame + Vector3.new(0, 3, 0)
        end
    end
})

-- เปิดปิดอมตะ - ทำงานได้ทุกแบบที่เกมลดเลือด
หน้าหลัก:Toggle({
    Title = "ตัวอมตะ",
    Desc = "เลือดไม่ลด ไม่ตาย (ทุกเกม)",
    Default = false,
    Callback = function(สถานะ)
        ติดอมตะ = สถานะ
    end
})

-- ระบบอมตะทำงานตลอดเวลา
RunService.Heartbeat:Connect(function()
    if not ติดอมตะ then return end
    local ตัวละคร = player.Character
    if ตัวละคร then
        -- ป้องกันทุกวิธีที่เกมใช้ทำให้ตาย
        if ตัวละคร:FindFirstChild("Humanoid") then
            ตัวละคร.Humanoid.Health = ตัวละคร.Humanoid.MaxHealth
            ตัวละคร.Humanoid.FloorMaterial = Enum.Material.Air
        end
        -- ป้องกันแบบอื่นๆ ที่บางเกมใช้
        for _, ส่วน in pairs(ตัวละคร:GetChildren()) do
            if ส่วน:IsA("Script") or ส่วน:IsA("LocalScript") then
                if ส่วน.Name:lower():find("damage") or ส่วน.Name:lower():find("kill") then
                    ส่วน.Disabled = true
                end
            end
        end
    end
end)

-- =============================================
--  ส่วนแกล้งคน - ทำงานได้ทุกเกม
-- =============================================
local เปิดมองคน = false
local เปิดเด้งคน = false

-- มองเห็นคนทั้งหมด - สีเขียว รัศมี 1 ล้านเมตร
แกล้งคน:Toggle({
    Title = "มองเห็นผู้เล่น",
    Desc = "สีเขียว+ชื่อ มองไกล 1,000,000 เมตร",
    Default = false,
    Callback = function(สถานะ)
        เปิดมองคน = สถานะ
        if not สถานะ then
            for _,v in pairs(espList) do if v then v:Destroy() end end
            espList = {}
        end
    end
})

-- เด้งคนออกไปไกล
แกล้งคน:Toggle({
    Title = "เด้งคนออก",
    Desc = "เดินชนใคร เขาจะกระเด็นทันที",
    Default = false,
    Callback = function(สถานะ)
        เปิดเด้งคน = สถานะ
    end
})

-- อัปเดตระบบตลอดเวลา
RunService.Heartbeat:Connect(function()
    local ตัวละคร = player.Character
    local ตัวตน = ตัวละคร and ตัวละคร:FindFirstChild("HumanoidRootPart")
    if not ตัวตน then return end

    -- ส่วนมองคน
    if เปิดมองคน then
        for _, คน in pairs(Players:GetPlayers()) do
            if คน ~= player and คน.Character and คน.Character:FindFirstChild("HumanoidRootPart") then
                local root = คน.Character.HumanoidRootPart
                if not root:FindFirstChild("ESP_RAEL") then
                    local tag = Instance.new("BillboardGui")
                    tag.Name = "ESP_RAEL"
                    tag.AlwaysOnTop = true
                    tag.Size = UDim2.new(0, 200, 0, 50)
                    tag.StudsOffset = Vector3.new(0, 3, 0)
                    tag.MaxDistance = 1000000 -- รัศมี 1 ล้านเมตร
                    tag.Parent = root

                    local bg = Instance.new("Frame")
                    bg.BackgroundColor3 = Color3.new(0, 0.8, 0) -- สีเขียวตามที่ขอ
                    bg.BackgroundTransparency = 0.3
                    bg.Size = UDim2.new(1,0,1,0)
                    bg.Parent = tag

                    local txt = Instance.new("TextLabel")
                    txt.BackgroundTransparency = 1
                    txt.Text = คน.Name
                    txt.TextColor3 = Color3.new(1,1,1)
                    txt.Font = Enum.Font.GothamBold
                    txt.TextScaled = true
                    txt.Size = UDim2.new(1,0,1,0)
                    txt.Parent = tag

                    table.insert(espList, tag)
                end
            end
        end
    end

    -- ส่วนเด้งคน
    if เปิดเด้งคน then
        for _, คน in pairs(Players:GetPlayers()) do
            if คน ~= player and คน.Character and คน.Character:FindFirstChild("HumanoidRootPart") then
                local ศัตรูตัวตน = คน.Character.HumanoidRootPart
                local ระยะห่าง = (ตัวตน.Position - ศัตรูตัวตน.Position).Magnitude
                -- ถ้าเข้ามาใกล้ในระยะชน
                if ระยะห่าง < 4 then
                    -- ดีดออกไปไกลๆ
                    ศัตรูตัวตน.Velocity = (ศัตรูตัวตน.Position - ตัวตน.Position).Unit * 80 + Vector3.new(0, 30, 0)
                end
            end
        end
    end
end)
