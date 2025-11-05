local utils = require("ConfigMap.utils")

local M = {}

function M.apply_commands(list)
	local seen = {}
	for _, item in ipairs(utils.resolve_list(list)) do
		if type(item) ~= "table" then
			error("ConfigMap: command entry must be a table")
		end

		local args, opts = utils.splitTableProperties(item)
		local name = args[1]
		if not name then
			error("ConfigMap: command entry requires first argument for 'name'")
		end
		local handler = args[2]
		if not handler then
			error("ConfigMap: command '" .. name .. "' requires a handler (string or function)")
		end

		name = name:gsub("^:", "")
		if seen[name] then
			error("ConfigMap: duplicate command name: " .. name)
		end
		seen[name] = true

		-- nvim_create_user_command accepts either a string (ex command) or a Lua function
		vim.api.nvim_create_user_command(name, handler, opts)
	end
end

return M
