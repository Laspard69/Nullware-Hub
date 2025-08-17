--// Nullware Notification System
return function()
    local Players = game:GetService("Players")
    local TweenService = game:GetService("TweenService")

    local player = Players.LocalPlayer
    local PlayerGui = player:WaitForChild("PlayerGui")

    -- ScreenGui (create once, reuse if exists)
    local screenGui = PlayerGui:FindFirstChild("NullwareNotifyGui") or Instance.new("ScreenGui")
    screenGui.Name = "NullwareNotifyGui"
    screenGui.Parent = PlayerGui

    -- Track active notifications
    local activeNotifs = {}
    local spacing = 90 -- height + gap

    local function UpdateNotificationPositions()
        for i, notif in ipairs(activeNotifs) do
            local targetPos = UDim2.new(1, -20, 1, -(20 + (i - 1) * spacing))
            TweenService:Create(notif, TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Position = targetPos
            }):Play()
        end
    end

    -- Function to create a notification
    local function CreateNotification(title, content, duration)
        duration = duration or 5

        -- Main Frame
        local notifyFrame = Instance.new("Frame")
        notifyFrame.AnchorPoint = Vector2.new(1, 1)
        notifyFrame.Size = UDim2.new(0, 250, 0, 80)
        notifyFrame.Position = UDim2.new(1, -20, 1, 100) -- Start below screen
        notifyFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        notifyFrame.BorderSizePixel = 0
        notifyFrame.BackgroundTransparency = 0.2
        notifyFrame.Parent = screenGui

        table.insert(activeNotifs, 1, notifyFrame) -- add to top of stack
        UpdateNotificationPositions()

        -- Title
        local titleLabel = Instance.new("TextLabel")
        titleLabel.Size = UDim2.new(1, -10, 0, 25)
        titleLabel.Position = UDim2.new(0, 5, 0, 5)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Font = Enum.Font.GothamBold
        titleLabel.Text = title
        titleLabel.TextColor3 = Color3.fromRGB(255, 50, 50) -- 🔴 Red title
        titleLabel.TextSize = 16
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.Parent = notifyFrame

        -- Content
        local contentLabel = Instance.new("TextLabel")
        contentLabel.Size = UDim2.new(1, -10, 0, 20)
        contentLabel.Position = UDim2.new(0, 5, 0, 35)
        contentLabel.BackgroundTransparency = 1
        contentLabel.Font = Enum.Font.Gotham
        contentLabel.Text = content
        contentLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        contentLabel.TextSize = 14
        contentLabel.TextXAlignment = Enum.TextXAlignment.Left
        contentLabel.Parent = notifyFrame

        -- Progress Line
        local progress = Instance.new("Frame")
        progress.Size = UDim2.new(1, 0, 0, 3)
        progress.Position = UDim2.new(0, 0, 1, -3)
        progress.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        progress.BorderSizePixel = 0
        progress.Parent = notifyFrame

        -- Animate progress bar
        TweenService:Create(progress, TweenInfo.new(duration, Enum.EasingStyle.Linear), {
            Size = UDim2.new(0, 0, 0, 3)
        }):Play()

        -- Wait and fade out
        task.delay(duration, function()
            local fadeOut = TweenService:Create(notifyFrame, TweenInfo.new(0.5), {BackgroundTransparency = 1})
            fadeOut:Play()
            fadeOut.Completed:Wait()
            notifyFrame:Destroy()

            -- remove from stack & update positions
            for i, notif in ipairs(activeNotifs) do
                if notif == notifyFrame then
                    table.remove(activeNotifs, i)
                    break
                end
            end
            UpdateNotificationPositions()
        end)
    end

    return CreateNotification
end
