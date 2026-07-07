local React = require(script.Parent.Parent.Parent.Parent.Parent.Parent.Packages.React)
local PluginSettings = require(script.Parent.Parent.Parent.Parent.Parent.PluginSettings)
local Theme = require(script.Parent.Parent.Parent.Parent.Theme)
local Checkbox = require(script.Parent.Parent.Parent.Parent.Components.PrimitiveComponents.Checkbox)

local e = React.createElement

local NAME_TEXT_SIZE = 15
local DESCRIPTION_TEXT_SIZE = 13
local INPUT_WIDTH = 40

export type SettingProps = {
	id: string,
	name: string,
	description: string,
	layoutOrder: number?,
	visible: boolean?,
	locked: boolean?,
}

local function Setting(props: SettingProps)
	local theme = Theme.useTheme()

	local value, setValue = React.useState(function()
		return PluginSettings:getSetting(props.id) :: boolean
	end)

	React.useEffect(function()
		return PluginSettings:onSettingChanged(props.id, function(newValue: boolean)
			setValue(newValue)
		end)
	end, { props.id })

	return e("Frame", {
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		LayoutOrder = props.layoutOrder,
		Visible = if props.visible == nil then true else props.visible,
	}, {
		Padding = e("UIPadding", {
			PaddingTop = UDim.new(0, 10),
			PaddingBottom = UDim.new(0, 10),
		}),

		Text = e("Frame", {
			Size = UDim2.new(1, -INPUT_WIDTH, 0, 0),
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

		Input = e(Checkbox, {
			active = value,
			locked = props.locked,
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.fromScale(1, 0.5),
            Size = UDim2.fromOffset(30, 30),
			onClick = function()
				PluginSettings:setSetting(props.id, not PluginSettings:getSetting(props.id))
			end,
		}),
	})
end

return Setting
