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
local char = player.Character
local hrp = char:WaitForChild("HumanoidRootPart")

while wait() do
	if not hrp.CanCollide then
		r9:FireServer(key)
	end
end
