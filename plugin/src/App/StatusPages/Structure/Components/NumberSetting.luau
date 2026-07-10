local useSpring = require(script.Parent.Parent.Parent.Parent.Hooks.useSpring)
local React = require(script.Parent.Parent.Parent.Parent.Parent.Parent.Packages.React)
local GetInvertedColor = require(script.Parent.Parent.Parent.Parent.Parent.Utils.GetInvertedColor)
local Theme = require(script.Parent.Parent.Parent.Parent.Theme)

local e = React.createElement

local NAME_TEXT_SIZE = 15
local DESCRIPTION_TEXT_SIZE = 13
local INPUT_WIDTH = 60
local INPUT_HEIGHT = 28
local INVALID_COLOR = Color3.fromRGB(220, 60, 60)

local FLASH_STATES = {
	PEAK = 1,
	REST = 0,
}

local BEVEL_GRADIENT = {
	Rotation = 90,
	Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(187, 187, 187)),
	}),
}

export type NumberSettingProps = {
	name: string,
	description: string,
	value: number,
	minValue: number,
	maxValue: number?,
	integer: boolean?,
	layoutOrder: number?,
	setValue: (value: number) -> (),
}

local function NumberSetting(props: NumberSettingProps)
	local theme = Theme.useTheme()

	-- Snapped to PEAK on invalid input, then springs back down to REST
	local flash, flashSpring = useSpring(FLASH_STATES.REST, { frequency = 2, dampingRatio = 1 })

	return e("Frame", {
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		LayoutOrder = props.layoutOrder,
	}, {
		Padding = e("UIPadding", {
			PaddingTop = UDim.new(0, 10),
			PaddingBottom = UDim.new(0, 10),
		}),

		Text = e("Frame", {
			Size = UDim2.new(1, -INPUT_WIDTH - 10, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
		}, {
			Layout = e("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 5),
			}),

			Name = e("TextLabel", {
				Text = props.name,
				Font = Enum.Font.BuilderSansBold,
				TextSize = NAME_TEXT_SIZE,
				TextColor3 = theme.Foreground,
				TextXAlignment = Enum.TextXAlignment.Left,

				Size = UDim2.new(1, 0, 0, NAME_TEXT_SIZE),

				LayoutOrder = 1,
				BackgroundTransparency = 1,
			}),

			Description = e("TextLabel", {
				Text = props.description,
				Font = Enum.Font.BuilderSans,
				LineHeight = 1.2,
				TextSize = DESCRIPTION_TEXT_SIZE,
				TextColor3 = theme.SubText,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextWrapped = true,

				Size = UDim2.fromScale(1, 0),
				AutomaticSize = Enum.AutomaticSize.Y,

				LayoutOrder = 2,
				BackgroundTransparency = 1,
			}),
		}),

		Input = e("Frame", {
			Size = UDim2.fromOffset(INPUT_WIDTH, INPUT_HEIGHT),
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.fromScale(1, 0.5),
			BackgroundColor3 = theme.Background,
			BorderSizePixel = 0,
		}, {
			UIStroke = e("UIStroke", {
				Color = flash:map(function(alpha: number)
					return GetInvertedColor(theme.Background):Lerp(INVALID_COLOR, alpha)
				end),
				Thickness = flash:map(function(alpha: number)
					return 1 + alpha
				end),
			}),
			UIGradient = e("UIGradient", BEVEL_GRADIENT),

			InputBox = e("TextBox", {
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
				Font = Enum.Font.BuilderSansBold,
				Text = tostring(props.value),
				TextColor3 = theme.Foreground,
				TextSize = 14,
				ClearTextOnFocus = false,

				[React.Event.FocusLost] = function(rbx: TextBox, _enterPressed: boolean, _inputObject: InputObject?)
					local number = tonumber(rbx.Text)

					if number == nil then
						rbx.Text = tostring(props.value)
						flashSpring:setPosition(FLASH_STATES.PEAK)
						return
					end

					if props.integer then
						number = math.round(number)
					end

					number = math.max(number, props.minValue)

					if props.maxValue then
						number = math.min(number, props.maxValue)
					end

					props.setValue(number)
					rbx.Text = tostring(number)
				end,
			}),
		}),
	})
end

return NumberSetting
