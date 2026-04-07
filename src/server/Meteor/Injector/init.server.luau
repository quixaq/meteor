-- Meteor Anti-Cheat Local Injecting script
--!strict

-- Variables

-- TODO: Make it generate spoof folders with spoof scripts to make it harder to guess the real one

local scripts: Folder = script.char
local players: Players = game:GetService("Players")
local serverStorage: ServerStorage = game:GetService("ServerStorage")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local meteorFolder = serverStorage:WaitForChild("_Meteor") :: Folder
local meteorFolderReplicated = replicatedStorage:WaitForChild("_Meteor") :: Folder
local verifyEvent = meteorFolder:WaitForChild("key.verify") :: BindableFunction
local mainKey = (meteorFolder:WaitForChild("key.security") :: StringValue).Value
local kickEvent = meteorFolder:WaitForChild("kick.player") :: BindableEvent
local r4 = meteorFolderReplicated:WaitForChild("__r4") :: RemoteEvent
local r11 = meteorFolderReplicated:WaitForChild("__r11") :: RemoteFunction
local rand = require(script.Parent.rand)

-- Functions
local function copyDirectory(source: Instance, destination: Instance, player: Player)
	for _, child in source:GetChildren() do
		if child:IsA("Folder") then
			local folder = destination:FindFirstChild(child.Name)
			if not folder then
				local newFolder = Instance.new("Folder")
				newFolder.Name = child.Name
				newFolder.Archivable = child.Archivable
				newFolder.Parent = destination
				folder = newFolder
			end
			copyDirectory(child, (folder :: Folder), player)
		else
			local file: Instance = child:Clone()
			if string.sub(child.Name, 1, 1) ~= "_" then
				file.Name = rand.bytes(32)
			end
			file.Parent = destination
			if file:IsA("LocalScript") and string.sub(child.Name, 1, 1) ~= "." then
				local q: StringValue = Instance.new("StringValue")
				local random: string = rand.bytes(64)
				q.Value = random
				local e: StringValue = q:Clone()
				q.Name = "passwd"
				e.Name = random
				q.Parent = file
				local w: Folder = Instance.new("Folder")
				w.Name = tostring(player.UserId)
				local old = meteorFolder:WaitForChild(".keys"):FindFirstChild(tostring(player.UserId))
				if old then
				    if old:IsA("Folder") then
						w = (old :: Folder)
				    end
				end
				w.Parent = meteorFolder:WaitForChild(".keys")
				e.Parent = w
			end
		end
	end
end

-- Events
players.PlayerAdded:Connect(function(player: Player)
	player.CharacterAdded:Connect(function(char: Model)
		local random: string = rand.bytes(math.random(32,64))
		local folder: Folder = Instance.new("Folder")
		folder.Name = random
		folder.Parent = char
		copyDirectory(scripts, folder, player)
		local oldstr: Instance = script.charlist:FindFirstChild(player.UserId)
		if oldstr then
			oldstr:Destroy()
		end
		local str: StringValue = Instance.new("StringValue")
		str.Name = tostring(player.UserId)
		str.Value = random
		str.Parent = script.charlist
	end)
end)

r11.OnServerInvoke = function(player: Player, key: string): number
	if not verifyEvent:Invoke(mainKey, player, key) then
	    kickEvent:Fire(mainKey, player, "unauthorized")
	    return 0
	end
	return #script.char:GetChildren()
end

-- Reset scripts every x seconds
task.wait(5)

local interval: number = script.Parent:GetAttribute("localResetTime")
local heartbeatInterval: number = script.Parent:GetAttribute("heartbeatInterval")

while task.wait() do
	local toWait: number = math.floor(interval/heartbeatInterval)*heartbeatInterval-5
	if tostring(toWait) == "nan" then
		toWait = 27
	end
	if toWait <= 5 or toWait >= 60 then
		toWait = 27
	end
	task.wait(toWait - 0.05)
	r4:FireAllClients()
	task.wait(0.05)
	local oldKeys: {Instance} = {}
	local start_time: number = os.clock()
	for _, player in pairs(players:GetPlayers()) do
		local char: Model? = player.Character
		if char then
			local oldstr: Instance? = script.charlist:FindFirstChild(player.UserId)
            if oldstr then
                if oldstr:IsA("StringValue") then
    				local folderName: string = oldstr.Value
    				local oldFolder: Instance? = char:FindFirstChild(folderName)
    				if oldFolder then
    					oldFolder:Destroy()
    				end
    				oldstr:Destroy()
    			end
			end
			local random: string = rand.bytes(math.random(32,64))
			local folder: Folder = Instance.new("Folder")
			folder.Name = random
			folder.Parent = char
			local activeKeys: Instance? = meteorFolder:WaitForChild(".keys"):FindFirstChild(tostring(player.UserId))
			if activeKeys then
    			for _, key in activeKeys:GetChildren() do
    				table.insert(oldKeys, key)
    			end
			end
			copyDirectory(scripts, folder, player)

			local str: StringValue = Instance.new("StringValue")
			str.Name = tostring(player.UserId)
			str.Value = random
			str.Parent = script.charlist
		end
	end
	local end_time: number = os.clock()
	local execution_time: number = end_time - start_time
	task.wait(2) -- give the clients 2 seconds to update, needed in case of detections happening after the server replaced the local anti-cheat but before the client reiceved the update.
	for _, oldKey in oldKeys do
		oldKey:Destroy()
	end
	if execution_time < 5 then
		task.wait(5-execution_time)
	end
end
