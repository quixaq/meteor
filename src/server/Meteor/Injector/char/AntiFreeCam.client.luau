if not script:FindFirstChild("passwd") or script:FindFirstChild("passwd") == nil then
	script.Parent:Destroy()
end
if not script:FindFirstChild("passwd"):IsA("StringValue") then
	script.Parent:Destroy()
end
local key = script:WaitForChild("passwd").Value
script:WaitForChild("passwd"):Destroy()
local replicatedStorage = game:GetService("ReplicatedStorage")
local meteorFolder = replicatedStorage:WaitForChild("_Meteor")
local r9 = meteorFolder:WaitForChild("__r9")
local players = game:GetService("Players")
local player = players.LocalPlayer
local camera = workspace.Camera
local char = player.Character
local hum = char:WaitForChild("Humanoid")
local hrp = char:WaitForChild("HumanoidRootPart")
local detections = 0

camera:GetPropertyChangedSignal("Focus"):Connect(function()
	if (camera.Focus.Position - hrp.Position).Magnitude > 7 and hum.Health ~= 0 then
		r9:FireServer(key)
	end
end)
