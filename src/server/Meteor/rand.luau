-- Meteor Anti-Cheat Utility.

local rand = {}
-- Alphanumeric
function rand.alphan(data)
	local charset = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
	local result = {}
	for i = 1, data do
		local rand = math.random(#charset)
		result[i] = charset:sub(rand, rand)
	end
	return table.concat(result)
end

function rand.bytes(data)
	local result = ""
	for i = 1, data do
		result = result .. string.char(math.random(0, 255))
	end
	return result
end

return rand
