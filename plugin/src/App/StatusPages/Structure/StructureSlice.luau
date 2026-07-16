local Charm = require(script.Parent.Parent.Parent.Parent.Parent.Packages.Charm)

local atom = Charm.atom
type Atom<T> = Charm.Atom<T>

local selectedMazeWidth: Atom<number> = atom(25)
local selectedMazeLength: Atom<number> = atom(25)
local selectedMazeHeight: Atom<number> = atom(10)
local selectedMazeFloorThickness: Atom<number> = atom(1)
local selectedMazeWallThickness: Atom<number> = atom(1)
local selectedMazeAlgorithm: Atom<string> = atom("RandomizedDepthFirstSearch")
local selectedMazeSeed: Atom<number | string> = atom(0 :: number | string)
local selectedMazeEntranceExitCount: Atom<number> = atom(2)
local selectedMazeBuildPosition: Atom<string> = atom("Camera")

local actions = {
	setSelectedMazeWidth = function(width: number)
		selectedMazeWidth(function(_oldWidth: number)
			return width
		end)
	end,
	setSelectedMazeLength = function(length: number)
		selectedMazeLength(function(_oldLength: number)
			return length
		end)
	end,
	setSelectedMazeHeight = function(height: number)
		selectedMazeHeight(function(_oldHeight: number)
			return height
		end)
	end,
	setSelectedMazeFloorThickness = function(floorThickness: number)
		selectedMazeFloorThickness(function(_oldFloorThickness: number)
			return floorThickness
		end)
	end,
	setSelectedMazeWallThickness = function(wallThickness: number)
		selectedMazeWallThickness(function(_oldWallThickness: number)
			return wallThickness
		end)
	end,
	setSelectedMazeAlgorithm = function(algorithm: string)
		selectedMazeAlgorithm(function(_oldAlgorithm: string)
			return algorithm
		end)
	end,
	setSelectedMazeSeed = function(seed: number | string)
		selectedMazeSeed(function(_oldSeed: number | string)
			return seed
		end)
	end,
	setSelectedMazeEntranceExitCount = function(entranceExitCount: number)
		selectedMazeEntranceExitCount(function(_oldEntranceExitCount: number)
			return entranceExitCount
		end)
	end,
	setSelectedMazeBuildPosition = function(buildPosition: string)
		selectedMazeBuildPosition(function(_oldBuildPosition: string)
			return buildPosition
		end)
	end,
}

return {
	actions = actions,
	state = {
		selectedMazeWidth = selectedMazeWidth,
		selectedMazeLength = selectedMazeLength,
		selectedMazeHeight = selectedMazeHeight,
		selectedMazeFloorThickness = selectedMazeFloorThickness,
		selectedMazeWallThickness = selectedMazeWallThickness,
		selectedMazeAlgorithm = selectedMazeAlgorithm,
		selectedMazeSeed = selectedMazeSeed,
		selectedMazeEntranceExitCount = selectedMazeEntranceExitCount,
		selectedMazeBuildPosition = selectedMazeBuildPosition,
	},
}
