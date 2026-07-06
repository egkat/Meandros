local random = math.random

return function<T>(items: { [any]: T }): T?
	local list = {}
	for _, v in items do
		table.insert(list, v)
	end

	local n = #list
	if n == 0 then
		return nil
	end

	return list[random(n)]
end