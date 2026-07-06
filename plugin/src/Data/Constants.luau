local Constants = {}

Constants.PLUGIN_NAME = `RoMaze`
Constants.TOOLBAR_TOOLTIP = `Show or hide RoMaze`

Constants.WIDGET_ID = `RoMazeMainWidget`
Constants.WIDGET_TITLE = Constants.PLUGIN_NAME
Constants.WIDGET_DEFAULT_SIZE = Vector2.new(450, 550)
Constants.WIDGET_MIN_SIZE = Vector2.new(360, 400)

Constants.SIDEBAR_WIDTH = 50

Constants.DEGREE_SYMBOL = utf8.char(0x00B0)

Constants.PAGE_COLORS = {
	HOME = Color3.fromRGB(59, 130, 246),
	STRUCTURE = Color3.fromRGB(34, 197, 94),
    APPEARANCE = Color3.fromRGB(168, 85, 247),
    BUILD = Color3.fromRGB(249, 115, 22),
    SETTINGS = Color3.fromRGB(107, 114, 128)
}

Constants.MATERIALS = {
    "Asphalt",
    "Basalt",
    "Brick",
    "Cardboard",
    "Carpet",
    "CeramicTiles",
    "ClayRoofTiles",
    "Cobblestone",
    "Concrete",
    "CorrodedMetal",
    "CrackedLava",
    "DiamondPlate",
    "Fabric",
    "Foil",
    "Forcefield",
    "Glacier",
    "Glass",
    "Granite",
    "Grass",
    "Ground",
    "Ice",
    "LeafyGrass",
    "Leather",
    "Limestone",
    "Marble",
    "Metal",
    "Mud",
    "Neon",
    "Pavement",
    "Pebble",
    "Plaster",
    "Plastic",
    "Rock",
    "RoofShingles",
    "Rubber",
    "Salt",
    "Sand",
    "Sandstone",
    "Slate",
    "SmoothPlastic",
    "Snow",
    "Wood",
    "WoodPlanks",
}

return Constants
