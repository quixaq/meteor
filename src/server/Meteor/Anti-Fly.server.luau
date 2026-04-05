-- Meteor Anti-Cheat Anti-Fly script.

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
local maxAirTime = script.Parent:GetAttribute("maxAir")
local runService = game:GetService("RunService")
local distance = script.Parent:GetAttribute("groundDist")

players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		local hrp = character:WaitForChild("HumanoidRootPart")
		local humanoid = character:WaitForChild("Humanoid")

		local lastGroundTime = tick()

		runService.Heartbeat:Connect(function()
			if character and hrp then
				local boxSize = hrp.Size
				local rayDirection = Vector3.new(0, -distance, 0)
				local raycastParams = RaycastParams.new()
				raycastParams.FilterDescendantsInstances = {character}
				raycastParams.FilterType = Enum.RaycastFilterType.Exclude

				local result = workspace:Blockcast(hrp.CFrame, boxSize, rayDirection, raycastParams)

				if result then
					lastGroundTime = tick()
				end

				if tick() - lastGroundTime > maxAirTime then
					serverKickEvent:Fire(key, player, "cheat")
				end
			end
		end)
	end)
end)
