--[[
	Meteor Anti-Cheat Developer Guide.
	
	This guide has been created for game developers that want to use our systems in their scripts.
	We will guide you through the ways you could use our already implemented solutions in your game to save time and resources.
	
	1. Player ping
		All of our ping values are one-way.
	
		As we send requests to the client on the heartbeat check, we can use the already sent requests to measure players' ping.
		To access the actual ping value, you can use "player:FindFirstChild("ActualPing").Value". The value is provided in milliseconds(ms).
		
		We also actively measure players' network ping that's provided by Roblox.
		To access the network ping value, you can use "player:FindFirstChild("NetworkPing").Value". The value is provided in milliseconds(ms)

	2. Injection
		We use a script to inject our local anti-cheat into clients. The injected scripts have some precautions made to avoid being tampered with.
		You can add your own localscripts there. To do that, you should add the localscripts to the char folder under the injector script. You'll have to add a . at the start of the name to avoid making a security hole though.
		Also you might need to adjust the script for it to work under the system because it reinjects all scripts everytime the configured(localResetTime) amount of time passes. They are injected into a folder inside of char.

	__r1 = auth event
	__r2 = admin check event
	__r3 = auth check event
	__r4 = cleanup event
	__r5 = spoof event
	__r6 = heartbeat event
	__r7 = log event
	__r8 = heartbeat send event
	__r9 = kick event
	__r10 = spoof event
	__r11 = local script amount
	
	__m1 = HashLib
	
	__g1 = log text example
]]--
