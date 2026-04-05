-- Meteor Anti-Cheat Local Injecting script

-- Variables

-- TODO: Make it generate spoof folders with spoof scripts to make it harder to guess the real one

local scripts = script.char
local players = game:GetService("Players")
local serverStorage = game:GetService("ServerStorage")
local replicatedStorage = game:GetService("ReplicatedStorage")
local meteorFolder = serverStorage:WaitForChild("_Meteor")
local meteorFolderReplicated = replicatedStorage:WaitForChild("_Meteor")
local verifyEvent = meteorFolder:WaitForChild("key.verify")
local kickEvent = meteorFolder:WaitForChild("kick.player")
local mainKey = meteorFolder:WaitForChild("key.security").Value
local r4 = meteorFolderReplicated:WaitForChild("__r4")
local r11 = meteorFolderReplicated:WaitForChild("__r11")
local rand = require(script.Parent.rand)

-- Functions
local function copyDirectory(source, destination, player)
	for _, child in source:GetChildren() do
		if child:IsA("Folder") then
			local folder = destination:FindFirstChild(child.Name)
			if not folder or folder == nil then
				folder = Instance.new("Folder")
				folder.Name = child.Name
				folder.Archivable = child.Archivable
				folder.Parent = destination
			end
			copyDirectory(child, folder)
		else
			local file = child:Clone()
			if string.sub(child.Name, 1, 1) ~= "_" then
				file.Name = rand.bytes(32)
			end
			file.Parent = destination
			if file:IsA("LocalScript") and string.sub(child.Name, 1, 1) ~= "." then
				local q = Instance.new("StringValue")
				local random = rand.bytes(64)
				q.Value = random
				local e = q:Clone()
				q.Name = "passwd"
				e.Name = random
				q.Parent = file
				local w = Instance.new("Folder")
				w.Name = player.UserId
				if meteorFolder:WaitForChild(".keys"):FindFirstChild(player.UserId) then
					w = meteorFolder:WaitForChild(".keys"):FindFirstChild(player.UserId)
				end
				w.Parent = meteorFolder:WaitForChild(".keys")
				e.Parent = w
			end
		end
	end
end

-- Events
players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(char)
		local random = rand.bytes(math.random(32,64))
		local folder = Instance.new("Folder")
		local player = players:GetPlayerFromCharacter(char)
		folder.Name = random
		folder.Parent = char
		copyDirectory(scripts, folder, player)
		local oldstr = script.charlist:FindFirstChild(player.UserId)
		if oldstr then
			oldstr:Destroy()
		end
		local str = Instance.new("StringValue")
		str.Name = player.UserId
		str.Value = random
		str.Parent = script.charlist
	end)
end)

r11.OnServerInvoke = function(player, key)
	if not verifyEvent:Invoke(mainKey, player, key) then serverKickEvent:Fire(mainKey, player, "unauthorized") return end
	return #script.char:GetChildren()
end

-- Reset scripts every x seconds
task.wait(5)

local interval = script.Parent:GetAttribute("localResetTime")
local heartbeatInterval = script.Parent:GetAttribute("heartbeatInterval")

while task.wait() do
	local toWait = math.floor(interval/heartbeatInterval)*heartbeatInterval-5
	if tostring(toWait) == "nan" then
		toWait = 27
	end
	if toWait <= 5 or toWait >= 60 then
		toWait = 27
	end
	task.wait(toWait - 0.05)
	r4:FireAllClients()
	task.wait(0.05)
	local oldKeys = {}
	local start_time = os.clock()
	for _, player in pairs(players:GetPlayers()) do
		local char = player.Character
		if char then
			local oldstr = script.charlist:FindFirstChild(player.UserId)
			if oldstr then
				local folderName = oldstr.Value
				local oldFolder = char:FindFirstChild(folderName)
				if oldFolder then
					oldFolder:Destroy()
				end
				oldstr:Destroy()
			end
			local random = rand.bytes(math.random(32,64))
			local folder = Instance.new("Folder")
			local player = players:GetPlayerFromCharacter(char)
			folder.Name = random
			folder.Parent = char
			local activeKeys = meteorFolder:WaitForChild(".keys"):FindFirstChild(player.UserId)
			for _, key in activeKeys:GetChildren() do
				table.insert(oldKeys, key)
			end
			copyDirectory(scripts, folder, player)

			local str = Instance.new("StringValue")
			str.Name = player.UserId
			str.Value = random
			str.Parent = script.charlist
		end
	end
	local end_time = os.clock()
	local execution_time = end_time - start_time
	task.wait(2) -- give the clients 2 seconds to update, needed in case of detections happening after the server replaced the local anti-cheat but before the client reiceved the update.
	for _, oldKey in oldKeys do
		oldKey:Destroy()
	end
	if execution_time < 5 then
		task.wait(5-execution_time)
	end
end
