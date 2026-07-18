local PresetsData = {}

export type Preset = {
	PresetName: string,
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
		MazeWidth = 25,
		MazeLength = 25,
		MazeHeight = 10,
		MazeFloorThickness = 1,
		MazeWallThickness = 1,
		MazeAlgorithm = "RandomizedDepthFirstSearch",
		MazeSeed = 41245,
		MazeEntranceExitCount = 2,
	},
	[2] = {
		PresetName = "Labyrinth",
		MazeWidth = 100,
		MazeLength = 100,
		MazeHeight = 20,
		MazeFloorThickness = 2,
		MazeWallThickness = 3,
		MazeAlgorithm = "RandomizedPrims",
		MazeSeed = 123454321,
		MazeEntranceExitCount = 4,
	},
} :: { [number]: Preset }

return PresetsData.Presets
