--!strict
local Grid = require("../Grid")
local GridTypes = require("../GridTypes")

type Cell = GridTypes.Cell
type GridConfigs = GridTypes.GridConfigs
type NeighborEntry = GridTypes.NeighborEntry

export type RandomizedWilsonsState = {
	grid: { Cell },
	configs: GridConfigs,
	random: Random,
	currentCell: Cell,
	shuffledCellIndices: { number },
	nextStartingCellIndex: number,
	generationCompleted: boolean,
}

local RandomizedWilsons = {}

function RandomizedWilsons.setup(configs: GridConfigs, seed: number): RandomizedWilsonsState
	assert(typeof(configs) == "table", `[RandomizedWilsons]: configs must be a table`)
	assert(typeof(seed) == "number", `[RandomizedWilsons]: seed must be a number`)

	local random = Random.new(seed)
	local grid = Grid.buildGrid(configs)

	local startingCellIndex = random:NextInteger(1, configs.height * configs.width)
	local startingCell = grid[startingCellIndex]

	startingCell.visited = true

	local shuffledCellIndices = table.create(#grid)

	for cellIndex = 1, #grid do
		shuffledCellIndices[cellIndex] = cellIndex
	end

	for cellIndex = #grid, 2, -1 do
		local swapIndex = random:NextInteger(1, cellIndex)
		shuffledCellIndices[cellIndex], shuffledCellIndices[swapIndex] =
			shuffledCellIndices[swapIndex], shuffledCellIndices[cellIndex]
	end

	return {
		grid = grid,
		configs = configs,
		random = random,
		currentCell = startingCell,
		shuffledCellIndices = shuffledCellIndices,
		nextStartingCellIndex = 1,
		generationCompleted = false,
	}
end

function RandomizedWilsons.step(state: RandomizedWilsonsState)
	assert(typeof(state) == "table", `[RandomizedWilsons]: state must be a table`)

	if state.generationCompleted then
		return
	end

	local startingCell: Cell? = nil

	while state.nextStartingCellIndex <= #state.grid do
		local candidateCell = state.grid[state.shuffledCellIndices[state.nextStartingCellIndex]]

		if not candidateCell.visited then
			startingCell = candidateCell
			break
		end

		state.nextStartingCellIndex += 1
	end

	if not startingCell then
		state.generationCompleted = true
		return
	end

	-- Track cell exits to override loops in the random walk.
	local walkExits: { [Cell]: NeighborEntry } = {}
	local walkCell = startingCell

	-- Walk until reaching the existing maze
	while not walkCell.visited do
		local cellNeighbors = Grid.getAllCellNeighbors(state.grid, state.configs, walkCell)
		local neighborEntry = cellNeighbors[state.random:NextInteger(1, #cellNeighbors)]

		walkExits[walkCell] = neighborEntry
		walkCell = neighborEntry.neighborCell
	end

	local pathCell = startingCell

	-- Carve the path into maze based on previous loops walkExits
	while not pathCell.visited do
		local exitEntry = walkExits[pathCell] :: NeighborEntry

		Grid.removeWall(pathCell, exitEntry.neighborCell, exitEntry.direction)
		Grid.markVisited(pathCell)

		state.currentCell = pathCell
		pathCell = exitEntry.neighborCell
	end
end

return RandomizedWilsons
