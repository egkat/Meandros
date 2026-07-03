local React = require(script.Parent.Parent.Parent.Parent.Parent.Packages.React)

local e = React.createElement

export type InsetFrameProps = {
	topInset: UDim?,
	bottomInset: UDim?,
	leftInset: UDim?,
	rightInset: UDim?,
	positionOverride: UDim2?,
	anchorPointOverride: Vector2?,
	children: { React.ReactChild },
}

local ZERO_INSET = UDim.new(0, 0)

local function InsetFrame(props: InsetFrameProps)
	local topInset = props.topInset or ZERO_INSET
	local bottomInset = props.bottomInset or ZERO_INSET
	local leftInset = props.leftInset or ZERO_INSET
	local rightInset = props.rightInset or ZERO_INSET

	return e("Frame", {
		Position = props.positionOverride and props.positionOverride or UDim2.fromScale(0.5, 0.5),
		AnchorPoint = props.anchorPointOverride and props.anchorPointOverride or Vector2.new(0.5, 0.5),
		Size = UDim2.new(
			1 - leftInset.Scale - rightInset.Scale,
			-leftInset.Offset + -rightInset.Offset,
			1 - topInset.Scale - bottomInset.Scale,
			-topInset.Offset + -bottomInset.Offset
		),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
	}, props.children)

end

return InsetFrame
