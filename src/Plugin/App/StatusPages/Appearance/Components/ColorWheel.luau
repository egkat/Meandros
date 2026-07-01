local AssetService = game:GetService("AssetService")
local React = require(script.Parent.Parent.Parent.Parent.Parent.Parent.Packages.React)

local e = React.createElement

local DEFAULT_RESOLUTION_MULTIPLIER = 2

export type ColorWheelProps = {
	Size: number,
	ResolutionMultiplier: number?,
}

local function CreateWheelImage(Size: number, resolutionMultiplier: number)
	local renderSize = math.round(Size * resolutionMultiplier)

	local editableImage = AssetService:CreateEditableImage({
		Size = Vector2.new(renderSize, renderSize),
	})

	local pixelBuffer = buffer.create(renderSize * renderSize * 4)

	local wheelRadius = renderSize / 2

	for y = 0, renderSize - 1 do
		for x = 0, renderSize - 1 do
			local deltaX = x - wheelRadius
			local deltaY = y - wheelRadius

			local distance = math.sqrt(math.pow(deltaX, 2) + math.pow(deltaY, 2))

			local pixelIndex = ((y * renderSize) + x) * 4

			if distance <= wheelRadius then
				-- In Radians
				local deltaAngle = math.atan2(deltaY, deltaX)

				-- See https://www.lua.org/manual/5.3/manual.html#3.4.1
				local hue = (deltaAngle / (2 * math.pi)) % 1
				local saturation = distance / wheelRadius
				local value = 1

				local pixelColor = Color3.fromHSV(hue, saturation, value)

				-- RGBA
				buffer.writeu8(pixelBuffer, pixelIndex + 0, math.floor(pixelColor.R * 255))
				buffer.writeu8(pixelBuffer, pixelIndex + 1, math.floor(pixelColor.G * 255))
				buffer.writeu8(pixelBuffer, pixelIndex + 2, math.floor(pixelColor.B * 255))
				buffer.writeu8(pixelBuffer, pixelIndex + 3, 255)
			else
				-- Make Transparent (Outside of Circle)

				buffer.writeu8(pixelBuffer, pixelIndex + 0, 0)
				buffer.writeu8(pixelBuffer, pixelIndex + 1, 0)
				buffer.writeu8(pixelBuffer, pixelIndex + 2, 0)
				buffer.writeu8(pixelBuffer, pixelIndex + 3, 0)
			end
		end
	end

	editableImage:WritePixelsBuffer(Vector2.zero, editableImage.Size, pixelBuffer)

	return editableImage
end

local function ColorWheel(props: ColorWheelProps)
	local wheelImage, setWheelImage = React.useState(nil)

	local resolutionMultiplier = props.ResolutionMultiplier or DEFAULT_RESOLUTION_MULTIPLIER

	React.useEffect(function()
		local image = CreateWheelImage(props.Size, resolutionMultiplier)

		setWheelImage(image)

		return function()
			image:Destroy()
		end
	end, { props.Size, resolutionMultiplier })

	return e("Frame", {
		Size = UDim2.fromOffset(props.Size, props.Size),
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),
	}, {
		Wheel = e("ImageLabel", {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,

			ImageContent = wheelImage and Content.fromObject(wheelImage),
		}),
	})

end

return ColorWheel
