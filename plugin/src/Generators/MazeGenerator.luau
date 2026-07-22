--!strict
local Grid = require("./Grid")
local GridTypes = require("./GridTypes")
local RandomizedAldousBroder = require("./Algorithms/RandomizedAldousBroder")
local RandomizedDepthFirstSearch = require("./Algorithms/RandomizedDepthFirstSearch")
local RandomizedKruskals = require("./Algorithms/RandomizedKruskals")
local RandomizedPrims = require("./Algorithms/RandomizedPrims")
local RandomizedWilsons = require("./Algorithms/RandomizedWilsons")

type Cell = GridTypes.Cell
type GridConfigs = GridTypes.GridConfigs

type MazeAlgorithm = {
	setup: (configs: GridConfigs, seed: number) -> any,
	step: (state: any) -> (),
}

local ALGORITHMS: { [string]: MazeAlgorithm } = {
	RandomizedAldousBroder = RandomizedAldousBroder,
	RandomizedDepthFirstSearch = RandomizedDepthFirstSearch,
	RandomizedKruskals = RandomizedKruskals,
	RandomizedPrims = RandomizedPrims,
	RandomizedWilsons = RandomizedWilsons,
}

local MazeGenerator = {}

function MazeGenerator.generate(algorithmName: string, configs: GridConfigs, seed: number, entranceExitCount: number): { Cell }
	local algorithm = ALGORITHMS[algorithmName]

	assert(algorithm, `[MazeGenerator]: unknown algorithm '{algorithmName}'`)

	local state = algorithm.setup(configs, seed)

	while not state.generationCompleted do
		algorithm.step(state)
	end

	-- Use same seed but separate from algorithm
	Grid.carveEntrancesAndExits(state.grid, configs, entranceExitCount, Random.new(seed + 1))

	return state.grid
end

return MazeGenerator
