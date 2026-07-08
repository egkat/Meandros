local StructureSlice = require(script.StructureSlice)
local TextLabel = require(script.Parent.Parent.Components.PrimitiveComponents.TextLabel)
local Icons = require(script.Parent.Parent.Parent.Assets.Icons)
local Constants = require(script.Parent.Parent.Parent.Data.Constants)
local React = require(script.Parent.Parent.Parent.Parent.Packages.React)
local ReactCharm = require(script.Parent.Parent.Parent.Parent.Packages.ReactCharm)
local GetInvertedColor = require(script.Parent.Parent.Parent.Utils.GetInvertedColor)
local Theme = require(script.Parent.Parent.Theme)

local e = React.createElement

export type StructureProps = {
	transparency: number,
}

export type StructureInputBoxProps = {
	label: string,
	layoutOrder: number?,
	value: number,
	setValue: (value: number) -> (),
}

local function StructureInputBox(props: StructureInputBoxProps)
	local theme = Theme.useTheme()

	return e("Frame", {
		Size = UDim2.fromOffset(150, 35),
		LayoutOrder = props.layoutOrder,
		BorderSizePixel = 0,
		BackgroundColor3 = theme.Background,
	}, {
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
		NameFrame = e("Frame", {
			Size = UDim2.fromOffset(150 - 35, 35),
			Position = UDim2.fromScale(0, 0.5),
			AnchorPoint = Vector2.new(0, 0.5),
			BackgroundTransparency = 1,
		}, {
			NameLabel = e(TextLabel, {
				Size = UDim2.new(1, -10, 1, 0),
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Text = props.label,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextSize = 16,
				Stroke = {
					Color = Color3.fromRGB(0, 0, 0),
					Thickness = 2,
					Transparency = 0,
				},
				Gradient = {
					Rotation = 90,
					Color = ColorSequence.new({
						ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
						ColorSequenceKeypoint.new(1, Color3.fromRGB(208, 208, 208)),
					}),
				},
			}),
		}),
		InputBoxFrame = e("Frame", {
			Size = UDim2.fromOffset(35, 35),
			Position = UDim2.fromScale(1, 0.5),
			AnchorPoint = Vector2.new(1, 0.5),
			BackgroundTransparency = 1,
		}, {
			UIStroke = e("UIStroke", {
				Color = GetInvertedColor(theme.Background),
				Thickness = 1,
			}),
			InputBox = e("TextBox", {
				Size = UDim2.fromScale(1, 1),
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				Font = Enum.Font.BuilderSansExtraBold,
				Text = tostring(props.value),
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextSize = 18,
				ClearTextOnFocus = false,
				[React.Event.FocusLost] = function(rbx: TextBox, _enterPressed: boolean, _inputObject: InputObject?)
					local number = tonumber(rbx.Text)

					if number ~= nil then
						props.setValue(number)
						rbx.Text = tostring(number)
					else
						rbx.Text = tostring(props.value)
					end
				end,
			}, {
				UIStroke = e("UIStroke", {
					Color = Color3.fromRGB(0, 0, 0)
				}),
			}),
		}),
	})
end

local function Structure(_props: StructureProps)
	local theme = Theme.useTheme()
	local selectedMazeWidth = ReactCharm.useAtom(StructureSlice.state.selectedMazeWidth)
	local selectedMazeLength = ReactCharm.useAtom(StructureSlice.state.selectedMazeLength)

	return e(React.Fragment, nil, {

		InnerFrame = e("Frame", {
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.new(1, -10, 1, -26),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
		}, {
			TopFrame = e("Frame", {
				AnchorPoint = Vector2.new(0.5, 0),
				Position = UDim2.fromScale(0.5, 0),
				Size = UDim2.new(1, 0, 0, 35),
				BorderSizePixel = 0,
				BackgroundColor3 = Constants.PAGE_COLORS.STRUCTURE,
			}, {

				InsetFrame = e("Frame", {
					Size = UDim2.new(1, -5, 1, -5),
					Position = UDim2.fromScale(0.5, 0.5),
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
				}, {

					StructureLabel = e(TextLabel, {
						AnchorPoint = Vector2.new(0, 0.5),
						Position = UDim2.fromScale(0, 0.5),
						Size = UDim2.fromScale(1, 1),
						Text = "Structure",
						TextSize = 24,
						Stroke = {
							Color = Color3.fromRGB(0, 0, 0),
							Thickness = 2,
							Transparency = 0,
						},
						Prefix = {
							Size = UDim2.fromScale(1, 1),
							Image = Icons.SidebarIcons.Structure,
							HorizontalAlignment = Enum.HorizontalAlignment.Left,
						},
						Gradient = {
							Rotation = 90,
							Color = ColorSequence.new({
								ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
								ColorSequenceKeypoint.new(1, Color3.fromRGB(208, 208, 208)),
							}),
						},
					}),
				}),

				UIStroke = e("UIStroke", {
					Color = Color3.fromRGB(0, 0, 0),
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

			BottomFrame = e("Frame", {
				AnchorPoint = Vector2.new(0.5, 1),
				Position = UDim2.fromScale(0.5, 1),
				Size = UDim2.new(1, 0, 1, -35),
				BorderSizePixel = 0,
				BackgroundColor3 = theme.Background,
			}, {
				InsetFrame = e("Frame", {
					Size = UDim2.new(1, -10, 1, -10),
					Position = UDim2.fromScale(0.5, 0.5),
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
				}, {
					LeftFrame = e("Frame", {
						AnchorPoint = Vector2.new(0, 0.5),
						Position = UDim2.fromScale(0, 0.5),
						Size = UDim2.fromScale(0.485, 1),
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
					}, {
						UIListLayout = e("UIListLayout", {
							FillDirection = Enum.FillDirection.Vertical,
							SortOrder = Enum.SortOrder.LayoutOrder,
							HorizontalAlignment = Enum.HorizontalAlignment.Center,
							VerticalAlignment = Enum.VerticalAlignment.Center,
							Padding = UDim.new(0, 5),
						}),
						MazeWidthBox = e(StructureInputBox, {
							label = "Maze Width",
							layoutOrder = 1,
							value = selectedMazeWidth,
							setValue = StructureSlice.actions.setSelectedMazeWidth,
						}),
						MazeLengthBox = e(StructureInputBox, {
							label = "Maze Length",
							layoutOrder = 2,
							value = selectedMazeLength,
							setValue = StructureSlice.actions.setSelectedMazeLength,
						}),
					}),
					RightFrame = e("Frame", {
						AnchorPoint = Vector2.new(1, 0.5),
						Position = UDim2.fromScale(1, 0.5),
						Size = UDim2.fromScale(0.485, 1),
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
					}),
				}),
				UIStroke = e("UIStroke", {
					Color = Color3.fromRGB(0, 0, 0),
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
		}),
	})
end

return Structure
