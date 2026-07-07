-- From https://github.com/rojo-rbx/rojo/

local plugin = plugin or script:FindFirstAncestorWhichIsA("Plugin")
local React = require(script.Parent.Parent.Packages.React)

local DEFAULT_SETTINGS = {
	randomizeAppearanceOnInit = false,
	-- autoPreview = false,
	-- checkForUpdates = false
}

local Settings = {}

Settings._settingValues = table.clone(DEFAULT_SETTINGS)
Settings._settingUpdateListeners = {}
Settings._settingBindings = {}

if plugin then

	for settingName, defaultSettingValue in pairs(Settings._settingValues) do
		local savedValue = plugin:GetSetting(`Meandros_{settingName}`)

		if savedValue == nil then
			task.spawn(plugin.SetSetting, plugin, `Meandros_{settingName}`, defaultSettingValue)
			Settings._settingValues[settingName] = defaultSettingValue
		else
			Settings._settingValues[settingName] = savedValue
		end
	end
end

function Settings:getSetting(settingName: string)

	if DEFAULT_SETTINGS[settingName] == nil then
		error(`[SETTINGS]: Setting '{settingName}' is not a valid setting.`)
	end

	return self._settingValues[settingName]
end

function Settings:setSetting(settingName: string, settingValue: any)
	self._settingValues[settingName] = settingValue
	if self._settingBindings[settingName] then
		self._settingBindings[settingName]._setBinding(settingValue)
	end

	if plugin then
		task.spawn(plugin.SetSetting, plugin, `Meandros_{settingName}`, settingValue)
	end

	if self._settingUpdateListeners[settingName] then
		for callback in pairs(self._settingUpdateListeners[settingName]) do
			task.spawn(callback, settingValue)
		end
	end
end

function Settings:onSettingChanged(settingName: string, settingCallback)
	local settingListeners = self._settingUpdateListeners[settingName]

	if settingListeners == nil then
		settingListeners = {}
		self._settingUpdateListeners[settingName] = settingListeners
	end

	settingListeners[settingCallback] = true

	return function()
		settingListeners[settingCallback] = nil
	end
end

function Settings:getSettingBinding(settingName: string)
	local existingBinding = self._settingBindings[settingName]

	if existingBinding then
		return existingBinding._binding
	end

	local binding, setBinding = React.createBinding(self._settingValues[settingName])

	self._settingBindings[settingName] = {
		_binding = binding,
		_setBinding = setBinding,
	}

	return binding
end

function Settings:getSettingBindings(...: string)
	local settingBindings = {}

	for i = 1, select("#", ...) do
		local source = select(i, ...)
		settingBindings[source] = self:getSettingBinding(source)
	end

	return React.joinBindings(settingBindings)
end

export type Settings = typeof(Settings)

return Settings :: Settings
