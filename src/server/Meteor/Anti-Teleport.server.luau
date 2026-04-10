--!strict

local serverStorage: ServerStorage = game:GetService("ServerStorage")
local players: Players = game:GetService("Players")

while not script.Parent:GetAttribute("load") do
    task.wait()
end

local meteorFolder = serverStorage:WaitForChild("_Meteor") :: Folder
local kickEvent = meteorFolder:WaitForChild("kick.player") :: BindableEvent
local key: string = (meteorFolder:WaitForChild("key.security") :: StringValue).Value
local maxSPS: number = script.Parent:GetAttribute("MaxSPS")
local maxSitSPS: number = script.Parent:GetAttribute("MaxSitSPS")
local sitDetection: boolean = true
if maxSitSPS == -1 then
	sitDetection = false
end

players.PlayerAdded:Connect(function(player: Player)
	player.CharacterAdded:Connect(function(char: Model)
		local hrp = char:WaitForChild("HumanoidRootPart") :: BasePart
		local humanoid = char:WaitForChild("Humanoid") :: Humanoid
		local lastPos: Vector3 = hrp.Position
		while task.wait(1) do
			local sit: boolean = humanoid.Sit and sitDetection
			if (hrp.Position - lastPos).Magnitude > maxSPS and not sit then
				kickEvent:Fire(key, player, "cheat")
			end
			if (hrp.Position - lastPos).Magnitude > maxSitSPS and sit then
				kickEvent:Fire(key, player, "cheat")
			end
			lastPos = hrp.Position
		end
	end)
end)
