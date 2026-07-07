--!strict
local Grid = require(script.Parent.Parent.Grid)
local GridTypes = require(script.Parent.Parent.GridTypes)

type Wall = GridTypes.Wall
type Cell = GridTypes.Cell
type GridConfigs = GridTypes.GridConfigs
type NeighborEntry = GridTypes.NeighborEntry

export type FrontierWall = {
	cell: Cell,
	direction: Wall,
}

export type RandomizedPrimsState = {
	grid: { Cell },
	configs: GridConfigs,
	random: Random,
	currentCell: Cell,
	frontier: { FrontierWall },
	generationCompleted: boolean,
}

local RandomizedPrims = {}

function RandomizedPrims.setup(configs: GridConfigs, seed: number): RandomizedPrimsState
	assert(typeof(configs) == "table", `[RandomizedPrims]: configs must be a table`)
	assert(typeof(seed) == "number", `[RandomizedPrims]: seed must be a number`)

	local random = Random.new(seed)
	local grid = Grid.buildGrid(configs)

	local startingCellIndex = random:NextInteger(1, configs.height * configs.width)
	local startingCell = grid[startingCellIndex]

	startingCell.visited = true

	local frontier: { FrontierWall } = {}

	for _, neighborEntry in Grid.getAllCellNeighbors(grid, configs, startingCell) do
		table.insert(frontier, {
			cell = startingCell,
			direction = neighborEntry.direction,
		})
	end

	return {
		grid = grid,
		configs = configs,
		random = random,
		currentCell = startingCell,
		frontier = frontier,
		generationCompleted = false,
	}
end

function RandomizedPrims.step(state: RandomizedPrimsState)
	assert(typeof(state) == "table", `[RandomizedPrims]: state must be a table`)

	if state.generationCompleted then
		return
	end

	if #state.frontier == 0 then
		state.generationCompleted = true
		return
	end

	local randomIndex = state.random:NextInteger(1, #state.frontier)
	local randomWall = state.frontier[randomIndex]

	local wallCell = randomWall.cell

	local delta = Grid.DELTA_MAPPING[randomWall.direction]

	local farCell = Grid.getCell(
		state.grid,
		state.configs,
		randomWall.cell.row + delta.deltaY,
		randomWall.cell.column + delta.deltaX
	)

	assert(farCell, `[RandomizedPrims]: frontier wall must divide two in-bounds cells`)

	local cellsVisited = 0

	if wallCell.visited then
		cellsVisited += 1
	end

	if farCell.visited then
		cellsVisited += 1
	end

	if cellsVisited == 1 then
		Grid.removeWall(wallCell, farCell, randomWall.direction)
		Grid.markVisited(farCell)

		state.currentCell = farCell

		for _, neighborEntry in Grid.getAllCellNeighbors(state.grid, state.configs, farCell) do
			table.insert(state.frontier, {
				cell = farCell,
				direction = neighborEntry.direction,
			})
		end
	end

	table.remove(state.frontier, randomIndex)

end

return RandomizedPrims
