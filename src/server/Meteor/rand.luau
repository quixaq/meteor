-- Meteor Anti-Cheat Utility.
--!strict

export type ModuleType = {
    alphan: (number) -> string,
    bytes: (number) -> string
}
local module: ModuleType = {} :: any
-- Alphanumeric
function module.alphan(length: number): string
	local charset = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
	local result = {}
	for i = 1, length do
		local rand = math.random(#charset)
		result[i] = charset:sub(rand, rand)
	end
	return table.concat(result)
end

function module.bytes(length: number): string
	local result = ""
	for i = 1, length do
		result = result .. string.char(math.random(0, 255))
	end
	return result
end

return module
