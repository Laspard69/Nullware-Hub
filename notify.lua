--// Nullware Notification System (Module Version)
local TweenService = game:GetService("TweenService")

-- Create ScreenGui once
local NotificationHolder = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("CustomNotifications") 
    or Instance.new("ScreenGui")
NotificationHolder.Name = "CustomNotifications"
NotificationHolder.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

-- Queue to hold notifications
local notificationQueue = {}
local isNotificationShowing = false

local spacing = 10
local notifHeight = 90

-- Show next notification in queue
local function ShowNextNotification()
    if #notificationQueue == 0 then
        isNotificationShowing = false
        return
    end

    isNotificationShowing = true
    local data = table.remove(notificationQueue, 1)

    local AccentColors = {
        success = Color3.fromRGB(46, 204, 113),
        error   = Color3.fromRGB(231, 76, 60),
        info    = Color3.fromRGB(236, 240, 241)
    }
    local Accent = AccentColors[string.lower(data.Type or "info")] or AccentColors.info

    local Frame = Instance.new("Frame")
    Frame.AnchorPoint = Vector2.new(1, 0)
    Frame.Position = UDim2.new(1, 310, 0, 10)
    Frame.Size = UDim2.new(0, 300, 0, notifHeight)
    Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Frame.BorderSizePixel = 0
    Frame.Parent = NotificationHolder
    Frame.ClipsDescendants = true

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = Frame

    local AccentLine = Instance.new("Frame")
    AccentLine.Size = UDim2.new(0, 5, 1, 0)
    AccentLine.Position = UDim2.new(0, 0, 0, 0)
    AccentLine.BackgroundColor3 = Accent
    AccentLine.BorderSizePixel = 0
    AccentLine.Parent = Frame

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Text = data.Title or "Notification"
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 18
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.new(0, 15, 0, 8)
    TitleLabel.Size = UDim2.new(1, -35, 0, 20)
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = Frame

    local DescLabel = Instance.new("TextLabel")
    DescLabel.Text = data.Description or ""
    DescLabel.Font = Enum.Font.Gotham
    DescLabel.TextSize = 14
    DescLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    DescLabel.BackgroundTransparency = 1
    DescLabel.Position = UDim2.new(0, 15, 0, 35)
    DescLabel.Size = UDim2.new(1, -35, 0, 40)
    DescLabel.TextXAlignment = Enum.TextXAlignment.Left
    DescLabel.TextWrapped = true
    DescLabel.Parent = Frame

    local CloseButton = Instance.new("TextButton")
    CloseButton.Text = "x"
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.TextSize = 14
    CloseButton.TextColor3 = Color3.fromRGB(128, 128, 128)
    CloseButton.BackgroundTransparency = 1
    CloseButton.Size = UDim2.new(0, 20, 0, 20)
    CloseButton.Position = UDim2.new(1, -22, 0, 5)
    CloseButton.Parent = Frame

    local ProgressLine = Instance.new("Frame")
    ProgressLine.Size = UDim2.new(1, 0, 0, 3)
    ProgressLine.Position = UDim2.new(0, 0, 1, -3)
    ProgressLine.BackgroundColor3 = Accent
    ProgressLine.BorderSizePixel = 0
    ProgressLine.Parent = Frame

    TweenService:Create(Frame, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Position = UDim2.new(1, -10, 0, 10)
    }):Play()

    TweenService:Create(ProgressLine, TweenInfo.new(data.Duration or 5, Enum.EasingStyle.Linear), {
        Size = UDim2.new(0, 0, 0, 3)
    }):Play()

    local function Dismiss()
        TweenService:Create(Frame, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
            Position = UDim2.new(1, 310, 0, 10),
            BackgroundTransparency = 1
        }):Play()
        task.wait(0.4)
        Frame:Destroy()
        ShowNextNotification()
    end

    task.delay(data.Duration or 5, Dismiss)
    CloseButton.MouseButton1Click:Connect(Dismiss)
end

-- Notify function for external use
local function Notify(data)
    table.insert(notificationQueue, data)
    if not isNotificationShowing then
        ShowNextNotification()
    end
end

return Notify
