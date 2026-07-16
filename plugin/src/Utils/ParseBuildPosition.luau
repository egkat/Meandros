export type BuildPosition = Vector3 | "Camera"


return function(text: string): BuildPosition?
	local trimmed = text:gsub("^%s+", ""):gsub("%s+$", "")

	if trimmed:lower() == "camera" then
		return "Camera" :: "Camera"
	end

	-- Holy regex
	local x, y, z = trimmed:match("^%(?%s*(%-?[%d%.]+)%s*,%s*(%-?[%d%.]+)%s*,%s*(%-?[%d%.]+)%s*%)?$")

	local numberX = tonumber(x)
	local numberY = tonumber(y)
	local numberZ = tonumber(z)

	if numberX == nil or numberY == nil or numberZ == nil then
		return nil
	end

	return Vector3.new(numberX, numberY, numberZ)
end
