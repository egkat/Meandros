local ActionButton = require(script.Components.ActionButton)
local AppearanceSlice = require(script.Parent.Appearance.AppearanceSlice)
local StructureSlice = require(script.Parent.Structure.StructureSlice)
local TextLabel = require(script.Parent.Parent.Components.PrimitiveComponents.TextLabel)
local Icons = require(script.Parent.Parent.Parent.Assets.Icons)
local Constants = require(script.Parent.Parent.Parent.Data.Constants)
local MazeService = require(script.Parent.Parent.Parent.Services.MazeService)
local React = require(script.Parent.Parent.Parent.Parent.Packages.React)
local Theme = require(script.Parent.Parent.Theme)

local e = React.createElement

local REVERT_COLOR = Color3.fromRGB(239, 68, 68)

local ACTION_BUTTON_SIZE = UDim2.fromOffset(95, 95)

export type BuildProps = {
	transparency: number,
}

local function getMazeSettings(): MazeService.MazeSettings
	return {
		algorithm = StructureSlice.state.selectedMazeAlgorithm(),
		seed = StructureSlice.state.selectedMazeSeed(),
		width = StructureSlice.state.selectedMazeWidth(),
		length = StructureSlice.state.selectedMazeLength(),
		entranceExitCount = StructureSlice.state.selectedMazeEntranceExitCount(),
		wallHeight = StructureSlice.state.selectedMazeHeight(),
		wallThickness = StructureSlice.state.selectedMazeWallThickness(),
		floorThickness = StructureSlice.state.selectedMazeFloorThickness(),
		material = AppearanceSlice.state.selectedPartMaterial(),
		color = AppearanceSlice.state.selectedPartColor(),
		transparency = AppearanceSlice.state.selectedPartTransparency(),
		buildPosition = StructureSlice.state.selectedMazeBuildPosition(),
	}
end

local function Build(_props: BuildProps)
	local theme = Theme.useTheme()

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
				BackgroundColor3 = Constants.PAGE_COLORS.BUILD,
			}, {

				InsetFrame = e("Frame", {
					Size = UDim2.new(1, -5, 1, -5),
					Position = UDim2.fromScale(0.5, 0.5),
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
				}, {

					BuildLabel = e(TextLabel, {
						AnchorPoint = Vector2.new(0, 0.5),
						Position = UDim2.fromScale(0, 0.5),
						Size = UDim2.fromScale(1, 1),
						Text = "Build",
						TextSize = 24,
						Stroke = {
							Color = Color3.fromRGB(0, 0, 0),
							Thickness = 2,
							Transparency = 0,
						},
						Prefix = {
							Size = UDim2.fromScale(1, 1),
							Image = Icons.SidebarIcons.Build,
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

				Container = e("Frame", {
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
					Size = UDim2.fromScale(1, 1),
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
				}, {
					UIListLayout = e("UIListLayout", {
						FillDirection = Enum.FillDirection.Horizontal,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						SortOrder = Enum.SortOrder.LayoutOrder,
						Padding = UDim.new(0, 15),
					}),

					PreviewButton = e(ActionButton, {
						text = "Preview",
						icon = Icons.BuildPageIcons.PreviewMaze,
						color = Constants.PAGE_COLORS.APPEARANCE,
						size = ACTION_BUTTON_SIZE,
						layoutOrder = 1,
						onActivated = function()
							MazeService.preview(getMazeSettings())
						end,
					}),

					RevertButton = e(ActionButton, {
						text = "Revert Preview",
						icon = Icons.BuildPageIcons.RevertPreviewMaze,
						color = REVERT_COLOR,
						size = ACTION_BUTTON_SIZE,
						layoutOrder = 2,
						onActivated = MazeService.revertPreview,
					}),

					BuildButton = e(ActionButton, {
						text = "Build",
						icon = Icons.BuildPageIcons.BuildMaze,
						color = Constants.PAGE_COLORS.BUILD,
						size = ACTION_BUTTON_SIZE,
						layoutOrder = 3,
						onActivated = function()
							MazeService.build(getMazeSettings())
						end,
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

return Build
