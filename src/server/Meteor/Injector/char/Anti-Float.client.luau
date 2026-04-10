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
local players: Players = game:GetService("Players")
local player: Player = players.LocalPlayer
local char = player.Character :: Model
local hrp = char:WaitForChild("HumanoidRootPart") :: BasePart

char.ChildAdded:Connect(function(child)
	if child:IsA("BasePart") then
		if child.CanCollide and child.Anchored then
			if child.CFrame.X == hrp.CFrame.X and child.CFrame.Z == hrp.CFrame.Z and hrp.CFrame.Y - child.CFrame.Y < 3.2 and hrp.CFrame.Y - child.CFrame.Y > 3.0 then
				r9:FireServer(key)
			end
		end
	end
end)
