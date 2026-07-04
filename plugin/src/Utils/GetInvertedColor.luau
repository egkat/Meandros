return function(color: Color3): Color3
    
	local oldR = color.R * 255
	local oldG = color.G * 255
	local oldB = color.B * 255

	local newR = 255 - oldR
	local newG = 255 - oldG
	local newB = 255 - oldB

    return Color3.fromRGB(newR, newG, newB)

end
