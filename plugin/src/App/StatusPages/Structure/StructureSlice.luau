local Charm = require(script.Parent.Parent.Parent.Parent.Parent.Packages.Charm)

local atom = Charm.atom
type Atom<T> = Charm.Atom<T>

local selectedMazeWidth: Atom<number> = atom(25)
local selectedMazeLength: Atom<number> = atom(25)
local selectedMazeHeight: Atom<number> = atom(10)
local selectedMazeFloorThickness: Atom<number> = atom(1)
local selectedMazeWallThickness: Atom<number> = atom(1)
local selectedMazeAlgorithm: Atom<string> = atom("RandomizedDepthFirstSearch")
local selectedMazeSeed: Atom<number> = atom(0)
local selectedMazeEntranceExitCount: Atom<number> = atom(2)

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
	setSelectedMazeSeed = function(seed: number)
		selectedMazeSeed(function(_oldSeed: number)
			return seed
		end)
	end,
	setSelectedMazeEntranceExitCount = function(entranceExitCount: number)
		selectedMazeEntranceExitCount(function(_oldEntranceExitCount: number)
			return entranceExitCount
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
	},
}
