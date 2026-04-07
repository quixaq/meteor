--!strict
local serverStorage: ServerStorage = game:GetService("ServerStorage")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local players: Players = game:GetService("Players")
local meteorFolder = serverStorage:WaitForChild("_Meteor") :: Folder
local meteorFolderReplicated = replicatedStorage:WaitForChild("_Meteor") :: Folder
local mainKey = (meteorFolder:WaitForChild("key.security") :: StringValue).Value
local authEvent = meteorFolderReplicated:WaitForChild("__r1") :: RemoteFunction
local verifyEvent = meteorFolder:WaitForChild("key.verify") :: BindableFunction
local serverAuth = meteorFolder:WaitForChild("admin.auth") :: BindableFunction
local kickEvent = meteorFolder:WaitForChild("kick.player") :: BindableEvent
local kick_message: string = (script.Parent:GetAttribute("kickPrefix") :: string)..(script.Parent:WaitForChild(".config"):WaitForChild("Messages"):WaitForChild("tries").Value)
local log = meteorFolder:WaitForChild(".log") :: BindableEvent
local logClient = meteorFolderReplicated:WaitForChild("__r7") :: RemoteEvent
local checkAuth = meteorFolderReplicated:WaitForChild("__r3") :: RemoteFunction
local adminCheck = meteorFolder:WaitForChild("admin.check") :: BindableFunction
local adminCheckClient = meteorFolderReplicated:WaitForChild("__r2") :: RemoteFunction
local unloggedAdminCheck = meteorFolder:WaitForChild("check.admin") :: BindableFunction
export type Log = {
    Types: {string},
    Message: string
}
local logs: {Log} = {}
local loggedAdmins = {}

authEvent.OnServerInvoke = function(player, key, pass)
	if not verifyEvent:Invoke(mainKey, player, key) then kickEvent:Fire(mainKey, player, "unauthorized") return end
	local tries: IntValue = script.Tries:FindFirstChild(player.UserId)
	if not tries then
		local val: IntValue = Instance.new("IntValue")
		val.Name = tostring(player.UserId)
		val.Value = 0
		val.Parent = script.Tries
		tries = val
	end
	tries.Value = tries.Value + 1
	if tries.Value > script:GetAttribute("maxTries") then
		if script:GetAttribute("punishment") == "revoke" then return false end
		if script:GetAttribute("punishment") == "kick" then
		    kickEvent:Fire(mainKey, player, "tries")
			return
		end
		if script:GetAttribute("punishment") == "ban" then
			local config: BanConfigType = {
				UserIds = {player.UserId},
				Duration = script:GetAttribute("banTime"),
				DisplayReason = kick_message,
				PrivateReason = "_meteor.tries",
				ExcludeAltAccounts = false,
				ApplyToUniverse = true
			}
			local s: boolean, _ = pcall(function()
				players:BanAsync(config)
			end)
			if not s then
				print("METEOR ANTI-CHEAT: Failed to ban user. Make sure that Players>BanningEnabled is enabled.")
				kickEvent:Fire(mainKey, player, "tries")
			end
		end
	end
	local authed: boolean = serverAuth:Invoke(mainKey, player.UserId, pass)
	if authed then
		log:Fire(mainKey, {"Player", "Mod"}, player.DisplayName.."(@"..player.Name..", "..player.UserId..") logged into the admin panel.")
		if script:GetAttribute("loadPrevious") then
			for _, log in logs do
				logClient:FireClient(player, log.Types, log.Message)
			end
		end
		table.insert(loggedAdmins, player.UserId)
		return true
	end
	return false
end

players.PlayerRemoving:Connect(function(player: Player)
	if table.find(loggedAdmins, player.UserId) then
		table.remove(loggedAdmins, table.find(loggedAdmins, player.UserId))
	end
end)

log.Event:Connect(function(key: string, types: {string}, message: string)
	if key ~= mainKey then return end
	table.insert(logs, {Types=types, Message=message})
	for _, player in loggedAdmins do
		if not players:GetPlayerByUserId(player) then
		    table.remove(loggedAdmins, player)
		    continue
		end
		logClient:FireClient((players:GetPlayerByUserId(player) :: Player), types, message)
	end
end)

checkAuth.OnServerInvoke = function(player: Player, key: string)
	if not verifyEvent:Invoke(mainKey, player, key) then kickEvent:Fire(mainKey, player, "unauthorized") return end
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
	if not verifyEvent:Invoke(mainKey, player, key) then kickEvent:Fire(mainKey, player, "unauthorized") return end
	return unloggedAdminCheck:Invoke(mainKey, player)
end
