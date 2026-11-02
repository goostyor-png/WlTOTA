--[[
    LOCAL IMAGE EDITOR WITH 3D MOVE GIZMO
    LocalScript for Roblox Studio.
    Put in StarterPlayer > StarterPlayerScripts.

    Red   = world X
    Green = world Y
    Blue  = world Z

    All created instances are client-side only.
]]

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- TUNING
local MOVE_AXIS_LENGTH = 2.8
local ROTATE_STEP = 15
local SCALE_STEP = 0.5
local MIN_SIZE = 0.2

-- Local-only folders
local imagesFolder = Instance.new("Folder")
imagesFolder.Name = "LocalImages_" .. player.UserId
imagesFolder.Parent = workspace

local gizmoFolder = Instance.new("Folder")
gizmoFolder.Name = "LocalImageGizmo_" .. player.UserId
gizmoFolder.Parent = workspace

local selected = nil
local placing = false
local originalCFrame = nil
local originalSize = nil
local draggingAxis = nil
local dragStartPointer = nil
local dragStartPosition = nil
local dragScreenAxis = nil
local dragInputType = nil

local axisByPart = {}
local gizmoParts = {}

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "LocalImageEditor"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = false
gui.Parent = player:WaitForChild("PlayerGui")

local panel = Instance.new("Frame")
panel.Name = "Panel"
panel.Size = UDim2.new(0, 285, 0, 440)
panel.Position = UDim2.new(0, 12, 0.5, -220)
panel.BackgroundColor3 = Color3.fromRGB(25, 27, 36)
panel.BorderSizePixel = 0
panel.Visible = true
panel.Parent = gui
Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 14)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(42, 47, 65)
title.Text = "3D IMAGE EDITOR"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextSize = 16
title.Font = Enum.Font.GothamBold
title.Parent = panel
Instance.new("UICorner", title).CornerRadius = UDim.new(0, 12)

local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ShowHideButton"
toggleButton.Size = UDim2.new(0, 48, 0, 48)
toggleButton.Position = UDim2.new(0, 12, 0, 12)
toggleButton.BackgroundColor3 = Color3.fromRGB(42, 47, 65)
toggleButton.Text = "☰"
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.TextSize = 24
toggleButton.Font = Enum.Font.GothamBold
toggleButton.Visible = false
toggleButton.Parent = gui
Instance.new("UICorner", toggleButton).CornerRadius = UDim.new(0, 12)

toggleButton.Activated:Connect(function()
    panel.Visible = true
    toggleButton.Visible = false
end)

local scroll = Instance.new("ScrollingFrame")
scroll.Position = UDim2.new(0, 8, 0, 48)
scroll.Size = UDim2.new(1, -16, 1, -56)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 4
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.Parent = panel

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

local function makeButton(text, callback, color)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -4, 0, 38)
    button.BackgroundColor3 = color or Color3.fromRGB(55, 65, 90)
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
idBox.PlaceholderText = "Вставь ID изображения..."
idBox.Text = ""
idBox.TextColor3 = Color3.new(1, 1, 1)
idBox.PlaceholderColor3 = Color3.fromRGB(170, 170, 170)
idBox.Font = Enum.Font.Gotham
idBox.TextSize = 14
idBox.ClearTextOnFocus = false
idBox.Parent = scroll
Instance.new("UICorner", idBox).CornerRadius = UDim.new(0, 8)

local status = makeLabel("Статус: готово")

local function setStatus(message)
    status.Text = "Статус: " .. message
end

-- 3D MOVE GIZMO
local axes = {
    {
        name = "X",
        direction = Vector3.new(1, 0, 0),
        color = Color3.fromRGB(255, 65, 65),
    },
    {
        name = "Y",
        direction = Vector3.new(0, 1, 0),
        color = Color3.fromRGB(65, 235, 100),
    },
    {
        name = "Z",
        direction = Vector3.new(0, 0, 1),
        color = Color3.fromRGB(65, 145, 255),
    },
}

local function makeGizmoPart(name, size, color, shape)
    local part = Instance.new("Part")
    part.Name = name
    part.Anchored = true
    part.CanCollide = false
    part.CanTouch = false
    part.CanQuery = true
    part.CastShadow = false
    part.Material = Enum.Material.Neon
    part.Color = color
    part.Size = size
    if shape then
        part.Shape = shape
    end
    part.Parent = gizmoFolder
    table.insert(gizmoParts, part)
    return part
end

for _, axis in ipairs(axes) do
    local rod = makeGizmoPart(
        "Axis_" .. axis.name,
        Vector3.new(0.13, 0.13, MOVE_AXIS_LENGTH),
        axis.color
    )
    local tip = makeGizmoPart(
        "AxisTip_" .. axis.name,
        Vector3.new(0.48, 0.48, 0.48),
        axis.color,
        Enum.PartType.Ball
    )

    axisByPart[rod] = axis
    axisByPart[tip] = axis
    axis.rod = rod
    axis.tip = tip
