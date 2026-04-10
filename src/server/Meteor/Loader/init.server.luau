-- Meteor Anti-Cheat loader. Loads files from dep folder into the game.
--!strict

-- Variables
local dep: Folder = script.dep
local cryptography = require(script.Parent.Packages.cryptography)
local rand = require(script.Parent.rand)

-- Functions
local function copyDirectory(source: Instance, destination: Instance)
	for _, child in source:GetChildren() do
		if child:IsA("Folder") then
			local folder = destination:FindFirstChild(child.Name)
			if not folder then
				local newFolder: Folder = Instance.new("Folder")
				newFolder.Name = child.Name
				newFolder.Archivable = child.Archivable
				newFolder.Parent = destination
				folder = newFolder
			end
			copyDirectory(child, (folder :: Folder))
		else
			local file: Instance = child:Clone()
			file.Parent = destination
		end
	end
end

while script:GetAttribute("load") ~= true do
    task.wait()
end

-- Main code
for _, child in dep:GetChildren() do
	if not child:IsA('Folder') then
		continue
	end
	local service: Instance = game:GetService(child.Name)
	if not service then
		continue
	end
	copyDirectory(child, service)
end

local meteorFolderReplicated = game:GetService("ReplicatedStorage"):WaitForChild("_Meteor") :: Folder
meteorFolderReplicated:SetAttribute(".Meteor", "4D 65 74 65 6F 72 41 43")

local meteorFolder = game:GetService("ServerStorage"):FindFirstChild("_Meteor") :: Folder
local loadEvent = script.Parent:WaitForChild("load.event") :: BindableFunction
local key = meteorFolder:FindFirstChild("key.security") :: StringValue
local session: string = buffer.tostring(cryptography.Utilities.Base64.Encode(buffer.fromstring(rand.alphan(math.random(32,64))..(game.JobId..tostring(game.PlaceId)..tostring(game.GameId)..rand.alphan(math.random(16,64))))))
key.Value = session
loadEvent:Invoke(session)
