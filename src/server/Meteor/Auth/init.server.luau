local serverStorage = game:GetService("ServerStorage")
local replicatedStorage = game:GetService("ReplicatedStorage")
local players = game:GetService("Players")
local meteorFolder = serverStorage:WaitForChild("_Meteor")
local meteorFolderReplicated = replicatedStorage:WaitForChild("_Meteor")
local rand = require(script.Parent.rand)
local mainKey = meteorFolder:FindFirstChild("key.security").Value
local authEvent = meteorFolderReplicated:WaitForChild("__r1")
local verifyEvent = meteorFolder:WaitForChild("key.verify")
local serverAuth = meteorFolder:WaitForChild("admin.auth")
local serverKickEvent = meteorFolder:WaitForChild("kick.player")
local kick_message = script.Parent:WaitForChild(".config"):WaitForChild("Messages"):WaitForChild("tries").Value
local log = meteorFolder:WaitForChild(".log")
local logClient = meteorFolderReplicated:WaitForChild("__r7")
local checkAuth = meteorFolderReplicated:WaitForChild("__r3")
local adminCheck = meteorFolder:WaitForChild("admin.check")
local adminCheckClient = meteorFolderReplicated:WaitForChild("__r2")
local unloggedAdminCheck = meteorFolder:WaitForChild("check.admin")
local logs = {}
local loggedAdmins = {}

authEvent.OnServerInvoke = function(player, key, pass)
	if not verifyEvent:Invoke(mainKey, player, key) then serverKickEvent:Fire(mainKey, player, "unauthorized") return end
	local tries = script.Tries:FindFirstChild(player.UserId)
	if not tries then
		local val = Instance.new("IntValue")
		val.Name = player.UserId
		val.Value = 0
		val.Parent = script.Tries
		tries = val
	end
	tries.Value = tries.Value + 1
	if tries.Value > script:GetAttribute("maxTries") then
		if script:GetAttribute("punishment") == "revoke" then return false end
		if script:GetAttribute("punishment") == "kick" then serverKickEvent:Fire(mainKey, player, "tries") return end
		if script:GetAttribute("punishment") == "ban" then
			local config: BanConfigType = {
				UserIds = {player.UserId},
				Duration = script:GetAttribute("banTime"),
				DisplayReason = "METEOR ANTI-CHEAT: "..kick_message,
				PrivateReason = "_meteor.tries",
				ExcludeAltAccounts = false,
				ApplyToUniverse = true
			}
			local s, e = pcall(function()
				players:BanAsync(config)
			end)
			if not s then
				print("METEOR ANTI-CHEAT: Failed to ban user. Make sure that Players>BanningEnabled is enabled.")
				serverKickEvent:Fire(mainKey, player, "tries")
			end
		end
	end
	local authed = serverAuth:Invoke(mainKey, player.UserId, pass)
	if authed then
		log:Fire(mainKey, {"Player", "Mod"}, player.DisplayName.."(@"..player.Name..", "..player.UserId..") logged into the admin panel.")
		if script:GetAttribute("loadPrevious") then
			for _, log in logs do
				logClient:FireClient(player, log[1], log[2])
			end
		end
		table.insert(loggedAdmins, player.UserId)
		return true
	end
	return false
end

players.PlayerRemoving:Connect(function(player)
	if table.find(loggedAdmins, player.UserId) then
		table.remove(loggedAdmins, table.find(loggedAdmins, player.UserId))
	end
end)

log.Event:Connect(function(key, types, message)
	if key ~= mainKey then return end
	table.insert(logs, {types, message})
	for _, player in loggedAdmins do
		if not players:GetPlayerByUserId(player) then continue end
		logClient:FireClient(players:GetPlayerByUserId(player), types, message)
	end
end)

checkAuth.OnServerInvoke = function(player, key)
	if not verifyEvent:Invoke(mainKey, player, key) then serverKickEvent:Fire(mainKey, player, "unauthorized") return end
	if not table.find(loggedAdmins, player.UserId) then
		return false
	end
	return true
end

adminCheck.OnInvoke = function(key, player)
	if key ~= mainKey then return false end
	if table.find(loggedAdmins, player.UserId) then
		return true
	end
	return false
end

adminCheckClient.OnServerInvoke = function(player, key)
	if not verifyEvent:Invoke(mainKey, player, key) then serverKickEvent:Fire(mainKey, player, "unauthorized") return end
	return unloggedAdminCheck:Invoke(mainKey, player)
end
