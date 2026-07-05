-- Drag logic from https://github.com/sircfenner/StudioComponents

local useFreshCallback = require(script.Parent.Parent.Parent.Hooks.useFreshCallback)
local useMouseDrag = require(script.Parent.Parent.Parent.Hooks.useMouseDrag)
local React = require(script.Parent.Parent.Parent.Parent.Parent.Packages.React)
local Theme = require(script.Parent.Parent.Parent.Theme)
local GetInvertedColor = require(script.Parent.Parent.Parent.Parent.Utils.GetInvertedColor)

local e = React.createElement

export type SliderProps = & {
	Disabled: boolean?,
	AnchorPoint: Vector2?,
	Position: UDim2?,
	Size: UDim2?,
	LayoutOrder: number?,
	ZIndex: number?,
	Value: number,
	OnChanged: ((newValue: number) -> ())?,
	OnCompleted: ((newValue: number) -> ())?,
	Min: number,
	Max: number,
	Step: number?,
}

local PADDING_BAR_SIDE = 3
local PADDING_REGION_TOP = 1
local PADDING_REGION_SIDE = 6

local BAR_HEIGHT = 4
local HANDLE_SIZE = 14

local BEVEL_GRADIENT = {
	Rotation = 90,
	Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(187, 187, 187)),
	}),
}

local INPUT_MOVE = Enum.UserInputType.MouseMovement

local function Slider(props: SliderProps)
	local theme = Theme.useTheme()

	local onChanged: (number) -> () = props.OnChanged or function() end

	local dragCallback = function(rbx: GuiObject, input: InputObject)
		local regionPos = rbx.AbsolutePosition.X + PADDING_REGION_SIDE
		local regionSize = rbx.AbsoluteSize.X - PADDING_REGION_SIDE * 2
		local inputPos = input.Position.X

		local alpha = (inputPos - regionPos) / regionSize
		local step = props.Step or 0

		local value = props.Min * (1 - alpha) + props.Max * alpha
		if step > 0 then
			value = math.round(value / step) * step
		end
		value = math.clamp(value, props.Min, props.Max)
		if value ~= props.Value then
			onChanged(value)
		end
	end

	local dragEndedCallback = useFreshCallback(function()
		if props.OnCompleted then
			props.OnCompleted(props.Value)
		end
	end, { props.Value, props.OnCompleted } :: { unknown })

	local dragDeps = { props.Value, props.Min, props.Max, props.Step, props.OnCompleted, onChanged } :: { unknown }
	local drag = useMouseDrag(dragCallback, dragDeps, nil, dragEndedCallback)

	local hovered, setHovered = React.useState(false)
	local highlighted = not props.Disabled and (hovered or drag.isActive())

	local alpha = (props.Value - props.Min) / (props.Max - props.Min)
	local strokeColor = GetInvertedColor(theme.Background)
	local disabledTransparency = props.Disabled and 0.4 or 0

	React.useEffect(function()
		if props.Disabled and drag.isActive() then
			drag.cancel()
		end
	end, { props.Disabled, drag.isActive() })

	local function inputBegan(rbx: Frame, input: InputObject)
		if input.UserInputType == INPUT_MOVE then
			setHovered(true)
		end
		if not props.Disabled then
			drag.onInputBegan(rbx, input)
		end
	end

	local function inputChanged(rbx: Frame, input: InputObject)
		if not props.Disabled then
			drag.onInputChanged(rbx, input)
		end
	end

	local function inputEnded(rbx: Frame, input: InputObject)
		if input.UserInputType == INPUT_MOVE then
			setHovered(false)
		end
		if not props.Disabled then
			drag.onInputEnded(rbx, input)
		end
	end

	-- if we use a Frame here, the 2d studio selection rectangle will appear when dragging
	-- we could prevent that using Active = true, but that displays the Click cursor
	-- ... the best workaround is a TextButton with Active = false
	return e("TextButton", {
		Text = "",
		Active = false,
		AutoButtonColor = false,
		Size = props.Size or UDim2.new(1, 0, 0, 22),
		Position = props.Position,
		AnchorPoint = props.AnchorPoint,
		LayoutOrder = props.LayoutOrder,
		ZIndex = props.ZIndex,
		BackgroundTransparency = 1,
		[React.Event.InputBegan] = inputBegan,
		[React.Event.InputChanged] = inputChanged,
		[React.Event.InputEnded] = inputEnded,
	}, {
		Bar = e("Frame", {
			ZIndex = 1,
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, PADDING_BAR_SIDE, 0.5, 0),
			Size = UDim2.new(1, -PADDING_BAR_SIDE * 2, 0, BAR_HEIGHT),
			BorderSizePixel = 0,
			BackgroundColor3 = theme.Background,
			BackgroundTransparency = disabledTransparency,
		}, {
			UIStroke = e("UIStroke", {
				Thickness = 1,
				Color = strokeColor,
				Transparency = disabledTransparency,
			}),
			UIGradient = e("UIGradient", BEVEL_GRADIENT),

			Fill = e("Frame", {
				Size = UDim2.fromScale(alpha, 1),
				BorderSizePixel = 0,
				BackgroundColor3 = theme.Brand,
				BackgroundTransparency = disabledTransparency,
			}, {
				UIGradient = e("UIGradient", BEVEL_GRADIENT),
			}),
		}),
		HandleRegion = e("Frame", {
			ZIndex = 2,
			Position = UDim2.fromOffset(PADDING_REGION_SIDE, PADDING_REGION_TOP),
			Size = UDim2.new(1, -PADDING_REGION_SIDE * 2, 1, -PADDING_REGION_TOP * 2),
			BackgroundTransparency = 1,
		}, {
			Handle = e("Frame", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(alpha, 0.5),
				Size = UDim2.fromOffset(HANDLE_SIZE, HANDLE_SIZE),
				BorderSizePixel = 0,
				BackgroundColor3 = if highlighted then theme.Brand else theme.Background,
				BackgroundTransparency = disabledTransparency,
			}, {
				UIStroke = e("UIStroke", {
					Thickness = 1,
					Color = strokeColor,
					Transparency = disabledTransparency,
				}),
				UIGradient = e("UIGradient", BEVEL_GRADIENT),
			}),
		}),
	})
end

return Slider
