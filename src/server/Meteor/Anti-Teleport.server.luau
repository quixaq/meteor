local serverStorage = game:GetService("ServerStorage")
local replicatedStorage = game:GetService("ReplicatedStorage")
local players = game:GetService("Players")
local meteorFolder = serverStorage:WaitForChild("_Meteor")
local meteorFolderReplicated = replicatedStorage:WaitForChild("_Meteor")
local serverKickEvent = meteorFolder:WaitForChild("kick.player")
local rand = require(script.Parent.rand)
local validKeys = meteorFolder:WaitForChild(".keys")
local key = meteorFolder:FindFirstChild("key.security").Value
local kick_messages = script.Parent:WaitForChild(".config"):WaitForChild("Messages")
local runService = game:GetService("RunService")
local maxSPS = script.Parent:GetAttribute("MaxSPS")
local maxSitSPS = script.Parent:GetAttribute("MaxSitSPS")
local sitDetection = true
if not maxSitSPS then
	sitDetection = false
	maxSitSPS = 0
end

players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(char)
		local hrp = char:WaitForChild("HumanoidRootPart")
		local humanoid = char:WaitForChild("Humanoid")
		local lastPos = hrp.Position
		while task.wait(1) do
			local sit = humanoid.Sit and sitDetection
			if (hrp.Position - lastPos).Magnitude > maxSPS and not sit then
				serverKickEvent:Fire(key, player, "cheat")
			end
			if (hrp.Position - lastPos).Magnitude > maxSitSPS and sit then
				serverKickEvent:Fire(key, player, "cheat")
			end
			lastPos = hrp.Position
		end
	end)
end)
