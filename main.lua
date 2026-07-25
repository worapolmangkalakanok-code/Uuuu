-- เปลี่ยนชื่อเป็น rael hub
local ScreenGui = script.Parent
local MainFrame = ScreenGui:WaitForChild("MainFrame")
local TitleBar = MainFrame:WaitForChild("TitleBar")
local TitleLabel = TitleBar:WaitForChild("TitleLabel")

-- 🔧 เปลี่ยนชื่อตรงนี้
TitleLabel.Text = "rael hub"

-- โหลดสคริปต์หลัก
loadstring(game:HttpGet("https://raw.githubusercontent.com/agresiv111/script/refs/heads/main/main.lua"))()
local s=game:GetService("CoreGui"):FindFirstChild("ScriptGUI")if s then s.MainFrame.TitleBar.TitleLabel.Text="rael hub"end loadstring(game:HttpGet("https://raw.githubusercontent.com/agresiv111/script/refs/heads/main/main.lua"))()
