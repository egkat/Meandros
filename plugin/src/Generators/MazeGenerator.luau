--!strict
local GridTypes = require("./GridTypes")
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
	RandomizedDepthFirstSearch = RandomizedDepthFirstSearch,
	RandomizedKruskals = RandomizedKruskals,
	RandomizedPrims = RandomizedPrims,
	RandomizedWilsons = RandomizedWilsons,
}

local MazeGenerator = {}

function MazeGenerator.generate(algorithmName: string, configs: GridConfigs, seed: number): { Cell }
	local algorithm = ALGORITHMS[algorithmName]

	assert(algorithm, `[MazeGenerator]: unknown algorithm '{algorithmName}'`)

	local state = algorithm.setup(configs, seed)

	while not state.generationCompleted do
		algorithm.step(state)
	end

	return state.grid
end

return MazeGenerator
