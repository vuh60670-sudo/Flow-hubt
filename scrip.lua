local _P = game:GetService("Players")
local _RS = game:GetService("RunService")
local _lp = _P.LocalPlayer

_G._KillActive = false
_G._TargetPlayer = nil

-- 1. XÓA UI CŨ
if _lp.PlayerGui:FindFirstChild("HungHub_SmartSync") then _lp.PlayerGui.HungHub_SmartSync:Destroy() end

local _Gui = Instance.new("ScreenGui", _lp.PlayerGui)
_Gui.Name = "HungHub_SmartSync"

-- 2. DÒNG CHỮ "HÙNG MẠNH THÍ" RAINBOW
local _Aura = Instance.new("TextLabel", _Gui)
_Aura.Size = UDim2.new(0, 200, 0, 30)
_Aura.Position = UDim2.new(1, -210, 1, -40)
_Aura.BackgroundTransparency = 1
_Aura.Text = "HÙNG MẠNH THÍ"
_Aura.Font = Enum.Font.Arcade
_Aura.TextSize = 25
_Aura.TextStrokeTransparency = 0
_Aura.TextXAlignment = Enum.TextXAlignment.Right

task.spawn(function()
    while task.wait(0.1) do
        _Aura.TextColor3 = Color3.fromHSV(tick() % 5 / 5, 1, 1)
    end
end)

-- 3. BẢNG ĐIỀU KHIỂN
local _Main = Instance.new("Frame", _Gui)
_Main.Size = UDim2.new(0, 220, 0, 320)
_Main.Position = UDim2.new(0.5, -110, 0.3, 0)
_Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
_Main.Draggable = true
_Main.Active = true

local _Title = Instance.new("TextLabel", _Main)
_Title.Size = UDim2.new(1, 0, 0, 35)
_Title.Text = "HÙNG HUB - SMART SYNC"
_Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
_Title.TextColor3 = Color3.new(1, 1, 1)
_Title.Font = Enum.Font.Arcade

-- [Phần Refresh/Scroll giữ nguyên logic cũ của ông]
local _Scroll = Instance.new("ScrollingFrame", _Main)
_Scroll.Size = UDim2.new(0.9, 0, 0, 140)
_Scroll.Position = UDim2.new(0.05, 0, 0.15, 0)
_Scroll.CanvasSize = UDim2.new(0, 0, 10, 0)
_Scroll.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
local _UIList = Instance.new("UIListLayout", _Scroll)

local function _Refresh()
    for _, c in pairs(_Scroll:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
    for _, p in pairs(_P:GetPlayers()) do
        if p ~= _lp then
            local _b = Instance.new("TextButton", _Scroll)
            _b.Size = UDim2.new(1, 0, 0, 30)
            _b.Text = p.Name
            _b.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            _b.TextColor3 = Color3.new(1, 1, 1)
            _b.Font = Enum.Font.Arcade
            _b.MouseButton1Click:Connect(function() 
                _G._TargetPlayer = p 
                _Title.Text = "TARGET: " .. p.Name:sub(1, 8)
            end)
        end
    end
end

local _Kill = Instance.new("TextButton", _Main)
_Kill.Size = UDim2.new(0.9, 0, 0, 50)
_Kill.Position = UDim2.new(0.05, 0, 0.78, 0)
_Kill.Text = "BẬT CHẾ ĐỘ DIỆT"
_Kill.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
_Kill.Font = Enum.Font.Arcade

-- 4. LOGIC THÔNG MINH (TỰ THẢ KHI MÁU THẤP)
_RS.Stepped:Connect(function()
    if _G._KillActive and _G._TargetPlayer then
        local _myChar = _lp.Character
        local _tChar = _G._TargetPlayer.Character
        
        if _myChar and _myChar:FindFirstChild("Humanoid") and _tChar and _tChar:FindFirstChild("HumanoidRootPart") then
            -- KIỂM TRA MÁU CỦA HÙNG
            local _myHP = (_myChar.Humanoid.Health / _myChar.Humanoid.MaxHealth) * 100
            
            if _myHP <= 35 then
                -- Nếu máu dưới 35%, tự động tắt ghim để script kia tele đi
                _G._KillActive = false
                _Kill.Text = "THẢ (MÁU THẤP!)"
                _Kill.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
                return 
            end
            
            -- Nếu máu ổn, tiếp tục kéo và đấm
            local _th = _tChar.HumanoidRootPart
            local _mh = _myChar.HumanoidRootPart
            
            _mh.CFrame = CFrame.new(_th.Position + Vector3.new(0, 25, 0), _th.Position)
            _th.CFrame = _mh.CFrame * CFrame.new(0, 0, -1.2)
            
            _mh.Velocity = Vector3.zero
            _th.Velocity = Vector3.zero
            
            _myChar.Humanoid:ChangeState(11)
            game:GetService("VirtualUser"):ClickButton1(Vector2.new(0,0))
        end
    end
end)

_Kill.MouseButton1Click:Connect(function()
    _G._KillActive = not _G._KillActive
    _Kill.Text = _G._KillActive and "ĐANG CHÉN..." or "BẬT CHẾ ĐỘ DIỆT"
    _Kill.BackgroundColor3 = _G._KillActive and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
end)

local _Reset = Instance.new("TextButton", _Main)
_Reset.Size = UDim2.new(0.9, 0, 0, 30)
_Reset.Position = UDim2.new(0.05, 0, 0.62, 0)
_Reset.Text = "RESET PLAYER"
_Reset.Font = Enum.Font.Arcade
_Reset.MouseButton1Click:Connect(_Refresh)

_Refresh()
