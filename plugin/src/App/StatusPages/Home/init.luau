local TextLabel = require(script.Parent.Parent.Components.PrimitiveComponents.TextLabel)
local Icons = require(script.Parent.Parent.Parent.Assets.Icons)
local Constants = require(script.Parent.Parent.Parent.Data.Constants)
local React = require(script.Parent.Parent.Parent.Parent.Packages.React)
local Theme = require(script.Parent.Parent.Theme)
local Announcement = require(script.Announcement)
local HomeSlice = require(script.HomeSlice)
local Button = require(script.Parent.Parent.Components.PrimitiveComponents.Button)
local ReactCharm = require(script.Parent.Parent.Parent.Parent.Packages.ReactCharm)
local GetInvertedColor = require(script.Parent.Parent.Parent.Utils.GetInvertedColor)
local PresetsData = require(script.PresetsData)

local e = React.createElement

export type HomeProps = {
	transparency: number,
}

export type PresetsProps = {
	theme: Theme.Theme,
	currentPreset: string,
	onSelect: (PresetsData.Preset) -> (),
}

local function Presets(props: PresetsProps)
	local presets = {}

	for _: number, PRESET_DATA: PresetsData.Preset in PresetsData do
		local preset = e(Button, {
			Size = UDim2.fromOffset(150, 35),
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 0,
			hoverScale = 1.05,
			Activated = function()
				props.onSelect(PRESET_DATA)
			end,
		}, {
			Frame = e("Frame", {
				Size = UDim2.fromScale(1, 1),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				BackgroundColor3 = props.currentPreset == PRESET_DATA.PresetName and Color3.fromRGB(59, 130, 246)
					or Color3.fromRGB(112, 112, 112),
				BorderSizePixel = 0,
			}, {

				PresetLabel = e(TextLabel, {
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
					Size = UDim2.fromScale(1, 1),
					Text = PRESET_DATA.PresetName,
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

				UIStroke = e("UIStroke", {
					Color = GetInvertedColor(props.theme.Background),
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

		table.insert(presets, preset)
	end

	return presets
end

local function Home(props: HomeProps)
	local theme = Theme.useTheme()

	local selectedMazePreset = ReactCharm.useAtom(HomeSlice.state.selectedMazePreset)

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
				BackgroundColor3 = Constants.PAGE_COLORS.HOME,
			}, {

				InsetFrame = e("Frame", {
					Size = UDim2.new(1, -5, 1, -5),
					Position = UDim2.fromScale(0.5, 0.5),
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
				}, {

					HomeLabel = e(TextLabel, {
						AnchorPoint = Vector2.new(0, 0.5),
						Position = UDim2.fromScale(0, 0.5),
						Size = UDim2.fromScale(1, 1),
						Text = "Home",
						TextSize = 24,
						Stroke = {
							Color = Color3.fromRGB(0, 0, 0),
							Thickness = 2,
							Transparency = 0,
						},
						Prefix = {
							Size = UDim2.fromScale(1, 1),
							Image = Icons.SidebarIcons.Home,
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
						TopFrame = e("Frame", {
							Position = UDim2.fromScale(0.5, 0),
							AnchorPoint = Vector2.new(0.5, 0),
							Size = UDim2.new(1, 0, 0, 30),
							BackgroundColor3 = theme.Brand,
							BorderSizePixel = 0,
						}, {
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
							PartLabel = e(TextLabel, {
								AnchorPoint = Vector2.new(0.5, 0.5),
								Position = UDim2.fromScale(0.5, 0.5),
								Size = UDim2.fromScale(1, 1),
								Text = "📢 Announcements 📢",
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
						BottomFrame = e("Frame", {
							Position = UDim2.fromScale(0.5, 1),
							AnchorPoint = Vector2.new(0.5, 1),
							Size = UDim2.new(1, 0, 1, -30),
							BackgroundTransparency = 1,
							BorderSizePixel = 0,
						}, {
							AnnouncementLabel = e(TextLabel, {
								AnchorPoint = Vector2.new(0.5, 0.5),
								Position = UDim2.fromScale(0.5, 0.5),
								Size = UDim2.new(1, -12, 1, -12),
								Text = Announcement,
								TextSize = 12,
								TextColor3 = Color3.fromRGB(130, 130, 130),
								TextTransparency = 0.55,
								Font = Enum.Font.BuilderSans,
								TextWrapped = true,
								TextXAlignment = Enum.TextXAlignment.Left,
								TextYAlignment = Enum.TextYAlignment.Top,
							}),
						}),
					}),
					RightFrame = e("Frame", {
						AnchorPoint = Vector2.new(1, 0.5),
						Position = UDim2.fromScale(1, 0.5),
						Size = UDim2.fromScale(0.485, 1),
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
					}, {
						TopFrame = e("Frame", {
							Position = UDim2.fromScale(0.5, 0),
							AnchorPoint = Vector2.new(0.5, 0),
							Size = UDim2.new(1, 0, 0, 30),
							BackgroundColor3 = theme.Brand,
							BorderSizePixel = 0,
						}, {
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
							PresetsLabel = e(TextLabel, {
								AnchorPoint = Vector2.new(0.5, 0.5),
								Position = UDim2.fromScale(0.5, 0.5),
								Size = UDim2.fromScale(1, 1),
								Text = "Presets",
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
						BottomFrame = e("Frame", {
							Position = UDim2.fromScale(0.5, 1),
							AnchorPoint = Vector2.new(0.5, 1),
							Size = UDim2.new(1, 0, 1, -30),
							BackgroundTransparency = 1,
							BorderSizePixel = 0,
						}, {
							InsetFrame = e("Frame", {
								Size = UDim2.new(1, -10, 1, -10),
								Position = UDim2.fromScale(0.5, 0.5),
								AnchorPoint = Vector2.new(0.5, 0.5),
								BackgroundTransparency = 1,
								BorderSizePixel = 0,
							}, {
								PresetsList = e("UIListLayout", {
									Padding = UDim.new(0, 8),
									FillDirection = Enum.FillDirection.Vertical,
									HorizontalAlignment = Enum.HorizontalAlignment.Center,
									VerticalAlignment = Enum.VerticalAlignment.Top,
								}),

								Presets = e(Presets, {
									theme = theme,
									currentPreset = selectedMazePreset,
									onSelect = HomeSlice.actions.applyPreset,
								}),
							}),
						}),
					}),
				}),
			}),
		}),
	})
end

return Home
