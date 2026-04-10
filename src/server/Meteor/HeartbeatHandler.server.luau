-- Meteor Anti-Cheat heartbeat handler.
--!strict

-- Variables

while not script.Parent:GetAttribute("load") do
    task.wait()
end

local serverStorage: ServerStorage = game:GetService("ServerStorage")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local players: Players = game:GetService("Players")
local meteorFolder = serverStorage:WaitForChild("_Meteor") :: Folder
local meteorFolderReplicated = replicatedStorage:WaitForChild("_Meteor") :: Folder
local heartbeatEvent = meteorFolderReplicated:WaitForChild("__r8") :: RemoteEvent
local heartbeatBack = meteorFolderReplicated:WaitForChild("__r9") :: RemoteEvent
local kickEvent = meteorFolder:WaitForChild("kick.player") :: BindableEvent
local verifyEvent = meteorFolder:WaitForChild("key.verify") :: BindableFunction
local mainKey: string = (meteorFolder:WaitForChild("key.security") :: StringValue).Value
local heartbeated: {Player} = {}
local playersList: {Player} = {}
local now: boolean = false

-- Event Handling
heartbeatEvent.OnServerEvent:Connect(function(player: Player, key: string, q: number)
	local e: number = tick()
	local ping: number = e - q
	if not verifyEvent:Invoke(mainKey, player, key) then kickEvent:Fire(mainKey, player, "unauthorized") return end
	if not table.find(heartbeated, player) then
		table.insert(heartbeated, player)
	end
	local actualPing: Instance? = player:FindFirstChild("ActualPing")
	if actualPing then
		(player:WaitForChild("ActualPing") :: NumberValue).Value = math.floor(ping * 1000)
	end
end)

players.PlayerAdded:Connect(function(player: Player)
	local ping: IntValue = Instance.new("IntValue")
	ping.Value = 0
	ping.Name = "NetworkPing"
	ping.Parent = player
	local aping: IntValue = Instance.new("IntValue")
	aping.Value = 0
	aping.Name = "ActualPing"
	aping.Parent = player
	while not now do
		task.wait()
	end
	table.insert(playersList, player)
end)

-- Main loop

task.wait(5)

local interval: number = script.Parent:GetAttribute("heartbeatInterval")

while task.wait() do
	task.wait(1)
	now = false
	heartbeatBack:FireAllClients()
	task.wait((interval-1)/4)
	heartbeatBack:FireAllClients()
	task.wait((interval-1)/4)
	heartbeatBack:FireAllClients()
	task.wait((interval-1)/4)
	heartbeatBack:FireAllClients()
	task.wait((interval-1)/4)
	local toKick: {Player} = {}
	for i, v in ipairs(playersList) do
		local is_common: boolean = false
		for j, w in ipairs(heartbeated) do
			if v == w then
				is_common = true
				break
			end
		end
		if not is_common then
			table.insert(toKick, v)
		end
		local networkPing: Instance? = v:FindFirstChild("NetworkPing")
		if networkPing then
		    if (networkPing :: Instance):IsA("NumberValue") then
				(networkPing :: NumberValue).Value = math.floor(v:GetNetworkPing() * 1000)
			end
		end
	end
	heartbeated = {}
	for i, v in ipairs(toKick) do
		if v then
			kickEvent:Fire(mainKey, v, "cheat")
		end
	end
	now = true
end