end

local center = makeGizmoPart(
    "GizmoCenter",
    Vector3.new(0.32, 0.32, 0.32),
    Color3.fromRGB(245, 245, 245),
    Enum.PartType.Ball
)

local function setGizmoVisible(visible)
    for _, part in ipairs(gizmoParts) do
        part.Transparency = visible and 0 or 1
        part.CanQuery = visible
    end
    center.Transparency = visible and 0 or 1
    center.CanQuery = visible
end

local function updateGizmo()
    if not selected or not selected.Parent then
        setGizmoVisible(false)
        return
    end

    local origin = selected.Position
    center.Position = origin

    for _, axis in ipairs(axes) do
        local direction = axis.direction
        local endPoint = origin + direction * MOVE_AXIS_LENGTH
        local rodStart = origin + direction * 0.35
        local rodEnd = endPoint - direction * 0.25
        local rodMiddle = (rodStart + rodEnd) / 2

        axis.rod.Size = Vector3.new(0.13, 0.13, (rodEnd - rodStart).Magnitude)
        axis.rod.CFrame = CFrame.lookAt(rodMiddle, rodEnd)
        axis.tip.Position = endPoint
    end

    setGizmoVisible(true)
end

-- IMAGE CREATION
local function createImage(assetId, position, normal)
    local part = Instance.new("Part")
    part.Name = "LocalImage"
    part.Size = Vector3.new(4, 3, 0.05)
    part.Anchored = true
    part.CanCollide = false
    part.CanTouch = false
    part.CanQuery = true
    part.Material = Enum.Material.SmoothPlastic
    part.Color = Color3.new(1, 1, 1)

    normal = normal or Vector3.new(0, 0, -1)
    part.CFrame = CFrame.lookAt(
        position + normal * 0.05,
        position + normal
    )
    part.Parent = imagesFolder

    local decal = Instance.new("Decal")
    decal.Name = "Image"
    decal.Texture = "rbxassetid://" .. assetId
    decal.Face = Enum.NormalId.Front
    decal.Parent = part

    selected = part
    originalCFrame = part.CFrame
    originalSize = part.Size
    updateGizmo()
    setStatus("Картинка создана и выбрана")
end

makeButton("＋ СОЗДАТЬ КАРТИНКУ", function()
    local assetId = idBox.Text:match("%d+")
    if not assetId then
        setStatus("Сначала введи ID картинки")
        return
    end

    placing = true
    setStatus("Нажми на поверхность в мире")
end, Color3.fromRGB(55, 105, 75))

-- Raycast helpers
local function getScreenRay(position)
    camera = workspace.CurrentCamera
    return camera:ScreenPointToRay(position.X, position.Y)
end

local function raycastFolder(position, folder)
    local ray = getScreenRay(position)
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Include
    params.FilterDescendantsInstances = { folder }
    return workspace:Raycast(ray.Origin, ray.Direction * 700, params)
end

local function raycastWorld(position)
    local ray = getScreenRay(position)
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude

    local excluded = { gizmoFolder, imagesFolder }
    if player.Character then
        table.insert(excluded, player.Character)
    end
    params.FilterDescendantsInstances = excluded

    return workspace:Raycast(ray.Origin, ray.Direction * 700, params)
end

local function raycastImages(position)
    local ray = getScreenRay(position)
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Include
    params.FilterDescendantsInstances = { imagesFolder }
    return workspace:Raycast(ray.Origin, ray.Direction * 700, params)
end

-- Pointer / axis dragging
local function beginAxisDrag(axis, pointerPosition, inputType)
    if not selected then
        return
    end

    camera = workspace.CurrentCamera
    local screenOrigin, originVisible = camera:WorldToViewportPoint(selected.Position)
    local screenEnd, endVisible = camera:WorldToViewportPoint(
        selected.Position + axis.direction * MOVE_AXIS_LENGTH
    )

    if not originVisible or not endVisible then
        return
    end

    local screenVector = Vector2.new(
        screenEnd.X - screenOrigin.X,
        screenEnd.Y - screenOrigin.Y
    )

    if screenVector.Magnitude < 2 then
        return
    end

    draggingAxis = axis
    dragStartPointer = Vector2.new(pointerPosition.X, pointerPosition.Y)
    dragStartPosition = selected.Position
    dragScreenAxis = screenVector
    dragInputType = inputType
    setStatus("Двигай по оси " .. axis.name)
end

local function updateAxisDrag(pointerPosition)
    if not draggingAxis or not selected or not selected.Parent then
        return
    end

    local pointer = Vector2.new(pointerPosition.X, pointerPosition.Y)
    local delta = pointer - dragStartPointer
    local pixelsAlongAxis = delta:Dot(dragScreenAxis) / dragScreenAxis.Magnitude
    local studs = pixelsAlongAxis * MOVE_AXIS_LENGTH / dragScreenAxis.Magnitude

    selected.Position = dragStartPosition + draggingAxis.direction * studs
    updateGizmo()
