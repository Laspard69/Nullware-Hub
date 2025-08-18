--// Nullware Notification System
return function()
    local Players = game:GetService("Players")
    local TweenService = game:GetService("TweenService")

    local player = Players.LocalPlayer
    local PlayerGui = player:WaitForChild("PlayerGui")

    -- ScreenGui (create once, reuse if exists)
    local screenGui = PlayerGui:FindFirstChild("NullwareNotifyGui")
    if not screenGui then
        screenGui = Instance.new("ScreenGui")
        screenGui.Name = "NullwareNotifyGui"
        screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        screenGui.ResetOnSpawn = false
        screenGui.Parent = PlayerGui
    end

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
        notifyFrame.Size = UDim2.new(0, 300, 0, 80) -- Slightly wider for better text
        notifyFrame.Position = UDim2.new(1, -20, 1, 100) -- Start below screen
        notifyFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        notifyFrame.BorderSizePixel = 0
        notifyFrame.BackgroundTransparency = 0.2
        notifyFrame.ZIndex = 100 -- Ensure it appears above Pepi UI
        notifyFrame.Parent = screenGui

        -- UI Corner for better aesthetics
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = notifyFrame

        table.insert(activeNotifs, 1, notifyFrame) -- add to top of stack
        UpdateNotificationPositions()

        -- Title
        local titleLabel = Instance.new("TextLabel")
        titleLabel.Size = UDim2.new(1, -10, 0, 25)
        titleLabel.Position = UDim2.new(0, 5, 0, 5)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Font = Enum.Font.GothamBold
        titleLabel.Text = title
        titleLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
        titleLabel.TextSize = 16
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.ZIndex = notifyFrame.ZIndex + 1
        titleLabel.Parent = notifyFrame

        -- Content (improved to handle longer text)
        local contentLabel = Instance.new("TextLabel")
        contentLabel.Size = UDim2.new(1, -10, 1, -30)
        contentLabel.Position = UDim2.new(0, 5, 0, 30)
        contentLabel.BackgroundTransparency = 1
        contentLabel.Font = Enum.Font.Gotham
        contentLabel.Text = content
        contentLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        contentLabel.TextSize = 14
        contentLabel.TextXAlignment = Enum.TextXAlignment.Left
        contentLabel.TextYAlignment = Enum.TextYAlignment.Top
        contentLabel.TextWrapped = true
        contentLabel.ZIndex = notifyFrame.ZIndex + 1
        contentLabel.Parent = notifyFrame

        -- Progress Line (improved visibility)
        local progressContainer = Instance.new("Frame")
        progressContainer.Size = UDim2.new(1, 0, 0, 3)
        progressContainer.Position = UDim2.new(0, 0, 1, -3)
        progressContainer.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        progressContainer.BorderSizePixel = 0
        progressContainer.ZIndex = notifyFrame.ZIndex + 1
        progressContainer.Parent = notifyFrame

        local progress = Instance.new("Frame")
        progress.Size = UDim2.new(1, 0, 1, 0)
        progress.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        progress.BorderSizePixel = 0
        progress.ZIndex = notifyFrame.ZIndex + 2
        progress.Parent = progressContainer

        -- Animate progress bar
        TweenService:Create(progress, TweenInfo.new(duration, Enum.EasingStyle.Linear), {
            Size = UDim2.new(0, 0, 1, 0)
        }):Play()

        -- Wait and fade out
        task.delay(duration, function()
            local fadeOut = TweenService:Create(notifyFrame, TweenInfo.new(0.5), {
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -20, 1, 100) -- Slide down while fading
            })
            
            -- Fade text elements too
            TweenService:Create(titleLabel, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
            TweenService:Create(contentLabel, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
            
            fadeOut:Play()
            fadeOut.Completed:Wait()
            
            -- Remove from stack
            for i, notif in ipairs(activeNotifs) do
                if notif == notifyFrame then
                    table.remove(activeNotifs, i)
                    break
                end
            end
            
            notifyFrame:Destroy()
            UpdateNotificationPositions()
        end)
    end

    return CreateNotification
end
