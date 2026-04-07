--!strict
if not script:FindFirstChild("passwd") or script:FindFirstChild("passwd") == nil then
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
local players: Players = game:GetService("Players")
local player: Player = players.LocalPlayer
local char = player.Character :: Model
local humanoid = char:WaitForChild("Humanoid") :: Humanoid

humanoid:GetPropertyChangedSignal("PlatformStand"):Connect(function()
	if humanoid.PlatformStand == true then
		r9:FireServer(key)
	end
end)

if humanoid.PlatformStand == true then
	r9:FireServer(key)
end