end

local function endAxisDrag()
    draggingAxis = nil
    dragStartPointer = nil
    dragStartPosition = nil
    dragScreenAxis = nil
    dragInputType = nil
    if selected then
        setStatus("Картинка выбрана")
    end
end

UIS.InputBegan:Connect(function(input, processed)
    if processed then
        return
    end

    local inputType = input.UserInputType
    if inputType ~= Enum.UserInputType.Touch
        and inputType ~= Enum.UserInputType.MouseButton1 then
        return
    end

    local pointerPosition = input.Position

    -- While placing, tap a world surface to create the image.
    if placing then
        local result = raycastWorld(pointerPosition)
        if result then
            local assetId = idBox.Text:match("%d+")
            if assetId then
                createImage(assetId, result.Position, result.Normal)
                placing = false
            end
        else
            setStatus("Не найдена поверхность")
        end
        return
    end

    -- First check whether one of the colored gizmo axes was tapped.
    if selected then
        local gizmoHit = raycastFolder(pointerPosition, gizmoFolder)
        if gizmoHit and axisByPart[gizmoHit.Instance] then
            beginAxisDrag(axisByPart[gizmoHit.Instance], pointerPosition, inputType)
            return
        end
    end

    -- Otherwise, select an image by tapping it.
    local imageHit = raycastImages(pointerPosition)
    if imageHit and imageHit.Instance then
        selected = imageHit.Instance
        originalCFrame = selected.CFrame
        originalSize = selected.Size
        updateGizmo()
        setStatus("Картинка выбрана — тяни цветные оси")
    end
end)

UIS.InputChanged:Connect(function(input)
    if not draggingAxis then
        return
    end

    if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
        updateAxisDrag(input.Position)
    end
end)

UIS.InputEnded:Connect(function(input)
    if not draggingAxis then
        return
    end

    if (dragInputType == Enum.UserInputType.Touch
            and input.UserInputType == Enum.UserInputType.Touch)
        or (dragInputType == Enum.UserInputType.MouseButton1
            and input.UserInputType == Enum.UserInputType.MouseButton1) then
        endAxisDrag()
    end
end)

-- ROTATION
makeLabel("━━━━ ПОВОРОТ ━━━━")

local function rotate(x, y, z)
    if not selected then
        setStatus("Сначала выбери картинку")
        return
    end

    selected.CFrame = selected.CFrame * CFrame.Angles(
        math.rad(x),
        math.rad(y),
        math.rad(z)
    )
    updateGizmo()
end

makeButton("Поворот X +15°", function() rotate(ROTATE_STEP, 0, 0) end)
makeButton("Поворот X -15°", function() rotate(-ROTATE_STEP, 0, 0) end)
makeButton("Поворот Y +15°", function() rotate(0, ROTATE_STEP, 0) end)
makeButton("Поворот Y -15°", function() rotate(0, -ROTATE_STEP, 0) end)
makeButton("Поворот Z +15°", function() rotate(0, 0, ROTATE_STEP) end)
makeButton("Поворот Z -15°", function() rotate(0, 0, -ROTATE_STEP) end)

-- SIZE
makeLabel("━━━━ РАЗМЕР ━━━━")

local function resize(amount)
    if not selected then
        setStatus("Сначала выбери картинку")
        return
    end

    local size = selected.Size
    selected.Size = Vector3.new(
        math.max(MIN_SIZE, size.X + amount),
        math.max(MIN_SIZE, size.Y + amount),
        0.05
    )
    updateGizmo()
end

makeButton("＋ Увеличить", function() resize(SCALE_STEP) end)
makeButton("－ Уменьшить", function() resize(-SCALE_STEP) end)

-- RESET / DELETE / HIDE
makeLabel("━━━━ УПРАВЛЕНИЕ ━━━━")

makeButton("СБРОСИТЬ ПОЗИЦИЮ И РАЗМЕР", function()
    if not selected then
        return
    end
    if originalCFrame and originalSize then
        selected.CFrame = originalCFrame
        selected.Size = originalSize
        updateGizmo()
        setStatus("Положение сброшено")
    end
end)

makeButton("УДАЛИТЬ ВЫБРАННУЮ КАРТИНКУ", function()
    if selected then
        selected:Destroy()
        selected = nil
        originalCFrame = nil
        originalSize = nil
        updateGizmo()
        setStatus("Картинка удалена")
    end
end)

makeButton("СКРЫТЬ МЕНЮ", function()
    panel.Visible = false
    toggleButton.Visible = true
end, Color3.fromRGB(80, 75, 110))

setStatus("Готово — создай картинку или нажми на существующую")
setGizmoVisible(false)
