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
local r9 = meteorFolder:WaitForChild("__r9") :: RemoteEvent
local r8 = meteorFolder:WaitForChild("__r8") :: RemoteEvent
local r11 = meteorFolder:WaitForChild("__r11") :: RemoteFunction

local function f1()
	if not meteorFolder:FindFirstChild("__r9") then
		return
	end
	if #script.Parent:GetChildren() ~= r11:InvokeServer(key) then
		r9:FireServer(key)
		return
	end
	if meteorFolder:GetAttribute(".Meteor") ~= "4D 65 74 65 6F 72 41 43" then
		r9:FireServer(key)
		return
	end
	r8:FireServer(key, tick())
end

r9.OnClientEvent:Connect(f1)

f1()
