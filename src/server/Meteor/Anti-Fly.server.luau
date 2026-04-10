-- Meteor Anti-Cheat Anti-Fly script.
--!strict

local serverStorage: ServerStorage = game:GetService("ServerStorage")
local players: Players = game:GetService("Players")

while not script.Parent:GetAttribute("load") do
    task.wait()
end

local meteorFolder = serverStorage:WaitForChild("_Meteor") :: Folder
local kickEvent = meteorFolder:WaitForChild("kick.player") :: BindableEvent
local key: string = (meteorFolder:WaitForChild("key.security") :: StringValue).Value
local maxAirTime: number = script.Parent:GetAttribute("maxAir")
local runService: RunService = game:GetService("RunService")
local distance: number = script.Parent:GetAttribute("groundDist")

players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		local hrp = character:WaitForChild("HumanoidRootPart") :: BasePart

		local lastGroundTime: number = tick()

		runService.Heartbeat:Connect(function()
			if character and hrp then
				local boxSize: Vector3 = hrp.Size
				local rayDirection: Vector3 = Vector3.new(0, -distance, 0)
				local raycastParams: RaycastParams = RaycastParams.new()
				raycastParams.FilterDescendantsInstances = {character}
				raycastParams.FilterType = Enum.RaycastFilterType.Exclude

				local result: RaycastResult<BasePart>? = workspace:Blockcast(hrp.CFrame, boxSize, rayDirection, raycastParams)

				if result then
					lastGroundTime = tick()
				end

				if tick() - lastGroundTime > maxAirTime then
					kickEvent:Fire(key, player, "cheat")
				end
			end
		end)
	end)
end)
