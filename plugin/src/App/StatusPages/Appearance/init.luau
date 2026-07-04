local AppearanceSlice = require(script.AppearanceSlice)
local ColorWheel = require(script.Components.ColorWheel)
local Button = require(script.Parent.Parent.Components.PrimitiveComponents.Button)
local Dropdown = require(script.Parent.Parent.Components.PrimitiveComponents.Dropdown)
local TextLabel = require(script.Parent.Parent.Components.PrimitiveComponents.TextLabel)
local useSpring = require(script.Parent.Parent.Hooks.useSpring)
local Icons = require(script.Parent.Parent.Parent.Assets.Icons)
local Constants = require(script.Parent.Parent.Parent.Data.Constants)
local React = require(script.Parent.Parent.Parent.Parent.Packages.React)
local ReactCharm = require(script.Parent.Parent.Parent.Parent.Packages.ReactCharm)
local FormatHSV = require(script.Parent.Parent.Parent.Utils.FormatHSV)
local GetColorStringFromRGB = require(script.Parent.Parent.Parent.Utils.GetColorStringFromRGB)
local GetInvertedColor = require(script.Parent.Parent.Parent.Utils.GetInvertedColor)
local Theme = require(script.Parent.Parent.Theme)

local e = React.createElement

export type AppearanceProps = {
	transparency: number,
}

