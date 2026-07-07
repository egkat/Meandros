local React = require(script.Parent.Parent.Parent.Parent.Parent.Packages.React)
local Theme = require(script.Parent.Parent.Parent.Theme)

local e = React.createElement

local SCROLLBAR_THICKNESS = 6

export type ScrollingFrameProps = {
	contentSize: React.Binding<Vector2>,
	Size: UDim2?,
	Position: UDim2?,
	AnchorPoint: Vector2?,
	layoutOrder: number?,
	ZIndex: number?,
	children: React.ReactNode?,
}

local function ScrollingFrame(props: ScrollingFrameProps)
	local theme = Theme.useTheme()

	return e("ScrollingFrame", {
		Size = props.Size or UDim2.fromScale(1, 1),
		Position = props.Position,
		AnchorPoint = props.AnchorPoint,
		LayoutOrder = props.layoutOrder,
		ZIndex = props.ZIndex,

		BackgroundTransparency = 1,
		BorderSizePixel = 0,

		CanvasSize = props.contentSize:map(function(size)
			return UDim2.fromOffset(0, size.Y)
		end),
		ScrollingDirection = Enum.ScrollingDirection.Y,
		ElasticBehavior = Enum.ElasticBehavior.Never,
		ScrollBarThickness = SCROLLBAR_THICKNESS,
		ScrollBarImageColor3 = theme.SubText,
	}, props.children)
end

return ScrollingFrame
