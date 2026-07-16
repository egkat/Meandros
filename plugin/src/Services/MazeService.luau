local ChangeHistoryService = game:GetService("ChangeHistoryService")
local CollectionService = game:GetService("CollectionService")

local Builder = require(script.Parent.Parent.Builder)
local Constants = require(script.Parent.Parent.Data.Constants)
local MazeGenerator = require(script.Parent.Parent.Generators.MazeGenerator)
local PluginSettings = require(script.Parent.Parent.PluginSettings)

-- Previews always render the same way regardless of the Appearance settings
local PREVIEW_MATERIAL = Enum.Material.Plastic
local PREVIEW_COLOR = Color3.fromRGB(163, 162, 165)
local PREVIEW_TRANSPARENCY = 0.5
local BUILD_MODEL_NAME = "Maze"

-- Maximum Number of steps for timelapse reveal.
local TIMELAPSE_MAX_REVEAL_STEPS = 1000

export type MazeSettings = {
	algorithm: string,
	seed: number,
	width: number,
	length: number,
	wallHeight: number,
	wallThickness: number,
	floorThickness: number,
	material: string,
	color: Color3,
	transparency: number,
}

local isBuilding = false

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

local function generateMazeParts(settings: MazeSettings, parent: Instance): { BasePart }
	local gridConfigs = {
		width = settings.width,
		height = settings.length,
	}

	local grid = MazeGenerator.generate(settings.algorithm, gridConfigs, settings.seed)

	local buildHandle = Builder.build(grid, gridConfigs, {
		cellSize = Constants.DEFAULT_CELL_SIZE,
		wallHeight = settings.wallHeight,
		wallThickness = settings.wallThickness,
		floorThickness = settings.floorThickness,
		parent = parent,
	})

	return buildHandle.parts
end

function MazeService.preview(settings: MazeSettings)
	runRecorded("MeandrosPreviewMaze", function()
		clearPreviewGeometry()

		local previewFolder = getOrCreatePreviewFolder()

		for _, part in generateMazeParts(settings, previewFolder) do
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

	local success, buildError = pcall(runRecorded, "MeandrosBuildMaze", function()
		local mazeModel = Instance.new("Model")
		mazeModel.Name = BUILD_MODEL_NAME

		local parts = generateMazeParts(settings, mazeModel)

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
