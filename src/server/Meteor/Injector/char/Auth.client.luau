--!strict
if not script:FindFirstChild("passwd") or script:FindFirstChild("passwd") == nil then
	script.Parent:Destroy()
end
if not script:FindFirstChild("passwd"):IsA("StringValue") then
	script.Parent:Destroy()
end
local key: string = script:WaitForChild("passwd").Value
script:WaitForChild("passwd"):Destroy()
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local meteorFolder = replicatedStorage:WaitForChild("_Meteor") :: Folder
local players: Players = game:GetService("Players")
local player: Player = players.LocalPlayer
local gui = player.PlayerGui:WaitForChild("MeteorGui"):WaitForChild("Login"):WaitForChild("TextButton") :: TextButton
local checkAuth = player.PlayerGui:WaitForChild("MeteorGui"):WaitForChild("Login"):WaitForChild("CheckAuth") :: BindableFunction
local openGui = player.PlayerGui:WaitForChild("MeteorGui"):WaitForChild("Login"):WaitForChild("OpenGui") :: BindableEvent
local box = gui:WaitForChild("TextBox") :: TextBox
local button = player.PlayerGui:WaitForChild("MeteorGui"):WaitForChild("Frame") :: Frame
local pass: string = ""
local authEvent = meteorFolder:WaitForChild("__r1") :: RemoteFunction
local isAuth: boolean = false
local isAdmin = (meteorFolder:WaitForChild("__r2") :: RemoteFunction):InvokeServer(key, player)
local check = meteorFolder:WaitForChild("__r3") :: RemoteFunction

box.FocusLost:Connect(function(e: boolean)
	if not e then return end
	if box.Text == "" then return end
	pass = box.Text
	local authed: boolean = authEvent:InvokeServer(key, pass)
	if authed then
		isAuth = true
		(gui.Parent :: Frame).Visible = false
		openGui:Fire()
	end
end)

checkAuth.OnInvoke = function()
	return isAuth
end

isAuth = check:InvokeServer(key)
if not isAdmin then
	button.Visible = false
end
