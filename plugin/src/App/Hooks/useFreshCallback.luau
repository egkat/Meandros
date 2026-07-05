-- From https://github.com/sircfenner/StudioComponents

local React = require(script.Parent.Parent.Parent.Parent.Packages.React)

type Callback<Args..., Rets...> = (Args...) -> Rets...

local function useFreshCallback<Args..., Rets...>(
	-- stylua: ignore
	callback: Callback<Args..., Rets...>,
	deps: { any }?
): Callback<Args..., Rets...>
	local ref = React.useRef(callback) :: { current: Callback<Args..., Rets...> }

	React.useEffect(function()
		ref.current = callback
	end, deps)

	return function(...)
		return ref.current(...)
	end
end

return useFreshCallback