local useSpring = require(script.Parent.Parent.Parent.Hooks.useSpring)
local React = require(script.Parent.Parent.Parent.Parent.Parent.Packages.React)
local Theme = require(script.Parent.Parent.Parent.Theme)
local Button = require(script.Parent.Button)

local e = React.createElement

local BASE_SIZE = UDim2.fromOffset(20, 20)
local CORNER_RADIUS = UDim.new(0, 4)
local LOCKED_TRANSPARENCY = 0.6
local CHECK_THICKNESS = 2

export type CheckboxProps = {
	active: boolean,
	locked: boolean?,
	layoutOrder: number?,
	Size: UDim2?,
	Position: UDim2?,
	AnchorPoint: Vector2?,
	ZIndex: number?,
	onClick: () -> (),
}

local function Checkbox(props: CheckboxProps)
	local theme = Theme.useTheme()

	local activeAlpha, activeSpring = useSpring(if props.active then 1 else 0, { frequency = 6, dampingRatio = 1.1 })

	React.useEffect(function()
		activeSpring:setGoal(if props.active then 1 else 0)
	end, { props.active })

	local lockedTransparency = if props.locked then LOCKED_TRANSPARENCY else 0

	local activeTransparency = activeAlpha:map(function(value)
		return 1 - value * (1 - lockedTransparency)
	end)

	return e("Frame", {
		BackgroundTransparency = 1,
		Size = props.Size or BASE_SIZE,
		Position = props.Position,
		AnchorPoint = props.AnchorPoint,
		LayoutOrder = props.layoutOrder,
		ZIndex = props.ZIndex,
	}, {
		Button = e(Button, {
			Size = UDim2.fromScale(1, 1),
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5),
			hoverScale = if props.locked then 1 else 1.1,

			Activated = function()
				if props.locked then
					return
				end
				props.onClick()
			end,
		}, {
			Inactive = e("Frame", {
				BackgroundColor3 = theme.Background,
				BackgroundTransparency = lockedTransparency,
				Size = UDim2.fromScale(1, 1),
				ZIndex = 1,
			}, {
				Corner = e("UICorner", { CornerRadius = CORNER_RADIUS }),
				Stroke = e("UIStroke", {
					Color = theme.Border,
					Thickness = 1,
					Transparency = lockedTransparency,
				}),
			}),

			Active = e("Frame", {
				BackgroundColor3 = theme.Brand,
				BackgroundTransparency = activeTransparency,
				Size = UDim2.fromScale(1, 1),
				ZIndex = 2,
			}, {
				Corner = e("UICorner", { CornerRadius = CORNER_RADIUS }),

				Check = e("Frame", {
					Size = UDim2.fromScale(0.7, 0.7),
					Position = UDim2.fromScale(0.5, 0.5),
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundTransparency = 1,
				}, {
					Scale = e("UIScale", { Scale = activeAlpha }),

					ShortArm = e("Frame", {
						BackgroundColor3 = Color3.new(1, 1, 1),
						BackgroundTransparency = activeTransparency,
						BorderSizePixel = 0,
						Size = UDim2.new(0.35, 0, 0, CHECK_THICKNESS),
						Position = UDim2.fromScale(0.3, 0.67),
						AnchorPoint = Vector2.new(0.5, 0.5),
						Rotation = 45,
					}),

					LongArm = e("Frame", {
						BackgroundColor3 = Color3.new(1, 1, 1),
						BackgroundTransparency = activeTransparency,
						BorderSizePixel = 0,
						Size = UDim2.new(0.65, 0, 0, CHECK_THICKNESS),
						Position = UDim2.fromScale(0.61, 0.53),
						AnchorPoint = Vector2.new(0.5, 0.5),
						Rotation = -50,
					}),
				}),
			}),
		}),
	})
end

return Checkbox
