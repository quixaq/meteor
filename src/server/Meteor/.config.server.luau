-- Meteor's config file
-- You can edit the variables to change Meteor Anti-Cheat's settings.

-- Permissions
local enableAdminPanel = true -- Enables admin UI panel. When disabled, exludeAdmins will always apply, even if excludeOnLogin is enabled. Default is true.
local admins = { -- Format: u_<userId> = "<admin_panel_password>",
	u_userId = "s_password", -- Plain text use case.
	u_UserId = "h_nLq8oDAnL8LCY5JBYQQnHXGB7MPdDVWhg6f2afa02d615a04e8ac1fbbf34d49db43f2fb09030cfae08e6390e97d867bb6a4da5863429512e499e3b099350eb2873e50f0389d7a7f7c8f33ae70108d65e5c", -- Hash use case.
	--[[
	For security reasons, we strongly recommend you to use hashes to store passwords here.
	However to not overcomplicate stuff, we make it not required.
	To use hashes, please use
	print(require(game:GetService("ServerScriptService").Meteor.PasswordService).Password("password", ""))
	in your Roblox Studio console(At the bottom of Roblox Studio) and paste the output string into the password field.
	If you prefer to use plain text, please add "s_" in front of the password in plain text.
	If you use neither "h_"(for hashes) or "s_"(for plain text) the admin will not be able to log in the admin panel.
	Please DO NOT use your Roblox password, especially if you choose to store it in plain text.
	If you disabled enableAdminPanel or want the admin to not be able to login you can just set the password to an empty string("") without any prefixes.
	]]--
	u_4115533555 = "h_aPYwxKzvVXO2YGQhGSMG0NOAOAjFop6ga01c94e30e1da3eb9fa9a9960ae947c4fbac3695f2dc7fc0249b871be2a617d6d47ba4831cebdd45b8251b23adea8887b0825da77270808c9653c3a954ae6979"
}
local maxTries = 5 -- The amount of maximum tries to login to the admin panel before executing the set punishment. Default is 5.
local punishment = "revoke" -- The punishment for reaching max tries. "revoke" to make the user unable to login or use admin for the current server, "ban" to ban the player for the set duration, "kick" to kick the player. Default is "revoke".
local banTime = 300 -- The duration of the ban in seconds. Will not be used if the punishment is not set to "ban". Default is 300. -1 = permament
local excludeAdmins = true -- Enable/Disable the exclusion of admins for anti-cheat punishments. Enable this if you have admin commands that may trigger anti-cheat and want your admins to be able to use them. Default is true.
local excludeOnLogin = true -- Make the exclusion from anti-cheat kicks happen only after logging in the admin panel. Default is true.

-- Local detection toggles. true = enable, false = disable. Default for all is true.
local antiFreecam = true
local antiFly = true
local antiFloat = true
local antiNoClip = true
local antiGuiTamper = true
local antiInject = true

-- Logging
local loadPrevious = true -- Load previous logs to newly joined admins. Default is true.

-- Intervals
local localResetTime 	= 30	-- How often should the local scripts of our anti-cheat reset(in seconds). It's recommended to be under 60. Minimal value is 5. Default is 30.
local heartbeatInterval = 10	-- How often should client side be requested for a response to check are all scripts running properly. It's recommended to be at least 5 and not more than 15. Default is 10.

-- Anti-bot
local minAccountAge		= 7	-- What should be the minimum account age to play the game(in days). 0 or below = disable check. Default is 30.
local antiBotEnabled	= true	-- Should the anti-bot be enabled. Default is true.

-- Anti-Fly
local maxAirTime		= 7		-- Max time for a player to be in air before flagging them for flying. Default is 7.
local groundDistance	= 5		-- The distance that the player needs to have to the nearest object to be considered on the ground. Default is 5.
local antiFlyEnabled	= true	-- Should the server-side anti-fly be enabled. Default is true.

-- Anti-Teleport
local maxStudsPerSecond	= 50	-- Max studs a player can move in a second. Default is 50
local maxSitSPS			= false	-- Max studs a player can move in a second while seated. false = no change, number = desired studs per second. Default is false.

-- General
local kickPrefix		= "METEOR ANTI-CHEAT: "		-- The kick message prefix. Default is "METEOR ANTI-CHEAT: ". To disable set the value to ""

-- Kick messages, please edit only the second value.
local cheat				= {"cheat",			"Cheating detected."}
local unauthorized		= {"unauthorized",	"Cheating detected."}
local age				= {"age",			`To prevent spam, we require your account to be at least {minAccountAge} days old. You will be able to play the game after your account reaches the required age.`}
local tries				= {"tries",			"User exceeded maximum authentication tries."}
local verify			= {"verify",		"To prevent spam, we require you to have an e-mail address or phone number linked to your Roblox account. You can link it in Settings > Account Info"}

