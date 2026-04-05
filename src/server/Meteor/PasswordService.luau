-- Meteor's password hashing service. Used to simplify hashing for our users and secure passwords.

local cryptography = require(script.Parent.Packages.Cryptography)
local rand = require(script.Parent.rand)

local module = {}

function module.Password(pass, salt)
	if salt == "" then
		salt = rand.alphan(32)
		while string.find(salt, "g") do
			salt = string.gsub(salt, "g", rand.alphan(1))
		end
	end
	local pass, _ = cryptography.Hashing.SHA2.SHA256(buffer.fromstring(pass))
	local pass, _ = buffer.tostring(cryptography.Utilities.Base64.Encode(buffer.fromstring(cryptography.Hashing.SHA3.SHA3_512(buffer.fromstring(salt..pass)))))
	for i=1, 10 do
	    local x, _ = cryptography.Hashing.SHA3.SHA3_512(buffer.fromstring(pass))
		pass = x
	end
	local pass, _ = cryptography.Hashing.SHA2.SHA512(buffer.fromstring(pass))
	local pass, _ = cryptography.Hashing.SHA3.SHA3_512(buffer.fromstring(pass))
	return "h_"..salt.."g"..pass
end

return module
