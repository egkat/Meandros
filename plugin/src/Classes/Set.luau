local Set = {}
Set.__index = Set

export type Set<T> = typeof(setmetatable({} :: { _values: { [T]: true }, _size: number }, Set))

function Set.new<T>(): Set<T>
	local self = setmetatable({}, Set)

	self._values = {}
	self._size = 0

	return self :: Set<T>
end

-- Check if a value is in the set
function Set.has<T>(self: Set<T>, value: T): boolean
	return self._values[value] == true
end

-- Put a new unique value into the set;
function Set.add<T>(self: Set<T>, value: T)
	if self:has(value) then
		return
	end

	self._values[value] = true
	self._size += 1
end

-- Number of values in the set
function Set.size<T>(self: Set<T>): number
	return self._size
end

-- All values in the set as an array
function Set.values<T>(self: Set<T>): { T }
	local values = {}

	for value in self._values do
		table.insert(values, value)
	end

	return values
end

-- Absorb every value from another set into this one
function Set.merge<T>(self: Set<T>, other: Set<T>)
	for value in other._values do
		self:add(value)
	end
end

return Set
