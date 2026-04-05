--	__   __      _
--	|  \/  |    | |
--	| \  / | ___| |_ ___  ___  _ __
--	| |\/| |/ _ \ __/ _ \/ _ \| '__|
--	| |  | |  __/ ||  __/ (_) | |
--	|_|  |_|\___|\__\___|\___/|_|

--[[
	Meteor Anti-Cheat
	Copyright (C) 2026  Quixaq

	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with this program.  If not, see <https://www.gnu.org/licenses/>.
]]

--[[
	To edit Meteor's settings, please use the ".config" file, you can find it under this script.
	For guide on using our functions and features in your scripts, visit the "DeveloperGuide" file under this script.
]]










































-- Variables
local serverStorage = game:GetService("ServerStorage")
local replicatedStorage = game:GetService("ReplicatedStorage")
local players = game:GetService("Players")
local meteorFolder = serverStorage:WaitForChild("_Meteor")
local meteorFolderReplicated = replicatedStorage:WaitForChild("_Meteor")
local loadEvent = meteorFolder:WaitForChild("load.event")
local r9 = meteorFolderReplicated:WaitForChild("__r9")
local serverKickEvent = meteorFolder:WaitForChild("kick.player")
local verifyEvent = meteorFolder:WaitForChild("key.verify")
local rand = require(script.rand)
local passwordService = require(script.PasswordService)
local validKeys = meteorFolder:WaitForChild(".keys")
local session = nil
local temp = nil
local key = meteorFolder:FindFirstChild("key.security").Value
local kick_messages = script:WaitForChild(".config"):WaitForChild("Messages")
local log = meteorFolder:WaitForChild(".log")
local kickprefix = script:GetAttribute("kickPrefix")
local excludeAdmins = script:GetAttribute("excludeAdmins")
local excludeOnLogin = script:GetAttribute("excludeOnLogin")
local checkAuth = meteorFolder:WaitForChild("admin.check")
local checkAuth2 = meteorFolder:WaitForChild("check.admin")

-- Wait for load
loadEvent.OnInvoke = function(message)
	session = message
end

while not session do
	wait()
end

-- Checks
--[[
	Please do not attempt to remove this check,
	The script needs to be in ServerScriptService because it doesn't replicate to clients unlike workspace.
]]
if not script:IsDescendantOf(game:GetService("ServerScriptService")) then
	print('METEOR ANTI-CHEAT: Please put Meteor Anti-Cheat right under "ServerScriptService".')
	print("WARNING: METEOR WILL NOT CONTINUE RUNNING")
	script:Destroy()
end
--[[------------------------------------------------]]

if passwordService.Password("Meteor Anti-Cheat", "QuixaqGames") ~= "h_QuixaqGamesgf955f0e269e96b2c373ae8b3e57f76c7c17584e7634f647addad8ae0567d26ee9fde80829678697632fc6929aec4b4a461f440b9929c98706c9642a92d36c7d1" then
	print("METEOR ANTI-CHEAT: FATAL ERROR - CHECKS FAILED, TRY REINSTALLING METEOR")
	print("WARNING: METEOR WILL NOT CONTINUE RUNNING.")
	script:Destroy()
end


-- Verify session
if session ~= key then
	print("METEOR ANTI-CHEAT: FATAL ERROR - UNABLE TO VERIFY SESSION. IT MAY BE CAUSED BY CORRUPT OR MODIFIED FILES OR ANOTHER SCRIPT INTERFERING WITH METEOR'S FILES. TRY REINSTALLING METEOR.")
	print("WARNING: METEOR WILL NOT CONTINUE RUNNING.")
	script:Destroy()
end

-- Functions
local function verify(key, player)
	if key == nil then return false end
	local keyObject = validKeys:FindFirstChild(player.UserId):FindFirstChild(key)
	if not keyObject or keyObject == nil then
		return false
	end
	if not keyObject:IsA("StringValue") then
		return false
	end
	if keyObject.Value ~= key then
		return false
	end
	return true
end

local function kick(player, reason)
	if excludeAdmins and checkAuth:Invoke(key, player) then return end
	if excludeAdmins and excludeOnLogin == false and checkAuth2:Invoke(key, player) then return end
	if kick_messages:FindFirstChild(reason) then
		reason = kick_messages:FindFirstChild(reason).Value
	end
	player:Kick(tostring(kickprefix)..tostring(reason))
	log:Fire(key,{"Player", "Mod", "AC"},player.DisplayName.."(@"..player.Name..", "..player.UserId..") has been kicked by Meteor Anti-Cheat for: "..tostring(reason))
end

-- Events
r9.OnServerEvent:Connect(function(player, key)
	if not verify(key, player) then
		kick(player, "cheat")
		return
	end
	kick(player, "cheat")
end)
serverKickEvent.Event:Connect(function(key, player, reason)
	if key ~= session then
		return
	end
	kick(player, reason)
end)
verifyEvent.OnInvoke = function(mainKey, player, key)
	if mainKey ~= session then
		return
	end
	return verify(key, player)
end

-- Logging
players.PlayerAdded:Connect(function(player)
	log:Fire(key,{"Player"},player.DisplayName.."(@"..player.Name..", "..player.UserId..") joined the game.")
	player.Chatted:Connect(function(msg)
		log:Fire(key,{"Chat"}, player.DisplayName.."(@"..player.Name..", "..player.UserId.."): "..msg)
	end)
end)

players.PlayerRemoving:Connect(function(player)
	log:Fire(key,{"Player"}, player.DisplayName.."(@"..player.Name..", "..player.UserId..") left the game.")
end)

meteorFolderReplicated:WaitForChild("__r5").OnServerEvent:Connect(function(player, key, msg)
	kick(player, "cheat")
end)

meteorFolderReplicated:WaitForChild("__r10").OnServerInvoke = function(player, key)
	kick(player, "cheat")
end
