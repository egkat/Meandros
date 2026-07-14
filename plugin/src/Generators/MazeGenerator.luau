--!strict
local GridTypes = require("./GridTypes")
local RandomizedDepthFirstSearch = require("./Algorithms/RandomizedDepthFirstSearch")
local RandomizedPrims = require("./Algorithms/RandomizedPrims")

type Cell = GridTypes.Cell
type GridConfigs = GridTypes.GridConfigs

type MazeAlgorithm = {
	setup: (configs: GridConfigs, seed: number) -> any,
	step: (state: any) -> (),
}

local ALGORITHMS: { [string]: MazeAlgorithm } = {
	RandomizedDepthFirstSearch = RandomizedDepthFirstSearch,
	RandomizedPrims = RandomizedPrims,
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
