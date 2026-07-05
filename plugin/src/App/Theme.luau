local React = require(script.Parent.Parent.Parent.Packages.React)
local GetStudioSetting = require(script.Parent.Parent.Utils.GetStudioSetting)

local e = React.createElement

export type Theme = {
	Background: Color3,
	Foreground: Color3,
	Border: Color3,
	SubText: Color3,
	Brand: Color3,
	GetColor: (
		self: Theme,
		styleGuideColor: Enum.StudioStyleGuideColor,
		modifier: Enum.StudioStyleGuideModifier?
	) -> Color3,
}

local ThemeContext = React.createContext(nil :: Theme?)

local function buildTheme(): Theme
	local studioTheme: StudioTheme = GetStudioSetting("Theme")

	local function get(styleGuideColor: Enum.StudioStyleGuideColor, modifier: Enum.StudioStyleGuideModifier?): Color3
		return studioTheme:GetColor(styleGuideColor, modifier)
	end

	return {
		Background = get(Enum.StudioStyleGuideColor.MainBackground),
		Foreground = get(Enum.StudioStyleGuideColor.MainText),
		Border = get(Enum.StudioStyleGuideColor.Border),
		SubText = get(Enum.StudioStyleGuideColor.SubText),
		Brand = Color3.fromHex("4F8EF7"),
		GetColor = function(_self: Theme, styleGuideColor, modifier)
			return studioTheme:GetColor(styleGuideColor, modifier)
		end,
	}
end

local function ThemeProvider(props)
	local theme, setTheme = React.useState(buildTheme)

	React.useEffect(function()
		local conn = GetStudioSetting("ThemeChanged"):Connect(function()
			setTheme(buildTheme())
		end)

		return function()
			conn:Disconnect()
		end
	end, {})

	return e(ThemeContext.Provider, { value = theme }, props.children)
end

local function useTheme(): Theme
	local contextTheme = React.useContext(ThemeContext)
	local fallbackTheme, setFallbackTheme = React.useState(buildTheme)

	React.useEffect(function()
		if contextTheme then
			return
		end
		local conn = GetStudioSetting("ThemeChanged"):Connect(function()
			setFallbackTheme(buildTheme())
		end)
		return function()
			conn:Disconnect()
		end
	end, { contextTheme })

	return contextTheme or fallbackTheme
end

return {
	Provider = ThemeProvider,
	useTheme = useTheme,
}
