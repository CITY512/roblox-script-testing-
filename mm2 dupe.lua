local TeleportService = game:GetService("TeleportService")
local LocalPlayer = game.Players.LocalPlayer

local connections = {}

local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local TextLabel = Instance.new("TextLabel")
local TextButton = Instance.new("TextButton")

--Properties:

ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame.BorderSizePixel = 0
Frame.Size = UDim2.new(0, 75, 0, 35)
Frame.Style = Enum.FrameStyle.DropShadow

TextLabel.Parent = Frame
TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.BackgroundTransparency = 1.000
TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel.BorderSizePixel = 0
TextLabel.Size = UDim2.new(1, 0, 1, 0)
TextLabel.Font = Enum.Font.FredokaOne
TextLabel.Text = "Dupe"
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.TextSize = 13.000

TextButton.Parent = Frame
TextButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextButton.BackgroundTransparency = 1.000
TextButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextButton.BorderSizePixel = 0
TextButton.Position = UDim2.new(1, -8, 0, -8)
TextButton.Size = UDim2.new(0, 16, 0, 16)
TextButton.Font = Enum.Font.SourceSans
TextButton.Text = "X"
TextButton.TextColor3 = Color3.fromRGB(255, 0, 0)
TextButton.TextSize = 14.000

-- Scripts:

local UserInputService = game:GetService("UserInputService")
local runService = game:GetService("RunService")

local dragging
local dragInput
local dragStart
local startPos

local function Lerp(a, b, m)
	return a + (b - a) * m
end

local lastMousePos
local lastGoalPos
local DRAG_SPEED = 8
runService.Heartbeat:Connect(function(dt)
	if not startPos then return end
	if not dragging and lastGoalPos then
		Frame.Position = UDim2.new(startPos.X.Scale, Lerp(Frame.Position.X.Offset, lastGoalPos.X.Offset, dt * DRAG_SPEED), startPos.Y.Scale, Lerp(Frame.Position.Y.Offset, lastGoalPos.Y.Offset, dt * DRAG_SPEED))
		return 
	end

	local delta = lastMousePos - UserInputService:GetMouseLocation()
	local xGoal = startPos.X.Offset - delta.X
	local yGoal = startPos.Y.Offset - delta.Y
	lastGoalPos = UDim2.new(startPos.X.Scale, xGoal, startPos.Y.Scale, yGoal)
	Frame.Position = UDim2.new(startPos.X.Scale, Lerp(Frame.Position.X.Offset, xGoal, dt * DRAG_SPEED), startPos.Y.Scale, Lerp(Frame.Position.Y.Offset, yGoal, dt * DRAG_SPEED))
end)

Frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = Frame.Position
		lastMousePos = UserInputService:GetMouseLocation()

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

Frame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

connections[1] = TextButton.MouseButton1Click:Connect(function()
	ScreenGui:Destroy()
end)

local namecall
namecall = hookmetamethod(game, "__namecall", function(self,...)
	local args = {...}
	local method = getnamecallmethod()

	if tostring(self) == "AcceptTrade" and tostring(method) == "FireServer" then
		coroutine.wrap(function()
			local JobId = game.JobId
			LocalPlayer:Kick("Rejoining...")
			TeleportService:TeleportToPlaceInstance(142823291, JobId, LocalPlayer)
		end)()
		return self.FireServer(self,...)
	end
	
	return namecall(self,...)
end)
