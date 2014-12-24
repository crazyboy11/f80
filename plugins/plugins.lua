function enable_plugin( filename )
	-- Check if plugin is enabled
	if plugin_enabled(filename) then
		return 'Plugin '..filename..' is enabled'
	end
	-- Checks if plugin exists
	if plugin_exists(filename) then
		-- Add to the config table
		table.insert(config.enabled_plugins, filename)
		-- Reload the plugins
		return reload_plugins( )
	else
		return 'Plugin '..filename..' does not exists'
	end
end

function disable_plugin( filename )
	-- Check if plugins exists
	if not plugin_exists(filename) then
		return 'Plugin '..filename..' does not exists'
	end
	local k = plugin_enabled(filename)
	-- Check if plugin is enabled
	if not k then
		return 'Plugin '..filename..' not enabled'
	end
	-- Disable and reload
	table.remove(config.enabled_plugins, k)
	return reload_plugins(true)		
end

function reload_plugins( )
	plugins = {}
	load_plugins()
	return list_plugins(true)
end

-- Retruns the key (index) in the config.enabled_plugins table
function plugin_enabled( name )
	for k,v in pairs(config.enabled_plugins) do
		if name == v then
			return k
		end
	end
	-- If not found
	return false
end

-- Returns true if file exists in plugins folder
function plugin_exists( name )
  for k,v in pairs(plugins_names()) do
    if name == v then
      return true
    end
  end
  return false
end

function list_plugins(only_enabled)
	local text = ''
	for k, v in pairs( plugins_names( )) do
		--  ✔ enabled, ❌ disabled
		local status = '❌'
		-- Check if is enabled
		for k2, v2 in pairs(config.enabled_plugins) do
			if v == v2 then 
				status = '✔' 
			end
		end
		if not only_enabled or status == '✔' then
			text = text..v..' '..status..'\n'
		end
	end
	return text
end

function run(msg, matches)
	-- Show the available plugins 
	if matches[1] == '!plugins' then
		return list_plugins()
	end
	-- Enable a plugin
	if matches[1] == 'enable' then
		print("enable: "..matches[2])
		return enable_plugin(matches[2])
	end
	-- Disable a plugin
	if matches[1] == 'disable' then
		print("disable: "..matches[2])
		return disable_plugin(matches[2])
	end
	-- Reload all the plugins!
	if matches[1] == 'reload' then
		return reload_plugins(true)
	end
end

return {
	description = "Enables, disables and reloads plugins", 
	usage = "!plugins, !plugins enable [plugin.lua], !plugins disable [plugin.lua], !plugins reload",
	patterns = {
		"^!plugins$",
		"^!plugins? (enable) (.*)$",
		"^!plugins? (disable) (.*)$",
		"^!plugins? (reload)$"
		}, 
	run = run 
}