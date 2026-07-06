local Strict = require(script.Parent.Utils.Strict)

local Version = script.Parent.Parent.Version
local trimmedVersion = Version.Value:gsub("^%s+", ""):gsub("%s+$", "")

return Strict("Config", {
    version = trimmedVersion
})