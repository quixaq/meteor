-- Meteor Anti-Cheat Anti-Bot script.
--!strict

local serverStorage: ServerStorage = game:GetService("ServerStorage")
local players: Players = game:GetService("Players")
local meteorFolder = serverStorage:WaitForChild("_Meteor") :: Folder
local kickEvent = meteorFolder:WaitForChild("kick.player") :: BindableEvent
local key: string = (meteorFolder:WaitForChild("key.security") :: StringValue).Value
local minAccountAge: number = script.Parent:GetAttribute("minAccountAge")
local marketplaceService: MarketplaceService = game:GetService("MarketplaceService")

players.PlayerAdded:Connect(function(player)
	local success: boolean, result: boolean = pcall(function()
		return marketplaceService:PlayerOwnsAssetAsync(player, 102611803)
	end)
	if not success or not result then
		kickEvent:Fire(key, player, "verify")
	end
	local accountAge: number = player.AccountAge
	if accountAge < minAccountAge then
		kickEvent:Fire(key, player, "age")
	end
end)
