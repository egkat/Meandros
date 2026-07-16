local PresetsData = {}

export type Preset = {
	PresetName: string,
	PresetColor: Color3,
	MazeWidth: number,
	MazeLength: number,
	MazeHeight: number,
	MazeFloorThickness: number,
	MazeWallThickness: number,
	MazeAlgorithm: string,
	MazeSeed: number,
	MazeEntranceExitCount: number,
}

PresetsData.Presets = {
	[1] = {
		PresetName = "Default",
		PresetColor = Color3.fromRGB(112, 112, 112),
		MazeWidth = 25,
		MazeLength = 25,
		MazeHeight = 10,
		MazeFloorThickness = 1,
		MazeWallThickness = 1,
		MazeAlgorithm = "RandomizedDepthFirstSearch",
		MazeSeed = 0,
		MazeEntranceExitCount = 2,
	},
	[2] = {
		-- Test Preset
		PresetName = "Labyrinth",
		PresetColor = Color3.fromRGB(59, 130, 246),
		MazeWidth = 50,
		MazeLength = 40,
		MazeHeight = 20,
		MazeFloorThickness = 2,
		MazeWallThickness = 3,
		MazeAlgorithm = "RandomizedPrims",
		MazeSeed = 123454321,
		MazeEntranceExitCount = 4,
	},
} :: { [number]: Preset }

return PresetsData.Presets
