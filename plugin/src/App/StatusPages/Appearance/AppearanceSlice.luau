local Constants = require(script.Parent.Parent.Parent.Parent.Data.Constants)
local Charm = require(script.Parent.Parent.Parent.Parent.Parent.Packages.Charm)
local PluginSettings = require(script.Parent.Parent.Parent.Parent.PluginSettings)
local GetRandomRGB = require(script.Parent.Parent.Parent.Parent.Utils.GetRandomRGB)
local RandomChoice = require(script.Parent.Parent.Parent.Parent.Utils.RandomChoice)

local atom = Charm.atom
type Atom<T> = Charm.Atom<T>

local selectedPartMaterial: Atom<string>
local selectedPartColor: Atom<Color3>
local selectedPartTransparency: Atom<number>

if PluginSettings:getSetting("randomizeAppearanceOnInit") then
	selectedPartMaterial = atom(RandomChoice(Constants.MATERIALS))
	selectedPartColor = atom(GetRandomRGB())
	selectedPartTransparency = atom(math.random())
else
	selectedPartMaterial = atom("Plastic")
	selectedPartColor = atom(Color3.fromRGB(163, 162, 165))
	selectedPartTransparency = atom(0)
end

local actions = {
	setSelectedPartMaterial = function(material: string)
		selectedPartMaterial(function(_oldMaterial: string)
			return material
		end)
	end,
	setSelectedPartColor = function(color: Color3)
		selectedPartColor(function(_oldColor: Color3)
			return color
		end)
	end,
	setSelectedPartTransparency = function(transparency: number)
		selectedPartTransparency(function(_oldTransparency: number)
			return transparency
		end)
	end,
}

return {
	actions = actions,
	state = {
		selectedPartMaterial = selectedPartMaterial,
		selectedPartColor = selectedPartColor,
		selectedPartTransparency = selectedPartTransparency,
	},
}
