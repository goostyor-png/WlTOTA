--[[
    LOCAL IMAGE SPAWNER
    Mobile-friendly 3D image editor
    LocalScript for Roblox Studio.
    Place in StarterPlayer > StarterPlayerScripts.
]]

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local MOVE_STEP = 0.5
local ROTATE_STEP = 15
local SCALE_STEP = 0.5

local images = Instance.new("Folder")
images.Name = "LocalImages_" .. player.UserId
images.Parent = workspace

local selected = nil
local placing = false
local originalCFrame = nil
local originalSize = nil

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "LocalImageEditor"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 310, 0, 440)
main.Position = UDim2.new(0, 12, 0.5, -220)
main.BackgroundColor3 = Color3.fromRGB(25, 27, 36)
main.BorderSizePixel = 0
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 14)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(42, 47, 65)
title.Text = "LOCAL IMAGE EDITOR"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextSize = 17
title.Font = Enum.Font.GothamBold
title.Parent = main
Instance.new("UICorner", title).CornerRadius = UDim.new(0, 12)

local scroll = Instance.new("ScrollingFrame")
scroll.Position = UDim2.new(0, 8, 0, 48)
scroll.Size = UDim2.new(1, -16, 1, -56)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 4
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.Parent = main

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 6)
layout.Parent = scroll

local function makeLabel(text)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -4, 0, 25)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(150, 190, 255)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 13
    label.Parent = scroll
    return label
end

local function makeButton(text, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -4, 0, 38)
    button.BackgroundColor3 = Color3.fromRGB(55, 65, 90)
    button.Text = text
    button.TextColor3 = Color3.new(1, 1, 1)
    button.TextSize = 14
    button.Font = Enum.Font.GothamBold
    button.Parent = scroll
    Instance.new("UICorner", button).CornerRadius = UDim.new(0, 8)
    button.Activated:Connect(callback)
    return button
end

local idBox = Instance.new("TextBox")
idBox.Size = UDim2.new(1, -4, 0, 40)
idBox.BackgroundColor3 = Color3.fromRGB(40, 43, 55)
idBox.PlaceholderText = "Paste image Asset ID..."
idBox.Text = ""
idBox.TextColor3 = Color3.new(1, 1, 1)
idBox.PlaceholderColor3 = Color3.fromRGB(170, 170, 170)
idBox.Font = Enum.Font.Gotham
idBox.TextSize = 14
idBox.ClearTextOnFocus = false
idBox.Parent = scroll
Instance.new("UICorner", idBox).CornerRadius = UDim.new(0, 8)

local status = makeLabel("Status: Ready")

local function setStatus(message)
    status.Text = "Status: " .. message
end

local function createImage(id, position, normal)
    local part = Instance.new("Part")
    part.Name = "LocalImage"
    part.Size = Vector3.new(4, 3, 0.05)
    part.Anchored = true
    part.CanCollide = false
    part.CanTouch = false
    part.CanQuery = false
    part.Material = Enum.Material.SmoothPlastic
    part.Color = Color3.new(1, 1, 1)

    normal = normal or Vector3.new(0, 0, -1)
    part.CFrame = CFrame.lookAt(position + normal * 0.05, position + normal)
    part.Parent = images

    local decal = Instance.new("Decal")
    decal.Name = "Image"
    decal.Texture = "rbxassetid://" .. id
    decal.Face = Enum.NormalId.Front
    decal.Parent = part

    selected = part
    originalCFrame = part.CFrame
    originalSize = part.Size
    setStatus("Image created")
end

makeButton("PLACE IMAGE", function()
    local id = idBox.Text:match("%d+")
    if not id then
        setStatus("Enter a valid image ID")
        return
    end
    placing = true
    setStatus("Tap a location in the world")
end)

UIS.InputBegan:Connect(function(input, processed)
    if not placing or processed then
        return
    end

    if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseButton1 then

        local pos = input.Position
        local ray = camera:ViewportPointToRay(pos.X, pos.Y)

        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Exclude
        params.FilterDescendantsInstances = {
            player.Character,
            images
        }

        local result = workspace:Raycast(ray.Origin, ray.Direction * 500, params)

        if result then
            local id = idBox.Text:match("%d+")
            createImage(id, result.Position, result.Normal)
            placing = false
        else
            setStatus("No surface found")
        end
    end
end)

-- Movement is in world X/Y/Z axes.
makeLabel("MOVEMENT")

local function move(x, y, z)
    if selected then
        selected.Position += Vector3.new(x, y, z)
    end
end

makeButton("X -", function() move(-MOVE_STEP, 0, 0) end)
makeButton("X +", function() move(MOVE_STEP, 0, 0) end)
makeButton("Y +", function() move(0, MOVE_STEP, 0) end)
makeButton("Y -", function() move(0, -MOVE_STEP, 0) end)
makeButton("Z +", function() move(0, 0, MOVE_STEP) end)
makeButton("Z -", function() move(0, 0, -MOVE_STEP) end)

-- Rotation uses the part's local axes.
makeLabel("ROTATION")

local function rotate(x, y, z)
    if selected then
        selected.CFrame = selected.CFrame * CFrame.Angles(
            math.rad(x), math.rad(y), math.rad(z)
        )
    end
end

makeButton("Rotate X +15", function() rotate(ROTATE_STEP, 0, 0) end)
makeButton("Rotate X -15", function() rotate(-ROTATE_STEP, 0, 0) end)
makeButton("Rotate Y +15", function() rotate(0, ROTATE_STEP, 0) end)
makeButton("Rotate Y -15", function() rotate(0, -ROTATE_STEP, 0) end)
makeButton("Rotate Z +15", function() rotate(0, 0, ROTATE_STEP) end)
makeButton("Rotate Z -15", function() rotate(0, 0, -ROTATE_STEP) end)

makeLabel("SIZE")

local function resize(amount)
    if not selected then
        return
    end

    local size = selected.Size
    selected.Size = Vector3.new(
        math.max(0.2, size.X + amount),
        math.max(0.2, size.Y + amount),
        0.05
    )
end

makeButton("Increase size", function() resize(SCALE_STEP) end)
makeButton("Decrease size", function() resize(-SCALE_STEP) end)

makeLabel("OTHER")

makeButton("RESET POSITION AND SIZE", function()
    if selected and originalCFrame and originalSize then
        selected.CFrame = originalCFrame
        selected.Size = originalSize
        setStatus("Reset")
    end
end)

makeButton("DELETE IMAGE", function()
    if selected then
        selected:Destroy()
        selected = nil
        originalCFrame = nil
        originalSize = nil
        setStatus("Image deleted")
    end
end)

makeButton("CLOSE GUI", function()
    gui.Enabled = false
end)

makeButton("OPEN GUI", function()
    gui.Enabled = true
end)

setStatus("Ready")
