local ChangeHistoryService = game:GetService("ChangeHistoryService")
local CollectionService = game:GetService("CollectionService")

local Builder = require(script.Parent.Parent.Builder)
local Constants = require(script.Parent.Parent.Data.Constants)
local MazeGenerator = require(script.Parent.Parent.Generators.MazeGenerator)
local PluginSettings = require(script.Parent.Parent.PluginSettings)
local ParseBuildPosition = require(script.Parent.Parent.Utils.ParseBuildPosition)

-- Previews always render the same way regardless of the Appearance settings
local PREVIEW_MATERIAL = Enum.Material.Plastic
local PREVIEW_COLOR = Color3.fromRGB(163, 162, 165)
local PREVIEW_TRANSPARENCY = 0.5
local BUILD_MODEL_NAME = "Maze"

-- Maximum Number of steps for timelapse reveal.
local TIMELAPSE_MAX_REVEAL_STEPS = 1000

local CAMERA_RAYCAST_DISTANCE = 5000
local CAMERA_FALLBACK_DISTANCE = 250

export type MazeSettings = {
	algorithm: string,
	seed: number | string,
	width: number,
	length: number,
	wallHeight: number,
	wallThickness: number,
	floorThickness: number,
	material: string,
	color: Color3,
	transparency: number,
	buildPosition: string,
}

local RANDOM_SEED_MAX = 2 ^ 31 - 1

local isBuilding = false

-- Seed rolled by the most recent "Random" preview, so a build reuses it while that preview stands
local lastRandomPreviewSeed: number? = nil

local MazeService = {}

local function findPreviewFolder(): Instance?
	return workspace:FindFirstChild(Constants.PREVIEW_FOLDER_NAME)
end

local function getOrCreatePreviewFolder(): Instance
	local previewFolder = findPreviewFolder()

	if not previewFolder then
		previewFolder = Instance.new("Folder")
		previewFolder.Name = Constants.PREVIEW_FOLDER_NAME
		previewFolder.Parent = workspace
	end

	return previewFolder
end

-- Trust tag as source of truth not just folder children
local function clearPreviewGeometry()
	for _, taggedInstance in CollectionService:GetTagged(Constants.PREVIEW_TAG) do
		taggedInstance:Destroy()
	end

	local previewFolder = findPreviewFolder()

	if previewFolder and #previewFolder:GetChildren() == 0 then
		previewFolder:Destroy()
	end
end

local function runRecorded(recordingName: string, operation: () -> ())
	local recording = ChangeHistoryService:TryBeginRecording(recordingName)

	if not recording then
		warn(`[MazeService]: could not begin an undo recording for '{recordingName}'; the action will not be undoable`)
	end

	local success, operationError = pcall(operation)

	if recording then
		ChangeHistoryService:FinishRecording(
			recording,
			if success then Enum.FinishRecordingOperation.Commit else Enum.FinishRecordingOperation.Cancel
		)
	end

	if not success then
		error(operationError, 0)
	end
end


local function getCameraTargetPosition(): Vector3
	local camera = workspace.CurrentCamera

	if not camera then
		return Vector3.zero
	end

	local cameraCFrame = camera.CFrame
	local raycastParams = RaycastParams.new()
	raycastParams.FilterType = Enum.RaycastFilterType.Exclude

	local previewFolder = findPreviewFolder()

	if previewFolder then
		raycastParams.FilterDescendantsInstances = { previewFolder }
	end

	local raycastResult =
		workspace:Raycast(cameraCFrame.Position, cameraCFrame.LookVector * CAMERA_RAYCAST_DISTANCE, raycastParams)

	if raycastResult then
		return raycastResult.Position
	end

	return cameraCFrame.Position + cameraCFrame.LookVector * CAMERA_FALLBACK_DISTANCE
end


