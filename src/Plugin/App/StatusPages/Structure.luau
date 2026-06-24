local React = require(script.Parent.Parent.Parent.Parent.Packages.React)

local e = React.createElement

local function Structure()
	return e("TextLabel", {
        Size = UDim2.fromOffset(200, 100),
        Text = "Test"
    })
end

return Structure

