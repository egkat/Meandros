local React = require(script.Parent.Parent.Parent.Parent.Parent.Parent.Packages.React)
local Dropdown = require(script.Parent.Parent.Parent.Parent.Components.PrimitiveComponents.Dropdown)
local Theme = require(script.Parent.Parent.Parent.Parent.Theme)

local e = React.createElement

local NAME_TEXT_SIZE = 15
local DESCRIPTION_TEXT_SIZE = 13
local DESCRIPTION_HEIGHT = 16
local VERTICAL_PADDING = 10
local TEXT_GAP = 5
local CLOSED_WIDTH = 60
local OPEN_WIDTH = 220
local DROPDOWN_HEIGHT = 28
local ABRIDGED_LENGTH = 3

local ROW_HEIGHT = VERTICAL_PADDING + NAME_TEXT_SIZE + TEXT_GAP + DESCRIPTION_HEIGHT + VERTICAL_PADDING

export type AlgorithmSettingProps = {
	name: string,
	description: string,
	active: string,
	options: { string },
	layoutOrder: number?,
	ZIndex: number?,
	onSelect: (selectedOption: string) -> (),
}

local function AlgorithmSetting(props: AlgorithmSettingProps)
	local theme = Theme.useTheme()

	return e("Frame", {
		Size = UDim2.new(1, 0, 0, ROW_HEIGHT),
		BackgroundTransparency = 1,
		LayoutOrder = props.layoutOrder,
		ZIndex = props.ZIndex,
	}, {
		Padding = e("UIPadding", {
			PaddingTop = UDim.new(0, VERTICAL_PADDING),
			PaddingBottom = UDim.new(0, VERTICAL_PADDING),
		}),

		Name = e("TextLabel", {
			Text = props.name,
			Font = Enum.Font.BuilderSansBold,
			TextSize = NAME_TEXT_SIZE,
			TextColor3 = theme.Foreground,
			TextXAlignment = Enum.TextXAlignment.Left,

			Size = UDim2.new(1, -CLOSED_WIDTH - 10, 0, NAME_TEXT_SIZE),
			Position = UDim2.fromOffset(0, 0),

			BackgroundTransparency = 1,
		}),

		Description = e("TextLabel", {
			Text = props.description,
			Font = Enum.Font.BuilderSans,
			TextSize = DESCRIPTION_TEXT_SIZE,
			TextColor3 = theme.SubText,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextTruncate = Enum.TextTruncate.AtEnd,

			Size = UDim2.new(1, -CLOSED_WIDTH - 10, 0, DESCRIPTION_HEIGHT),
			Position = UDim2.fromOffset(0, NAME_TEXT_SIZE + TEXT_GAP),

			BackgroundTransparency = 1,
		}),

		Input = e(Dropdown, {
			active = props.active,
			closedText = string.sub(props.active, 1, ABRIDGED_LENGTH) .. "…",
			dropdownOptions = props.options,
			Size = UDim2.fromOffset(CLOSED_WIDTH, DROPDOWN_HEIGHT),
			openSize = UDim2.fromOffset(OPEN_WIDTH, DROPDOWN_HEIGHT),
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.fromScale(1, 0.5),
			onSelect = props.onSelect,
		}),
	})
end

return AlgorithmSetting
