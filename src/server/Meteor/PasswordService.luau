-- Meteor's password hashing service. Used to simplify hashing for our users and secure passwords.
--!strict

local cryptography = require(script.Parent.Packages.cryptography)
local rand = require(script.Parent.rand)

export type ModuleType = {
    Password: (string, string) -> string
}
local module: ModuleType = {} :: any

function module.Password(pass: string, salt: string): string
	if salt == "" then
		salt = rand.alphan(32)
	end
	local a, _ = cryptography.Hashing.SHA3.SHA3_256(buffer.fromstring(pass))
	local b, _ = cryptography.Hashing.SHA3.SHA3_512(buffer.fromstring(salt..a))
	pass = b
	for i=1, 10000 do
	    local c, _ = cryptography.Hashing.SHA3.SHA3_512(buffer.fromstring(pass))
		pass = c
	end
	return "h_"..salt..pass
end

return module
