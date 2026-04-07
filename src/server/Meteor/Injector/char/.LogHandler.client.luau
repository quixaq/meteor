--!strict
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local meteorFolder = replicatedStorage:WaitForChild("_Meteor") :: Folder
local players: Players = game:GetService("Players")
local player: Player = players.LocalPlayer
local v1 = player.PlayerGui:WaitForChild("MeteorGui") :: ScreenGui
local v2 = v1:WaitForChild("Dashboard"):WaitForChild("Properties"):WaitForChild("Container"):WaitForChild("Logs"):WaitForChild("Logs") :: Folder
local r7 = meteorFolder:WaitForChild("__r7") :: RemoteEvent
local v3 = meteorFolder:WaitForChild("__g1"):Clone() :: TextLabel

(v1:WaitForChild("Login"):WaitForChild("Startup"):WaitForChild("OpenGui") :: BindableEvent).Event:Connect(function()
	if not (v1:WaitForChild("Login"):WaitForChild("Startup"):WaitForChild("CheckAuth") :: BindableFunction):Invoke() then return end
	(v2:WaitForChild("Content"):WaitForChild("All"):WaitForChild("ScrollingFrame") :: ScrollingFrame).CanvasPosition = Vector2.new(0, (v2:WaitForChild("Content"):WaitForChild("All"):WaitForChild("ScrollingFrame") :: ScrollingFrame).AbsoluteCanvasSize.Y);
	(v2:WaitForChild("Content"):WaitForChild("Anti-Cheat"):WaitForChild("ScrollingFrame") :: ScrollingFrame).CanvasPosition = Vector2.new(0, (v2:WaitForChild("Content"):WaitForChild("Anti-Cheat"):WaitForChild("ScrollingFrame") :: ScrollingFrame).AbsoluteCanvasSize.Y);
	(v2:WaitForChild("Content"):WaitForChild("Player"):WaitForChild("ScrollingFrame") :: ScrollingFrame).CanvasPosition = Vector2.new(0, (v2:WaitForChild("Content"):WaitForChild("Player"):WaitForChild("ScrollingFrame") :: ScrollingFrame).AbsoluteCanvasSize.Y);
	(v2:WaitForChild("Content"):WaitForChild("Moderation"):WaitForChild("ScrollingFrame") :: ScrollingFrame).CanvasPosition = Vector2.new(0, (v2:WaitForChild("Content"):WaitForChild("Moderation"):WaitForChild("ScrollingFrame") :: ScrollingFrame).AbsoluteCanvasSize.Y);
	(v2:WaitForChild("Content"):WaitForChild("Chat"):WaitForChild("ScrollingFrame") :: ScrollingFrame).CanvasPosition = Vector2.new(0, (v2:WaitForChild("Content"):WaitForChild("Chat"):WaitForChild("ScrollingFrame") :: ScrollingFrame).AbsoluteCanvasSize.Y);
end)

r7.OnClientEvent:Connect(function(p1: {string}, p2: string)
	local clone: TextLabel = v3:Clone()
	clone.Text = p2
	clone.Parent = v2:WaitForChild("Content"):WaitForChild("All"):WaitForChild("ScrollingFrame")
	if not clone.TextFits then
		clone.TextScaled = true
	end
	(v2:WaitForChild("Content"):WaitForChild("All"):WaitForChild("ScrollingFrame") :: ScrollingFrame).CanvasSize = UDim2.new(0, 0, 0, (v2:WaitForChild("Content"):WaitForChild("All"):WaitForChild("ScrollingFrame"):WaitForChild("UIListLayout") :: UIListLayout).AbsoluteContentSize.Y)
	for _, sp1 in p1 do
		local clone1: TextLabel = v3:Clone()
		clone1.Text = p2
		if sp1 == "AC" then
			clone1.Parent = v2:WaitForChild("Content"):WaitForChild("Anti-Cheat"):WaitForChild("ScrollingFrame");
			(v2:WaitForChild("Content"):WaitForChild("Anti-Cheat"):WaitForChild("ScrollingFrame") :: ScrollingFrame).CanvasSize = UDim2.new(0, 0, 0, v2.Content["Anti-Cheat"].ScrollingFrame.UIListLayout.AbsoluteContentSize.Y)
		elseif sp1 == "Player" then
			clone1.Parent = v2:WaitForChild("Content"):WaitForChild("Player"):WaitForChild("ScrollingFrame");
			(v2:WaitForChild("Content"):WaitForChild("Player"):WaitForChild("ScrollingFrame") :: ScrollingFrame).CanvasSize = UDim2.new(0, 0, 0, v2.Content.Player.ScrollingFrame.UIListLayout.AbsoluteContentSize.Y)
		elseif sp1 == "Mod" then
			clone1.Parent = v2:WaitForChild("Content"):WaitForChild("Moderation"):WaitForChild("ScrollingFrame");
			(v2:WaitForChild("Content"):WaitForChild("Moderation"):WaitForChild("ScrollingFrame") :: ScrollingFrame).CanvasSize = UDim2.new(0, 0, 0, v2.Content.Moderation.ScrollingFrame.UIListLayout.AbsoluteContentSize.Y)
		elseif sp1 == "Chat" then
			clone1.Parent = v2:WaitForChild("Content"):WaitForChild("Chat"):WaitForChild("ScrollingFrame");
			(v2:WaitForChild("Content"):WaitForChild("Chat"):WaitForChild("ScrollingFrame") :: ScrollingFrame).CanvasSize = UDim2.new(0, 0, 0, v2.Content.Chat.ScrollingFrame.UIListLayout.AbsoluteContentSize.Y)
		end
		if not clone1.TextFits then
			clone1.TextScaled = true
		end
	end
end)
