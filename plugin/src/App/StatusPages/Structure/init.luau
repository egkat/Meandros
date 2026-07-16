local AlgorithmSetting = require(script.Components.AlgorithmSetting)
local NumberSetting = require(script.Components.NumberSetting)
local TextSetting = require(script.Components.TextSetting)
local ParseBuildPosition = require(script.Parent.Parent.Parent.Utils.ParseBuildPosition)
local StructureSlice = require(script.StructureSlice)
local ScrollingFrame = require(script.Parent.Parent.Components.PrimitiveComponents.ScrollingFrame)
local TextLabel = require(script.Parent.Parent.Components.PrimitiveComponents.TextLabel)
local Icons = require(script.Parent.Parent.Parent.Assets.Icons)
local Constants = require(script.Parent.Parent.Parent.Data.Constants)
local React = require(script.Parent.Parent.Parent.Parent.Packages.React)
local ReactCharm = require(script.Parent.Parent.Parent.Parent.Packages.ReactCharm)
local Theme = require(script.Parent.Parent.Theme)

local e = React.createElement

local function validateBuildPosition(text: string): string?
	local parsed = ParseBuildPosition(text)

	if parsed == nil then
		return nil
	end

	if parsed == "Camera" then
		return "Camera"
	end

	return `({parsed.X}, {parsed.Y}, {parsed.Z})`
end

export type StructureProps = {
	transparency: number,
}

local function Structure(_props: StructureProps)
	local contentSize, setContentSize = React.useBinding(Vector2.zero)

	local theme = Theme.useTheme()
	local selectedMazeWidth = ReactCharm.useAtom(StructureSlice.state.selectedMazeWidth)
	local selectedMazeLength = ReactCharm.useAtom(StructureSlice.state.selectedMazeLength)
	local selectedMazeHeight = ReactCharm.useAtom(StructureSlice.state.selectedMazeHeight)
	local selectedMazeFloorThickness = ReactCharm.useAtom(StructureSlice.state.selectedMazeFloorThickness)
	local selectedMazeWallThickness = ReactCharm.useAtom(StructureSlice.state.selectedMazeWallThickness)
	local selectedMazeAlgorithm = ReactCharm.useAtom(StructureSlice.state.selectedMazeAlgorithm)
	local selectedMazeSeed = ReactCharm.useAtom(StructureSlice.state.selectedMazeSeed)
	local selectedMazeEntranceExitCount = ReactCharm.useAtom(StructureSlice.state.selectedMazeEntranceExitCount)
	local selectedMazeBuildPosition = ReactCharm.useAtom(StructureSlice.state.selectedMazeBuildPosition)

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

				ContainerFrame = e(ScrollingFrame, {
					Size = UDim2.fromScale(1, 1),
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
					contentSize = contentSize,
				}, {
					MazeAlgorithm = e(AlgorithmSetting, {
						name = "Maze Algorithm",
						description = "The algorithm used to carve future mazes.",
						active = selectedMazeAlgorithm,
						options = Constants.MAZE_ALGORITHMS,
						layoutOrder = 1,
						ZIndex = 2,
						onSelect = StructureSlice.actions.setSelectedMazeAlgorithm,
					}),

					MazeWidth = e(NumberSetting, {
						name = "Maze Width",
						description = "How many cells wide the maze is.",
						value = selectedMazeWidth,
						minValue = 1,
						maxValue = 512,
						integer = true,
						layoutOrder = 2,
						setValue = StructureSlice.actions.setSelectedMazeWidth,
					}),

					MazeLength = e(NumberSetting, {
						name = "Maze Length",
						description = "How many cells long the maze is.",
						value = selectedMazeLength,
						minValue = 1,
						maxValue = 512,
						integer = true,
						layoutOrder = 3,
						setValue = StructureSlice.actions.setSelectedMazeLength,
					}),

					MazeHeight = e(NumberSetting, {
						name = "Maze Height",
						description = "The height of the maze walls in studs.",
						value = selectedMazeHeight,
						minValue = 0.05,
						maxValue = 64,
						layoutOrder = 4,
						setValue = StructureSlice.actions.setSelectedMazeHeight,
					}),

					FloorThickness = e(NumberSetting, {
						name = "Floor Thickness",
						description = "The thickness of the maze floor in studs.",
						value = selectedMazeFloorThickness,
						minValue = 0.05,
						maxValue = 64,
						layoutOrder = 5,
						setValue = StructureSlice.actions.setSelectedMazeFloorThickness,
					}),

					WallThickness = e(NumberSetting, {
						name = "Wall Thickness",
						description = "The thickness of the maze walls in studs.",
						value = selectedMazeWallThickness,
						minValue = 0.05,
						layoutOrder = 6,
						setValue = StructureSlice.actions.setSelectedMazeWallThickness,
					}),

					Seed = e(NumberSetting, {
						name = "Seed",
						description = "The seed used to generate the maze.",
						value = selectedMazeSeed,
						minValue = 0,
						integer = true,
						layoutOrder = 7,
						setValue = StructureSlice.actions.setSelectedMazeSeed,
					}),

					EntranceExits = e(NumberSetting, {
						name = "Entrances & Exits",
						description = "How many openings are carved into the maze border.",
						value = selectedMazeEntranceExitCount,
						minValue = 0,
						maxValue = 16,
						integer = true,
						layoutOrder = 8,
						setValue = StructureSlice.actions.setSelectedMazeEntranceExitCount,
					}),

					BuildPosition = e(TextSetting, {
						name = "Build Position",
						description = "Where the maze is placed: a position like (100, 100, 100), or Camera to place it where your camera is looking.",
						value = selectedMazeBuildPosition,
						validate = validateBuildPosition,
						layoutOrder = 9,
						setValue = StructureSlice.actions.setSelectedMazeBuildPosition,
					}),

					Layout = e("UIListLayout", {
						FillDirection = Enum.FillDirection.Vertical,
						SortOrder = Enum.SortOrder.LayoutOrder,

						[React.Change.AbsoluteContentSize] = function(object)
							setContentSize(object.AbsoluteContentSize)
						end,
					}),

					Padding = e("UIPadding", {
						PaddingLeft = UDim.new(0, 20),
						PaddingRight = UDim.new(0, 20),
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
