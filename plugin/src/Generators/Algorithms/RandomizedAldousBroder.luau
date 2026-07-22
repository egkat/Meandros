--!strict
local Grid = require("../Grid")
local GridTypes = require("../GridTypes")

type Cell = GridTypes.Cell
type GridConfigs = GridTypes.GridConfigs
type NeighborEntry = GridTypes.NeighborEntry

export type RandomizedAldousBroderState = {
	grid: { Cell },
	configs: GridConfigs,
	random: Random,
	currentCell: Cell,
	exploredCells: { Cell },
	generationCompleted: boolean,
}

local RandomizedAldousBroder = {}

function RandomizedAldousBroder.setup(configs: GridConfigs, seed: number): RandomizedAldousBroderState
	assert(typeof(configs) == "table", `[RandomizedAldousBroder]: configs must be a table`)
	assert(typeof(seed) == "number", `[RandomizedAldousBroder]: seed must be a number`)

	local random = Random.new(seed)
	local grid = Grid.buildGrid(configs)

	local startingCellIndex = random:NextInteger(1, configs.height * configs.width)
	local startingCell = grid[startingCellIndex]

	startingCell.visited = true

	return {
		grid = grid,
		configs = configs,
		random = random,
		currentCell = startingCell,
		exploredCells = { startingCell },
		generationCompleted = false,
	}
end

function RandomizedAldousBroder.step(state: RandomizedAldousBroderState)
	assert(typeof(state) == "table", `[RandomizedAldousBroder]: state must be a table`)

	if state.generationCompleted then
		return
	end

	if #state.exploredCells == #state.grid then
		state.generationCompleted = true
		return
	end

	local currentCell = state.currentCell
	local cellNeighbors = Grid.getAllCellNeighbors(state.grid, state.configs, currentCell)
	local neighborEntry = cellNeighbors[state.random:NextInteger(1, #cellNeighbors)]

	if not neighborEntry.neighborCell.visited then
		Grid.removeWall(currentCell, neighborEntry.neighborCell, neighborEntry.direction)
		Grid.markVisited(neighborEntry.neighborCell)
		table.insert(state.exploredCells, neighborEntry.neighborCell)
	end

	state.currentCell = neighborEntry.neighborCell

	if #state.exploredCells == #state.grid then
		state.generationCompleted = true
	end
end

return RandomizedAldousBroder