local function Appearance(_props: AppearanceProps)
	local theme = Theme.useTheme()
	local selectedPartMaterial = ReactCharm.useAtom(AppearanceSlice.state.selectedPartMaterial)
	local selectedPartColor = ReactCharm.useAtom(AppearanceSlice.state.selectedPartColor)
	local colorWheelOpen, setColorWheelOpen = React.useState(false)
	local viewportFrameRef = React.useRef(nil :: ViewportFrame?)
	local viewportCameraRef = React.useRef(nil :: Camera?)
	local viewportPartRef = React.useRef(nil :: BasePart?)

	local transparency, transparencySpring = useSpring(1)

	React.useEffect(function()

		local function buildViewport(material: string, color: Color3, transparency: number?)

			local t = 0
			
			local viewportPart = Instance.new("Part")

			viewportPart.Size = Vector3.one * 4
			viewportPart.Material = Enum.Material[material]
			viewportPart.Color = color
			viewportPart.Transparency = t

			local viewportCamera = Instance.new("Camera")

			viewportCamera.CFrame = CFrame.lookAt(viewportPart.Position + Vector3.new(0, 0, 5), viewportPart.Position)

			viewportPartRef.current = viewportPart
			viewportCameraRef.current = viewportCamera

			viewportCamera.Parent = viewportFrameRef.current
			viewportPart.Parent = viewportFrameRef.current

			viewportFrameRef.current.CurrentCamera = viewportCamera

		end
		
		local function updateViewport(material: string, color: Color3, transparency: number?)

			local t = 0

			local newMaterial = Enum.Material[material]
			local newColor = color

			if viewportPartRef.current.Material ~= newMaterial then
				viewportPartRef.current.Material = newMaterial
			end

			if viewportPartRef.current.Color ~= newColor then
				viewportPartRef.current.Color = newColor
			end

			viewportPartRef.current.Transparency = t

		end

		if viewportPartRef.current then
			updateViewport(selectedPartMaterial, selectedPartColor)
		else
			buildViewport(selectedPartMaterial, selectedPartColor)
		end

	end, {selectedPartMaterial, selectedPartColor})

	React.useEffect(function()
		return function()
			if viewportPartRef.current then
				viewportPartRef.current:Destroy()
				viewportPartRef.current = nil
			end
			if viewportCameraRef.current then
				viewportCameraRef.current:Destroy()
				viewportCameraRef.current = nil
			end
		end
	end, {})

	React.useEffect(function()
		transparencySpring:setGoal(colorWheelOpen and 0 or 1)
	end, { colorWheelOpen })

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
				BackgroundColor3 = Constants.PAGE_COLORS.APPEARANCE,
			}, {

				InsetFrame = e("Frame", {
					Size = UDim2.new(1, -5, 1, -5),
					Position = UDim2.fromScale(0.5, 0.5),
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
				}, {

					AppearanceLabel = e(TextLabel, {
						AnchorPoint = Vector2.new(0, 0.5),
						Position = UDim2.fromScale(0, 0.5),
						Size = UDim2.fromScale(1, 1),
						Text = "Appearance",
						TextSize = 24,
						Stroke = {
							Color = Color3.fromRGB(0, 0, 0),
							Thickness = 2,
							Transparency = 0,
						},
						Prefix = {
							Size = UDim2.fromScale(1, 1),
							Image = Icons.SidebarIcons.Appearance,
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
								Text = "Part Configuration",
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
							MaterialDropdown = e(Dropdown, {
								Position = UDim2.new(0.5, 0, 0, 40),
								AnchorPoint = Vector2.new(0.5, 0),
								Size = UDim2.new(1, -10, 0, 28),
								placeholderOption = "Material",
								dropdownOptions = Constants.MATERIALS,
								active = selectedPartMaterial,
								onSelect = AppearanceSlice.actions.setSelectedPartMaterial,
							}),

							ToggleColorPickerFrame = e("Frame", {
								Position = UDim2.new(0.5, 0, 0, 80),
								AnchorPoint = Vector2.new(0.5, 0),
								Size = UDim2.new(1, -10, 0, 28),
								BackgroundColor3 = theme.Background,
								BorderSizePixel = 0,
							}, {
								UIStroke = e("UIStroke", {
									Thickness = 1,
									Color = GetInvertedColor(theme.Background),
								}),
								UIGradient = e("UIGradient", {
									Rotation = 90,
									Color = ColorSequence.new({
										ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
										ColorSequenceKeypoint.new(1, Color3.fromRGB(187, 187, 187)),
									}),
								}),
								ColorButton = e(Button, {
									Size = UDim2.fromScale(1, 1),
									Position = UDim2.fromScale(0.5, 0.5),
									AnchorPoint = Vector2.new(0.5, 0.5),
									BackgroundTransparency = 1,
									BorderSizePixel = 0,
									hoverScale = 1,
									Activated = function()
										setColorWheelOpen(function(oldState: boolean)
											return not oldState
										end)
									end,
								}, {
									ColorLabelFrame = e("Frame", {
										AnchorPoint = Vector2.new(0, 0.5),
										Position = UDim2.fromScale(0, 0.5),
										Size = UDim2.new(1, -30, 1, 0),
										BackgroundTransparency = 1,
										BorderSizePixel = 0,
									}, {
										ColorLabel = e(TextLabel, {
											AnchorPoint = Vector2.new(0.5, 0.5),
											Position = UDim2.fromScale(0.5, 0.5),
											Size = UDim2.new(1, -5, 1, -5),
											Text = GetColorStringFromRGB(selectedPartColor, true),
											TextSize = 14,
											TextColor3 = theme.Foreground,
											TextXAlignment = Enum.TextXAlignment.Center,
										}),
									}),
									ColorPreviewFrame = e("Frame", {
										AnchorPoint = Vector2.new(1, 0.5),
										Position = UDim2.fromScale(1, 0.5),
										Size = UDim2.fromOffset(28, 28),
										BackgroundTransparency = 1,
										BorderSizePixel = 0,
									}, {
										ColorFrame = e("Frame", {
											AnchorPoint = Vector2.new(0.5, 0.5),
											Position = UDim2.fromScale(0.5, 0.5),
											Size = UDim2.new(1, -10, 1, -10),
											BackgroundColor3 = selectedPartColor,
											BorderSizePixel = 0,
										}, {
											UIStroke = e("UIStroke", {
												Thickness = 1,
												Color = Color3.fromRGB(255, 255, 255),
											}),
										}),
									}),
								}),
							}),

							ColorWheelFrame = e("CanvasGroup", {
								Size = UDim2.fromOffset(250, 150),
								Position = UDim2.new(0.5, 34, 0, 110),
								AnchorPoint = Vector2.new(0.5, 0.5),
								GroupTransparency = transparency,
								Visible = transparency:map(function(currentTransparency: number)
									return currentTransparency < 1
								end),
								BackgroundTransparency = 1,
							}, {
								BackgroundFrame = e("Frame", {
									Size = UDim2.new(1, -2, 1, -2),
									Position = UDim2.fromScale(0.5, 0.5),
									AnchorPoint = Vector2.new(0.5, 0.5),
									BackgroundColor3 = theme.Background,
									BorderSizePixel = 0,
								}, {
									UIStroke = e("UIStroke", {
										Thickness = 1,
										Color = Color3.fromRGB(0, 0, 0),
									}),
									TopFrame = e("Frame", {
										Size = UDim2.new(1, 0, 0, 20),
										Position = UDim2.fromScale(0.5, 0),
										AnchorPoint = Vector2.new(0.5, 0),
										BackgroundColor3 = theme.Background,
										BorderSizePixel = 0,
									}, {
										InsetFrame = e("Frame", {
											AnchorPoint = Vector2.new(0.5, 0.5),
											Position = UDim2.new(0.5, 5, 0.5, 0),
											Size = UDim2.new(1, -10, 1, 0),
											BackgroundTransparency = 1,
											BorderSizePixel = 0,
										}, {
											ExitFrame = e("Frame", {
												Size = UDim2.fromOffset(20, 20),
												Position = UDim2.fromScale(1, 0.5),
												AnchorPoint = Vector2.new(1, 0.5),
												BackgroundTransparency = 1,
												BorderSizePixel = 0,
											}, {
												ExitButton = e(Button, {
													Image = Icons.OtherIcons.Exit,
													Size = UDim2.fromScale(1, 1),
													Position = UDim2.fromScale(0.5, 0.5),
													AnchorPoint = Vector2.new(0.5, 0.5),
													hoverScale = 1,
													Activated = function()
														setColorWheelOpen(false)
													end,
												}),
											}),
											ColorWheelLabel = e(TextLabel, {
												AnchorPoint = Vector2.new(0, 0.5),
												Position = UDim2.fromScale(0, 0.5),
												Size = UDim2.fromScale(0.5, 1),
												Text = "Color Wheel",
												TextXAlignment = Enum.TextXAlignment.Left,
												TextSize = 14,
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
									}),
									BottomFrame = e("Frame", {
										Size = UDim2.new(1, 0, 1, -20),
										Position = UDim2.fromScale(0.5, 1),
										AnchorPoint = Vector2.new(0.5, 1),
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
											LeftFrame = e("Frame", {
												Position = UDim2.fromScale(0, 0.5),
												AnchorPoint = Vector2.new(0, 0.5),
												Size = UDim2.fromOffset(118, 118),
												BackgroundTransparency = 1,
												BorderSizePixel = 0,
											}, {
												ColorWheelBorder = e("Frame", {
													Size = UDim2.fromOffset(118, 118),
													AnchorPoint = Vector2.new(0.5, 0.5),
													Position = UDim2.fromScale(0.5, 0.5),
													BackgroundTransparency = 1,
													BorderSizePixel = 0,
													ZIndex = -1
												}, {
													UICorner = e("UICorner", {
														CornerRadius = UDim.new(1, 0),
													}),
													UIStroke = e("UIStroke", {
														Color = GetInvertedColor(theme.Background),
														Thickness = 2,
													}),
												}),
												ColorWheel = e(ColorWheel, {
													Size = 118,
													ResolutionMultiplier = 4,
													selectedColor = selectedPartColor,
													onColorChanged = AppearanceSlice.actions.setSelectedPartColor,
													Active = colorWheelOpen,
												}),
											}),
											RightFrame = e("Frame", {
												Position = UDim2.fromScale(1, 0.5),
												AnchorPoint = Vector2.new(1, 0.5),
												Size = UDim2.new(1, -118, 0, 118),
												BackgroundTransparency = 1,
												BorderSizePixel = 0,
											}, {
												UIListLayout = e("UIListLayout", {
													FillDirection = Enum.FillDirection.Vertical,
													SortOrder = Enum.SortOrder.LayoutOrder,
												}),

												RGBLabel = e(TextLabel, {
													LayoutOrder = 1,
													Size = UDim2.new(1, 0, 0, 39),
													TextSize = 16,
													Text = GetColorStringFromRGB(selectedPartColor, true),
													TextXAlignment = Enum.TextXAlignment.Center,
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

												HexLabel = e(TextLabel, {
													LayoutOrder = 2,
													Size = UDim2.new(1, 0, 0, 39),
													TextSize = 16,
													Text = `#{string.upper(selectedPartColor:ToHex())}`,
													TextXAlignment = Enum.TextXAlignment.Center,
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

												HSVLabel = e(TextLabel, {
													LayoutOrder = 3,
													Size = UDim2.new(1, 0, 0, 39),
													TextSize = 16,
													Text = FormatHSV(selectedPartColor:ToHSV()),
													TextXAlignment = Enum.TextXAlignment.Center,
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
										}),
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
							BackgroundColor3 = Constants.PAGE_COLORS.APPEARANCE,
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
								Text = "Part Preview",
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
							SquareFrame = e("Frame", {
								Position = UDim2.fromScale(0.5, 0.5),
								AnchorPoint = Vector2.new(0.5, 0.5),
								Size = UDim2.fromOffset(125, 125),
								BackgroundTransparency = 1,
								BorderSizePixel = 0,
							}, {
								ViewportFrame = e("ViewportFrame", {			
									Size = UDim2.fromScale(1, 1),
									Position = UDim2.fromScale(0.5, 0.5),
									AnchorPoint = Vector2.new(0.5, 0.5),
									BackgroundTransparency = 1,
									BorderSizePixel = 0,
									ref = viewportFrameRef,
								}),
								UIStroke = e("UIStroke", {
									Color = GetInvertedColor(theme.Background),
									Thickness = 2,
								})
							})
						})
					}),
				}),
			}),
		}),
	})
end

return Appearance
