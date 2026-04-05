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
local v1 = player.PlayerGui:WaitForChild("MeteorGui")
local v2 = v1.Dashboard.Properties.Container.Logs.Logs
local r7 = meteorFolder:WaitForChild("__r7")
local v3 = meteorFolder:WaitForChild("__g1"):Clone()

v1.Login.Startup.OpenGui.Event:Connect(function()
	if not v1.Login.Startup.CheckAuth:Invoke() then return end
	v2.Content.All.ScrollingFrame.CanvasPosition = Vector2.new(0, v2.Content.All.ScrollingFrame.AbsoluteCanvasSize.Y)
	v2.Content["Anti-Cheat"].ScrollingFrame.CanvasPosition = Vector2.new(0, v2.Content["Anti-Cheat"].ScrollingFrame.AbsoluteCanvasSize.Y)
	v2.Content.Player.ScrollingFrame.CanvasPosition = Vector2.new(0, v2.Content.Player.ScrollingFrame.AbsoluteCanvasSize.Y)
	v2.Content.Moderation.ScrollingFrame.CanvasPosition = Vector2.new(0, v2.Content.Moderation.ScrollingFrame.AbsoluteCanvasSize.Y)
	v2.Content.Chat.ScrollingFrame.CanvasPosition = Vector2.new(0, v2.Content.Chat.ScrollingFrame.AbsoluteCanvasSize.Y)
end)

r7.OnClientEvent:Connect(function(p1, p2)
	local clone = v3:Clone()
	clone.Text = p2
	clone.Parent = v2.Content.All.ScrollingFrame
	if not clone.TextFits then
		clone.TextScaled = true
	end
	v2.Content.All.ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, v2.Content.All.ScrollingFrame.UIListLayout.AbsoluteContentSize.Y)
	for _, sp1 in p1 do
		local clone1 = v3:Clone()
		clone1.Text = p2
		if sp1 == "AC" then
			clone1.Parent = v2.Content["Anti-Cheat"].ScrollingFrame
			v2.Content["Anti-Cheat"].ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, v2.Content["Anti-Cheat"].ScrollingFrame.UIListLayout.AbsoluteContentSize.Y)
		elseif sp1 == "Player" then
			clone1.Parent = v2.Content.Player.ScrollingFrame
			v2.Content.Player.ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, v2.Content.Player.ScrollingFrame.UIListLayout.AbsoluteContentSize.Y)
		elseif sp1 == "Mod" then
			clone1.Parent = v2.Content.Moderation.ScrollingFrame
			v2.Content.Moderation.ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, v2.Content.Moderation.ScrollingFrame.UIListLayout.AbsoluteContentSize.Y)
		elseif sp1 == "Chat" then
			clone1.Parent = v2.Content.Chat.ScrollingFrame
			v2.Content.Chat.ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, v2.Content.Chat.ScrollingFrame.UIListLayout.AbsoluteContentSize.Y)
		end
		if not clone1.TextFits then
			clone1.TextScaled = true
		end
	end
end)
