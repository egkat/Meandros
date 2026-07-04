local AssetService = game:GetService("AssetService")
local Icons = require(script.Parent.Parent.Parent.Parent.Parent.Assets.Icons)
local React = require(script.Parent.Parent.Parent.Parent.Parent.Parent.Packages.React)
local ReactRoblox = require(script.Parent.Parent.Parent.Parent.Parent.Parent.Packages.ReactRoblox)

local e = React.createElement

local DEFAULT_RESOLUTION_MULTIPLIER = 2

export type ColorWheelProps = {
	Size: number,
	ResolutionMultiplier: number?,
	Active: boolean?,
	selectedColor: Color3?,
	onColorChanged: ((newColor: Color3) -> ())?,
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
	local isDragging, setIsDragging = React.useState(false)
	local wheelButtonRef = React.useRef(nil :: ImageButton?)
	local dragOverlayTargetRef = React.useRef(nil :: LayerCollector?)

	local resolutionMultiplier = props.ResolutionMultiplier or DEFAULT_RESOLUTION_MULTIPLIER

	local selectedColor = props.selectedColor or Color3.fromHSV(0, 0, 1)
	local hue, saturation = selectedColor:ToHSV()

	local function updateSelectedColor(inputX: number, inputY: number)
		local wheelButton = wheelButtonRef.current
		local onColorChanged = props.onColorChanged

		if not wheelButton or not onColorChanged then
			return
		end

		local wheelRadius = wheelButton.AbsoluteSize.X / 2
		local wheelCenter = wheelButton.AbsolutePosition + (wheelButton.AbsoluteSize / 2)
		local offset = Vector2.new(inputX, inputY) - wheelCenter

		local distance = math.min(offset.Magnitude, wheelRadius)

		local newHue = (math.atan2(offset.Y, offset.X) / (2 * math.pi)) % 1
		local newSaturation = if wheelRadius > 0 then distance / wheelRadius else 0

		onColorChanged(Color3.fromHSV(newHue, newSaturation, 1))
	end

	React.useEffect(function()
		local image = CreateWheelImage(props.Size, resolutionMultiplier)

		setWheelImage(image)

		return function()
			image:Destroy()
		end
	end, { props.Size, resolutionMultiplier })

	React.useEffect(function()
		if not props.Active then
			setIsDragging(false)
		end
	end, { props.Active })

	local cursorAngle = hue * 2 * math.pi
	local cursorPosition = UDim2.fromScale(
		0.5 + (math.cos(cursorAngle) * saturation * 0.5),
		0.5 + (math.sin(cursorAngle) * saturation * 0.5)
	)

	return e("Frame", {
		Size = UDim2.fromOffset(props.Size, props.Size),
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
	}, {
		Wheel = e("ImageLabel", {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,

			ImageContent = wheelImage and Content.fromObject(wheelImage),
		}),

		InputButton = e("ImageButton", {
			ref = wheelButtonRef,
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			ImageTransparency = 1,
			ZIndex = 2,

			[React.Event.MouseButton1Down] = function(rbx: ImageButton, x: number, y: number)
				if not props.Active then
					return
				end

				dragOverlayTargetRef.current = rbx:FindFirstAncestorWhichIsA("LayerCollector")
				setIsDragging(true)
				updateSelectedColor(x, y)
			end,
			[React.Event.MouseMoved] = function(_rbx, x: number, y: number)
				if isDragging then
					updateSelectedColor(x, y)
				end
			end,
			[React.Event.MouseButton1Up] = function()
				setIsDragging(false)
			end,
		}),

		DragOverlay = if isDragging and dragOverlayTargetRef.current
			then ReactRoblox.createPortal(
				e("ImageButton", {
					Size = UDim2.fromScale(1, 1),
					BackgroundTransparency = 1,
					ImageTransparency = 1,
					ZIndex = 10000,

					[React.Event.MouseMoved] = function(_rbx, x: number, y: number)
						updateSelectedColor(x, y)
					end,
					[React.Event.MouseButton1Up] = function()
						setIsDragging(false)
					end,
					[React.Event.MouseLeave] = function()
						setIsDragging(false)
					end,
				}),
				dragOverlayTargetRef.current
			)
			else nil,

		Cursor = e("ImageLabel", {
			Size = UDim2.fromScale(0.125, 0.125),
			Position = cursorPosition,
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			Image = Icons.OtherIcons.ColorWheelCursor,
			ZIndex = 3,
		}),
	})
end

return ColorWheel
