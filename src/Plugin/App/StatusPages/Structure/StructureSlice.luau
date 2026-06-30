local Charm = require(script.Parent.Parent.Parent.Parent.Parent.Packages.Charm)

local atom = Charm.atom
type Atom<T> = Charm.Atom<T>

local selectedMazeWidth: Atom<number> = atom(25)
local selectedMazeLength: Atom<number> = atom(25)

local actions = {
	setSelectedMazeWidth = function(width: number)
		selectedMazeWidth(function(_oldWidth: number)
			return width
		end)
	end,
	setSelectedMazeLength = function(length: number)
		selectedMazeLength(function(_oldLength: number)
			return length
		end)
	end,
}

return {
	actions = actions,
	state = {
        selectedMazeWidth = selectedMazeWidth,
        selectedMazeLength = selectedMazeLength,
	},
}
