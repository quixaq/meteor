-- Meteor Anti-Cheat Anti-Bot script.

local serverStorage = game:GetService("ServerStorage")
local replicatedStorage = game:GetService("ReplicatedStorage")
local players = game:GetService("Players")
local meteorFolder = serverStorage:WaitForChild("_Meteor")
local meteorFolderReplicated = replicatedStorage:WaitForChild("_Meteor")
local serverKickEvent = meteorFolder:WaitForChild("kick.player")
local key = meteorFolder:FindFirstChild("key.security").Value
local kick_messages = script.Parent:WaitForChild(".config"):WaitForChild("Messages")
local minAccountAge = script.Parent:GetAttribute("minAccountAge")
local marketplaceService = game:GetService("MarketplaceService")

players.PlayerAdded:Connect(function(player)
	local success, result = pcall(function()
		return marketplaceService:PlayerOwnsAssetAsync(player, 102611803)
	end)
	if not success or not result then
		serverKickEvent:Fire(key, player, "verify")
	end
	local accountAge = player.AccountAge
	if accountAge < minAccountAge then
		serverKickEvent:Fire(key, player, "age")
	end
end)
