local Button = require(script.Parent.Parent.Parent.Parent.Components.PrimitiveComponents.Button)
local TextLabel = require(script.Parent.Parent.Parent.Parent.Components.PrimitiveComponents.TextLabel)
local React = require(script.Parent.Parent.Parent.Parent.Parent.Parent.Packages.React)
local GetInvertedColor = require(script.Parent.Parent.Parent.Parent.Parent.Utils.GetInvertedColor)
local Theme = require(script.Parent.Parent.Parent.Parent.Theme)

local e = React.createElement

export type ActionButtonProps = {
	text: string,
	icon: string,
	color: Color3,
	size: UDim2?,
	layoutOrder: number?,
	onActivated: () -> (),
}

local MAX_TEXT_SIZE = 24

local function ActionButton(props: ActionButtonProps)
	local theme = Theme.useTheme()

	return e(Button, {
		LayoutOrder = props.layoutOrder,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = props.size or UDim2.fromOffset(85, 85),
		hoverScale = 1.05,
		Activated = props.onActivated,
	}, {
		ContainerFrame = e("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromScale(1, 1),
			BorderSizePixel = 0,
			BackgroundColor3 = props.color,
		}, {
			Icon = e("ImageLabel", {
				AnchorPoint = Vector2.new(0.5, 0),
				Position = UDim2.fromScale(0.5, 0.08),
				Size = UDim2.fromScale(0.55, 0.55),
				BackgroundTransparency = 1,
				Image = props.icon,
				ScaleType = Enum.ScaleType.Fit,
			}),

			Label = e(TextLabel, {
				AnchorPoint = Vector2.new(0.5, 1),
				Position = UDim2.new(0.5, 0, 1, -6),
				Size = UDim2.new(1, -10, 0.22, 0),
				Text = props.text,
				Stroke = {
					Color = Color3.fromRGB(0, 0, 0),
					Thickness = 2,
					Transparency = 0,
				},
			}, {
				TextSizeConstraint = e("UITextSizeConstraint", {
					MaxTextSize = MAX_TEXT_SIZE,
				}),
			}),
			UIStroke = e("UIStroke", {
				Color = GetInvertedColor(theme.Background),
				Thickness = 1,
			}),
			UIGradient = e("UIGradient", {
				Rotation = 90,
				Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
					ColorSequenceKeypoint.new(1, Color3.fromRGB(187, 187, 187)),
				}),
			}),
		}),
	})
end

return ActionButton