local function repositionBuildOrigin(settings: MazeSettings): Vector3
	local buildPosition = ParseBuildPosition(settings.buildPosition)
	assert(buildPosition, `[MazeService]: invalid build position '{settings.buildPosition}'`)

	local target = if buildPosition == "Camera" then getCameraTargetPosition() else buildPosition

	local centerOffset = Vector3.new(
		(settings.width - 1) * Constants.DEFAULT_CELL_SIZE / 2,
		0,
		(settings.length - 1) * Constants.DEFAULT_CELL_SIZE / 2
	)

	return target - centerOffset
end

local function resolveSeed(settings: MazeSettings, isBuild: boolean): number
	if settings.seed == "Random" then
		if isBuild then
			if lastRandomPreviewSeed ~= nil and #CollectionService:GetTagged(Constants.PREVIEW_TAG) > 0 then
				return lastRandomPreviewSeed
			end

			return Random.new():NextInteger(0, RANDOM_SEED_MAX)
		end

		lastRandomPreviewSeed = Random.new():NextInteger(0, RANDOM_SEED_MAX)

		return lastRandomPreviewSeed :: number
	end

	assert(typeof(settings.seed) == "number", `[MazeService]: invalid seed '{settings.seed}'`)

	if not isBuild then
		lastRandomPreviewSeed = nil
	end

	return settings.seed
end

local function generateMazeParts(settings: MazeSettings, parent: Instance, seed: number): { BasePart }
	local gridConfigs = {
		width = settings.width,
		height = settings.length,
	}

	local grid = MazeGenerator.generate(settings.algorithm, gridConfigs, seed)

	local buildHandle = Builder.build(grid, gridConfigs, {
		cellSize = Constants.DEFAULT_CELL_SIZE,
		wallHeight = settings.wallHeight,
		wallThickness = settings.wallThickness,
		floorThickness = settings.floorThickness,
		origin = repositionBuildOrigin(settings),
		parent = parent,
	})

	return buildHandle.parts
end

function MazeService.preview(settings: MazeSettings)
	local seed = resolveSeed(settings, false)

	runRecorded("MeandrosPreviewMaze", function()
		clearPreviewGeometry()

		local previewFolder = getOrCreatePreviewFolder()

		for _, part in generateMazeParts(settings, previewFolder, seed) do
			CollectionService:AddTag(part, Constants.PREVIEW_TAG)
			part.Material = PREVIEW_MATERIAL
			part.Color = PREVIEW_COLOR
			part.Transparency = PREVIEW_TRANSPARENCY
			part.CanCollide = false
		end
	end)
end

function MazeService.revertPreview()
	if #CollectionService:GetTagged(Constants.PREVIEW_TAG) == 0 and findPreviewFolder() == nil then
		return
	end

	runRecorded("MeandrosRevertPreview", clearPreviewGeometry)
end

function MazeService.build(settings: MazeSettings)

	if isBuilding then
		return
	end

	isBuilding = true

	local seed = resolveSeed(settings, true)

	local success, buildError = pcall(runRecorded, "MeandrosBuildMaze", function()
		local mazeModel = Instance.new("Model")
		mazeModel.Name = BUILD_MODEL_NAME

		local parts = generateMazeParts(settings, mazeModel, seed)

		for _, part in parts do
			part.Material = Enum.Material[settings.material]
			part.Color = settings.color
			part.Transparency = settings.transparency
			part.CanCollide = true
		end

		local isTimelapseMode = PluginSettings:getSetting("timelapse")

		if isTimelapseMode then
			for _, part in parts do
				part.Parent = nil
			end
		end

		-- Add Timelapse parts to model over time.
		mazeModel.Parent = workspace

		clearPreviewGeometry()

		if isTimelapseMode then
			local revealSteps = math.min(#parts, TIMELAPSE_MAX_REVEAL_STEPS)
			local partsPerStep = math.ceil(#parts / revealSteps)

			for index, part in parts do
				part.Parent = mazeModel

				if index % partsPerStep == 0 then
					task.wait()
				end
			end
		end
	end)

	isBuilding = false

	if not success then
		error(buildError, 0)
	end
end

return MazeService
