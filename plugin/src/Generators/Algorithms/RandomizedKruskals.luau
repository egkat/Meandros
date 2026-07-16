--!strict
local Grid = require("../Grid")
local GridTypes = require("../GridTypes")
local Set = require("../../Classes/Set")

type Wall = GridTypes.Wall
type Cell = GridTypes.Cell
type GridConfigs = GridTypes.GridConfigs

export type EdgeWall = {
	cell: Cell,
	direction: Wall,
}

export type RandomizedKruskalsState = {
	grid: { Cell },
	configs: GridConfigs,
	random: Random,
	currentCell: Cell,
	walls: { EdgeWall },
	cellSets: { [Cell]: Set.Set<Cell> },
	totalCells: number,
	generationCompleted: boolean,
}

-- Only South and East so each wall between two cells appears exactly once
local EDGE_DIRECTIONS: { Wall } = { "South", "East" }

local RandomizedKruskals = {}

function RandomizedKruskals.setup(configs: GridConfigs, seed: number): RandomizedKruskalsState
	assert(typeof(configs) == "table", `[RandomizedKruskals]: configs must be a table`)
	assert(typeof(seed) == "number", `[RandomizedKruskals]: seed must be a number`)

	local random = Random.new(seed)
	local grid = Grid.buildGrid(configs)

	local walls: { EdgeWall } = {}
	local cellSets: { [Cell]: Set.Set<Cell> } = {}

	for _, cell in grid do
		local cellSet: Set.Set<Cell> = Set.new()
		cellSet:add(cell)
		cellSets[cell] = cellSet

		for _, direction in EDGE_DIRECTIONS do
			local delta = Grid.DELTA_MAPPING[direction :: Wall]
			local neighborCell = Grid.getCell(grid, configs, cell.row + delta.deltaY, cell.column + delta.deltaX)

			-- Edge of Maze Wall
			if not neighborCell then
				continue
			end

			table.insert(walls, {
				cell = cell :: Cell,
				direction = direction :: Wall,
			})
		end
	end

	local startingCell = grid[random:NextInteger(1, #grid)]

	startingCell.visited = true

	return {
		grid = grid,
		configs = configs,
		random = random,
		currentCell = startingCell,
		walls = walls,
		cellSets = cellSets,
		totalCells = #grid,
		generationCompleted = false,
	}
end

function RandomizedKruskals.step(state: RandomizedKruskalsState)
	assert(typeof(state) == "table", `[RandomizedKruskals]: state must be a table`)

	if state.generationCompleted then
		return
	end

	if #state.walls == 0 then
		state.generationCompleted = true
		return
	end

	local randomIndex = state.random:NextInteger(1, #state.walls)
	local randomWall = state.walls[randomIndex]

	local nearCell = randomWall.cell

	local delta = Grid.DELTA_MAPPING[randomWall.direction]

	local farCell =
		Grid.getCell(state.grid, state.configs, nearCell.row + delta.deltaY, nearCell.column + delta.deltaX)

	assert(farCell, `[RandomizedKruskals]: edge wall must divide two in-bounds cells`)

	local nearSet = state.cellSets[nearCell]
	local farSet = state.cellSets[farCell]

	if nearSet ~= farSet then
		Grid.removeWall(nearCell, farCell, randomWall.direction)
		Grid.markVisited(nearCell)
		Grid.markVisited(farCell)

		state.currentCell = farCell

		-- Merge smaller set into larger set
		local bigSet, smallSet = nearSet, farSet

		if smallSet:size() > bigSet:size() then
			bigSet, smallSet = smallSet, bigSet
		end

		for _,  cell in smallSet:values() do
			state.cellSets[cell] = bigSet
		end

		bigSet:merge(smallSet)

		if bigSet:size() == state.totalCells then
			state.generationCompleted = true
		end
	end

	table.remove(state.walls, randomIndex)
end

return RandomizedKruskals
