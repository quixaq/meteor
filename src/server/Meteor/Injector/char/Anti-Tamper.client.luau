--!strict
if not script:FindFirstChild("passwd") then
	script.Parent:Destroy()
end
if not script:FindFirstChild("passwd"):IsA("StringValue") then
	script.Parent:Destroy()
end
local key: string = script:WaitForChild("passwd").Value
script:WaitForChild("passwd"):Destroy()
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local meteorFolder = replicatedStorage:WaitForChild("_Meteor") :: Folder
local r9 = meteorFolder:WaitForChild("__r9") :: RemoteEvent
local r4 = meteorFolder:WaitForChild("__r4") :: RemoteEvent
local players: Players = game:GetService("Players")
local player: Player = players.LocalPlayer
local char = player.Character :: Model
local humanoid = char:WaitForChild("Humanoid") :: Humanoid
local gui = player.PlayerGui:WaitForChild("MeteorGui") :: ScreenGui
local show = gui:WaitForChild("Show") :: Frame
local hide = gui:WaitForChild("Hide") :: Frame
local dashboard = gui:FindFirstChild("Dashboard") :: Frame?
local login = gui:FindFirstChild("Login") :: Frame?
local frame = gui:FindFirstChild("Frame") :: Frame?

show:GetPropertyChangedSignal("Visible"):Connect(function()
	if not show.Visible then
		r9:FireServer(key, "modify")
	end
end)

hide:GetPropertyChangedSignal("Visible"):Connect(function()
	if hide.Visible then
		if dashboard then dashboard.Visible = false end
		if login then login.Visible = false end
		if frame then frame.Visible = false end
		r9:FireServer(key, "modify")
	end
end)

local locked: Part = Instance.new("Part")
locked.CFrame = CFrame.new(math.random(0, 1000), math.random(0, 1000), math.random(0, 1000))
locked.Transparency = 1
locked.Anchored = true
locked.CanQuery = false
locked.CanTouch = false
locked.CanCollide = false
locked.AudioCanCollide = false
local unlocked: Part = locked:Clone()
locked.Locked = true
unlocked.Locked = false
local clickDetector: ClickDetector = Instance.new("ClickDetector")
clickDetector.MaxActivationDistance = 0
local proximityPrompt: ProximityPrompt = Instance.new("ProximityPrompt")
proximityPrompt.MaxIndicatorDistance = 0
proximityPrompt.HoldDuration = math.random(1, 16)
locked.Parent = workspace
unlocked.Parent = workspace
clickDetector.Parent = workspace
proximityPrompt.Parent = workspace

locked:GetPropertyChangedSignal("Locked"):Connect(function()
	if not locked.Locked then
		r9:FireServer(key)
	end
end)
locked:GetPropertyChangedSignal("Transparency"):Connect(function()
	if locked.Transparency ~= 1 then
		r9:FireServer(key)
	end
end)
locked:GetPropertyChangedSignal("Anchored"):Connect(function()
	if locked.Anchored ~= false then
		r9:FireServer(key)
	end
end)
unlocked:GetPropertyChangedSignal("Locked"):Connect(function()
	if unlocked.Locked then
		r9:FireServer(key)
	end
end)
unlocked:GetPropertyChangedSignal("Transparency"):Connect(function()
	if unlocked.Transparency ~= 1 then
		r9:FireServer(key)
	end
end)
unlocked:GetPropertyChangedSignal("Anchored"):Connect(function()
	if unlocked.Anchored == false then
		r9:FireServer(key)
	end
end)
clickDetector:GetPropertyChangedSignal("MaxActivationDistance"):Connect(function()
	if clickDetector.MaxActivationDistance ~= 0 then
		r9:FireServer(key)
	end
end)
clickDetector.MouseClick:Connect(function()
	r9:FireServer(key)
end)
proximityPrompt.Triggered:Connect(function()
	r9:FireServer(key)
end)

r4.OnClientEvent:Connect(function()
	locked:Destroy()
	unlocked:Destroy()
	clickDetector:Destroy()
	proximityPrompt:Destroy()
end)

humanoid.Died:Connect(function()
	locked:Destroy()
	unlocked:Destroy()
	clickDetector:Destroy()
	proximityPrompt:Destroy()
end)
