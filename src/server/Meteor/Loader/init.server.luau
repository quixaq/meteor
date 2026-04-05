-- Meteor Anti-Cheat loader. Loads files from dep folder into the game.

-- Variables
local dep = script.dep
local cryptography = require(script.Parent.Packages.Cryptography)
local rand = require(script.Parent.rand)

-- Functions
local function copyDirectory(source, destination)
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
			file.Parent = destination
		end
	end
end

-- Main code
for _, child in dep:GetChildren() do
	local name = child.Name
	if not child:IsA('Folder') then
		continue
	end
	local service = game:GetService(child.Name)
	if service == nil or not service then
		continue
	end
	copyDirectory(child, service)
end

local meteorFolderReplicated = game:GetService("ReplicatedStorage"):WaitForChild("_Meteor")
meteorFolderReplicated:SetAttribute(".Meteor", "4D 65 74 65 6F 72 41 43")

local meteorFolder = game:GetService("ServerStorage"):FindFirstChild("_Meteor")
local loadEvent = meteorFolder:FindFirstChild("load.event")
local key = meteorFolder:FindFirstChild("key.security")
local session = nil
key.Value = buffer.tostring(cryptography.Utilities.Base64.Encode(buffer.fromstring(rand.alphan(math.random(32,64))..(game.JobId..tostring(game.PlaceId)..tostring(game.GameId)..rand.alphan(math.random(16,64))))))
session = key.Value
loadEvent:Invoke(session)
