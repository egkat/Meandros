export type BuildPosition = Vector3 | "Camera"

-- Parses a build position string into either the literal "Camera" or a Vector3.
-- Accepts "Camera" (case-insensitive) or a tuple like "(100, 100, 100)" / "100, 100, 100".
-- Returns nil if the text is neither.
return function(text: string): BuildPosition?
	local trimmed = text:gsub("^%s+", ""):gsub("%s+$", "")

	if trimmed:lower() == "camera" then
		return "Camera" :: "Camera"
	end

	local x, y, z = trimmed:match("^%(?%s*(%-?[%d%.]+)%s*,%s*(%-?[%d%.]+)%s*,%s*(%-?[%d%.]+)%s*%)?$")

	local numberX = tonumber(x)
	local numberY = tonumber(y)
	local numberZ = tonumber(z)

	if numberX == nil or numberY == nil or numberZ == nil then
		return nil
	end

	return Vector3.new(numberX, numberY, numberZ)
end
