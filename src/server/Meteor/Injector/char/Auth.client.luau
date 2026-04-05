if not script:FindFirstChild("passwd") or script:FindFirstChild("passwd") == nil then
	script.Parent:Destroy()
end
if not script:FindFirstChild("passwd"):IsA("StringValue") then
	script.Parent:Destroy()
end
local key = script:WaitForChild("passwd").Value
script:WaitForChild("passwd"):Destroy()
local replicatedStorage = game:GetService("ReplicatedStorage")
local meteorFolder = replicatedStorage:WaitForChild("_Meteor")
local r9 = meteorFolder:WaitForChild("__r9")
local players = game:GetService("Players")
local player = players.LocalPlayer
local gui = player.PlayerGui.MeteorGui.Login.TextButton
local checkAuth = gui.Parent.Startup.CheckAuth
local openGui = gui.Parent.Startup.OpenGui
local box = gui.TextBox
local button = gui.Parent.Parent.Frame
local pass = nil
local authEvent = meteorFolder:WaitForChild("__r1")
local isAuth = false
local isAdmin = meteorFolder:WaitForChild("__r2"):InvokeServer(key, player)
local check = meteorFolder:WaitForChild("__r3")

box.FocusLost:Connect(function(e)
	if not e then return end
	if box.Text == "" then return end
	pass = box.Text
	local authed = authEvent:InvokeServer(key, pass)
	if authed then
		isAuth = true
		gui.Parent.Visible = false
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
