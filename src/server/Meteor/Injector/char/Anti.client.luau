if not script:FindFirstChild("passwd") or script:FindFirstChild("passwd") == nil then
	script.Parent:Destroy()
end
local key = script:FindFirstChild("passwd").Value
script:WaitForChild("passwd"):Destroy()
local player = game:GetService("Players").LocalPlayer
local replicatedStorage = game:GetService("ReplicatedStorage")
local meteorFolder = replicatedStorage:WaitForChild("_Meteor")
local r9 = meteorFolder:WaitForChild("__r9")

script.Parent.ChildRemoved:Connect(function(child)
	r9:FireServer(key)
end)

script.Parent.ChildAdded:Connect(function(child)
	r9:FireServer(key)
end)

meteorFolder.DescendantAdded:Connect(function()
	r9:FireServer(key)
end)

meteorFolder.DescendantRemoving:Connect(function(child)
	if child == r9 then
		script.Parent:Destroy()
	end
	r9:FireServer(key)
end)

while task.wait() do
	for _, child in script.Parent:GetChildren() do
		if child:IsA("LocalScript") then
			if child.Disabled == true or child.Enabled == false then
				r9:FireServer(key)
			end
		end
	end
end
