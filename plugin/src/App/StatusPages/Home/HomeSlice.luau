local Charm = require(script.Parent.Parent.Parent.Parent.Parent.Packages.Charm)
local StructureSlice = require(script.Parent.Parent.Structure.StructureSlice)
local PresetsData = require(script.Parent.PresetsData)

local atom = Charm.atom
type Atom<T> = Charm.Atom<T>

local selectedMazePreset: Atom<string> = atom("None")

local actions = {
	setSelectedMazePreset = function(preset: string)
		selectedMazePreset(function(_oldPreset: string)
			return preset
		end)
	end,
	applyPreset = function(preset: PresetsData.Preset)
		Charm.batch(function()

			StructureSlice.actions.setSelectedMazeWidth(preset.MazeWidth)
			StructureSlice.actions.setSelectedMazeLength(preset.MazeLength)
			StructureSlice.actions.setSelectedMazeHeight(preset.MazeHeight)
			StructureSlice.actions.setSelectedMazeFloorThickness(preset.MazeFloorThickness)
			StructureSlice.actions.setSelectedMazeWallThickness(preset.MazeWallThickness)
			StructureSlice.actions.setSelectedMazeAlgorithm(preset.MazeAlgorithm)
			StructureSlice.actions.setSelectedMazeSeed(preset.MazeSeed)
			StructureSlice.actions.setSelectedMazeEntranceExitCount(preset.MazeEntranceExitCount)
            
			selectedMazePreset(function(_oldPreset: string)
				return preset.PresetName
			end)
		end)
	end,
}

local function findPreset(presetName: string): PresetsData.Preset?
	for _: number, preset: PresetsData.Preset in PresetsData do
		if preset.PresetName == presetName then
			return preset
		end
	end

	return nil
end

local function structureMatchesSelectedPreset(): boolean
	local preset = findPreset(selectedMazePreset())
	if preset == nil then
		return true
	end

	return StructureSlice.state.selectedMazeWidth() == preset.MazeWidth
		and StructureSlice.state.selectedMazeLength() == preset.MazeLength
		and StructureSlice.state.selectedMazeHeight() == preset.MazeHeight
		and StructureSlice.state.selectedMazeFloorThickness() == preset.MazeFloorThickness
		and StructureSlice.state.selectedMazeWallThickness() == preset.MazeWallThickness
		and StructureSlice.state.selectedMazeAlgorithm() == preset.MazeAlgorithm
		and StructureSlice.state.selectedMazeSeed() == preset.MazeSeed
		and StructureSlice.state.selectedMazeEntranceExitCount() == preset.MazeEntranceExitCount
end

-- A structure value edited away from the selected preset deselects it.
Charm.subscribe(structureMatchesSelectedPreset, function(matches: boolean)
	if not matches then
		actions.setSelectedMazePreset("None")
	end
end)

return {
	actions = actions,
	state = {
		selectedMazePreset = selectedMazePreset,
	},
}
