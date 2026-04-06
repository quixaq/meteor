-- Meteor Anti-Cheat heartbeat handler.

-- Variables

local serverStorage = game:GetService("ServerStorage")
local replicatedStorage = game:GetService("ReplicatedStorage")
local players = game:GetService("Players")
local meteorFolder = serverStorage:WaitForChild("_Meteor")
local meteorFolderReplicated = replicatedStorage:WaitForChild("_Meteor")
local heartbeatEvent = meteorFolderReplicated:WaitForChild("__r8")
local heartbeatBack = meteorFolderReplicated:WaitForChild("__r9")
local validKeys = meteorFolder:WaitForChild(".keys")
local kickEvent = meteorFolder:WaitForChild("kick.player")
local verifyEvent = meteorFolder:WaitForChild("key.verify")
local mainKey = meteorFolder:WaitForChild("key.security").Value
local heartbeated = {}
local playersList = {}
local now = false

-- Event Handling
heartbeatEvent.OnServerEvent:Connect(function(player, key, q)
	local e = tick()
	local ping = e - q
	if not verifyEvent:Invoke(mainKey, player, key) then kickEvent:Fire(mainKey, player, "unauthorized") return end
	if not heartbeated[player] then
		table.insert(heartbeated, player)
	end
	if player:FindFirstChild("ActualPing") then
		player:FindFirstChild("ActualPing").Value = math.floor(ping * 1000)
	end
end)

players.PlayerAdded:Connect(function(player)
	local ping = Instance.new("IntValue")
	ping.Value = 0
	ping.Name = "NetworkPing"
	ping.Parent = player
	local aping = Instance.new("IntValue")
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

local interval = script.Parent:GetAttribute("heartbeatInterval")

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
	local toKick = {}
	for i, v in ipairs(playersList) do
		local is_common = false
		for j, w in ipairs(heartbeated) do
			if v == w then
				is_common = true
				break
			end
		end
		if not is_common then
			table.insert(toKick, v)
		end
		if v:FindFirstChild("NetworkPing") then
			v:FindFirstChild("NetworkPing").Value = math.floor(v:GetNetworkPing() * 1000)
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