--- END OF CONFIG ---








































-- Checks
if type(localResetTime) ~= "number" then
	localResetTime = 30
end
if type(heartbeatInterval) ~= "number" then
	heartbeatInterval = 10
end
if localResetTime ~= math.floor(localResetTime) then
	localResetTime = 30
end
if type(minAccountAge) ~= "number" then
	minAccountAge = 30
end
if punishment ~= "revoke" and punishment ~= "ban" and punishment ~= "kick" then
	punishment = "revoke"
end
if banTime <= 0 and banTime ~= -1 then
	banTime = 300
end
if loadPrevious ~= true and loadPrevious ~= false then
	loadPrevious = true
end
if type(maxAirTime) ~= "number" then
	maxAirTime = 7
end
if maxAirTime < 0 then
	maxAirTime = 7
end
if type(groundDistance) ~= "number" then
	groundDistance = 5
end
if groundDistance < 0 then
	groundDistance = 5
end
if enableAdminPanel == false and excludeOnLogin == true then
	excludeOnLogin = false
end

-- Set values
script.Parent:SetAttribute("heartbeatInterval", heartbeatInterval)
script.Parent:SetAttribute("localResetTime", localResetTime)
script.Parent:SetAttribute("minAccountAge", minAccountAge)
script.Parent:SetAttribute("maxAir", maxAirTime)
script.Parent.Auth:SetAttribute("maxTries", maxTries)
script.Parent.Auth:SetAttribute("punishment", punishment)
script.Parent.Auth:SetAttribute("banTime", banTime)
script.Parent.Auth:SetAttribute("loadPrevious", loadPrevious)
script.Parent:SetAttribute("groundDist", groundDistance)
script.Parent:SetAttribute("kickPrefix", kickPrefix)
script.Parent:SetAttribute("excludeAdmins", excludeAdmins)
script.Parent:SetAttribute("MaxSPS", maxStudsPerSecond)
script.Parent:SetAttribute("MaxSitSPS", maxSitSPS)
script.Parent:SetAttribute("excludeOnLogin", excludeOnLogin)

-- Disable scripts
local scriptsFolder = script.Parent.Injector.char
if not antiFly then
	scriptsFolder["Anti-Fly"]:Destroy()
end
if not antiFloat then
	scriptsFolder["Anti-Float"]:Destroy()
end
if not antiInject then
	scriptsFolder["Anti-Inject"]:Destroy()
end
if not antiNoClip then
	scriptsFolder["Anti-Noclip"]:Destroy()
end
if not antiFreecam then
	scriptsFolder.AntiFreeCam:Destroy()
end
if not antiGuiTamper then
	scriptsFolder["Anti-Tamper"]:Destroy()
end

if antiBotEnabled == false then
	script.Parent["Anti-Bot"].Enabled = false
end
if antiFlyEnabled == false then
	script.Parent["Anti-Fly"].Enabled = false
end

if enableAdminPanel == false then
	script.Parent.Auth.Enabled = false
	script.Parent.Injector.char.Auth:Destroy()
	script.Parent.Injector.char[".LogHandler"]:Destroy()
	for _, child in script.Parent.Loader.dep.StarterGui.MeteorGui:GetChildren() do
	    if child.Name ~= "Show" and child.Name ~= "Hide" then
			child:Destroy()
		end
	end
end

local messages = {cheat,unauthorized,age,tries,verify}
local folder = Instance.new("Folder")
folder.Name = "Messages"
folder.Parent = script

for i, value in pairs(messages) do
	local sval = Instance.new("StringValue")
	sval.Name = value[1]
	sval.Value = value[2]
	sval.Parent = folder
end

local passwordService = require(script.Parent.PasswordService)

game:GetService("ServerStorage"):WaitForChild("_Meteor"):WaitForChild("admin.auth").OnInvoke = function(key, id, pass)
	if key ~= game:GetService("ServerStorage"):WaitForChild("_Meteor"):FindFirstChild("key.security").Value then return false end
	if not enableAdminPanel then return end
	local admin = admins["u_"..id]
	local prefix = string.sub(admin, 1, 2)
	if not admin then return false end
	if prefix == "s_" then
		if admin ~= "s_"..pass then return false end
		return true
	end
	if prefix == "h_" then
		local start = string.find(admin, "_") + 1
		local endd = string.find(admin, "g") - 1
		if passwordService.Password(pass, string.sub(admin, start, endd)) ~= admin then return false end
		return true
	end
	return false
end

game:GetService("ServerStorage"):WaitForChild("_Meteor"):WaitForChild("check.admin").OnInvoke = function(key, player)
	if key ~= game:GetService("ServerStorage"):WaitForChild("_Meteor"):FindFirstChild("key.security").Value then return false end
	if admins["u_"..player.UserId] then
		return true
	end
	return false
end
