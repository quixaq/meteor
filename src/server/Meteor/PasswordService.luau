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
	local a, _ = cryptography.Hashing.SHA2.SHA256(buffer.fromstring(pass))
	local b, _ = cryptography.Hashing.SHA3.SHA3_512(buffer.fromstring(salt..a))
	pass = buffer.tostring(cryptography.Utilities.Base64.Encode(buffer.fromstring(b)))
	for i=1, 10 do
	    local c, _ = cryptography.Hashing.SHA3.SHA3_512(buffer.fromstring(pass))
		pass = c
	end
	local d, _ = cryptography.Hashing.SHA2.SHA512(buffer.fromstring(pass))
	local e, _ = cryptography.Hashing.SHA3.SHA3_512(buffer.fromstring(d))
	return "h_"..salt..e
end

return module
