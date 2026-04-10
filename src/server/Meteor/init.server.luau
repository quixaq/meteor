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









































--!strict
-- Variables

-- Wait for load
local loadEvent = script:WaitForChild("load.event") :: BindableFunction

local session: string = ""
loadEvent.OnInvoke = function(message: string)
	session = message
end

while session == "" do
	task.wait()
end

local serverStorage: ServerStorage = game:GetService("ServerStorage")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local players: Players = game:GetService("Players")
local meteorFolder = serverStorage:WaitForChild("_Meteor") :: Folder
local meteorFolderReplicated = replicatedStorage:WaitForChild("_Meteor") :: Folder
local r9 = meteorFolderReplicated:WaitForChild("__r9") :: RemoteEvent
local serverKickEvent = meteorFolder:WaitForChild("kick.player") :: BindableEvent
local verifyEvent = meteorFolder:WaitForChild("key.verify") :: BindableFunction
local validKeys = meteorFolder:WaitForChild(".keys") :: Folder
local key = (meteorFolder:WaitForChild("key.security") :: StringValue).Value
local kick_messages = script:WaitForChild(".config"):WaitForChild("Messages") :: Folder
local log = meteorFolder:WaitForChild(".log") :: BindableEvent
local kickprefix: string = script:GetAttribute("kickPrefix")
local excludeAdmins: boolean = script:GetAttribute("excludeAdmins")
local excludeOnLogin: boolean = script:GetAttribute("excludeOnLogin")
local checkAuth = meteorFolder:WaitForChild("admin.check") :: BindableFunction
local checkAuth2 = meteorFolder:WaitForChild("check.admin") :: BindableFunction

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

-- Verify session
if session ~= key then
	print("METEOR ANTI-CHEAT: FATAL ERROR - UNABLE TO VERIFY SESSION. IT MAY BE CAUSED BY CORRUPT OR MODIFIED FILES OR ANOTHER SCRIPT INTERFERING WITH METEOR'S FILES. TRY REINSTALLING METEOR.")
	print("WARNING: METEOR WILL NOT CONTINUE RUNNING.")
	script:Destroy()
end

-- Functions
local function verify(key: string, player: Player): boolean
	local keysFolder = validKeys:FindFirstChild(tostring(player.UserId)) :: Folder?
	if not keysFolder then
	    return false
	end
	local keyObject: Instance? = validKeys:FindFirstChild(key)
	if not keyObject then
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

local function kick(player: Player, reason: string)
	if excludeAdmins and checkAuth:Invoke(key, player) then return end
	if excludeAdmins and excludeOnLogin == false and checkAuth2:Invoke(key, player) then return end
	if kick_messages:FindFirstChild(reason) then
	    if (kick_messages:FindFirstChild(reason) :: Instance):IsA("StringValue") then
			reason = (kick_messages:FindFirstChild(reason) :: StringValue).Value
		end
	end
	player:Kick(kickprefix..reason)
	log:Fire(key,{"Player", "Mod", "AC"},player.DisplayName.."(@"..player.Name..", "..player.UserId..") has been kicked by Meteor Anti-Cheat for: "..tostring(reason))
end

-- Events
r9.OnServerEvent:Connect(function(player: Player, key: string)
	if not verify(key, player) then
		kick(player, "unauthorized")
		return
	end
	kick(player, "cheat")
end)
serverKickEvent.Event:Connect(function(key: string, player: Player, reason: string)
	if key ~= session then
		return
	end
	kick(player, reason)
end)
verifyEvent.OnInvoke = function(mainKey: string, player: Player, key: string): boolean
	if mainKey ~= session then
		return false
	end
	return verify(key, player)
end

-- Logging
players.PlayerAdded:Connect(function(player: Player)
	log:Fire(key,{"Player"},player.DisplayName.."(@"..player.Name..", "..player.UserId..") joined the game.")
	player.Chatted:Connect(function(msg)
		log:Fire(key,{"Chat"}, player.DisplayName.."(@"..player.Name..", "..player.UserId.."): "..msg)
	end)
end)

players.PlayerRemoving:Connect(function(player: Player)
	log:Fire(key,{"Player"}, player.DisplayName.."(@"..player.Name..", "..player.UserId..") left the game.")
end);

(meteorFolderReplicated:WaitForChild("__r5") :: RemoteEvent).OnServerEvent:Connect(function(player: Player)
	kick(player, "cheat")
end);

(meteorFolderReplicated:WaitForChild("__r10") :: RemoteFunction).OnServerInvoke = function(player: Player)
	kick(player, "cheat")
end

script:SetAttribute("load", true)
