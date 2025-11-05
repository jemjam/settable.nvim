local utils = require("ConfigMap.utils")

local M = {}

function M.apply_funcs(list)
	local seen = {}
	for _, item in ipairs(utils.resolve_list(list)) do
		if type(item) ~= "table" then
			error("ConfigMap: func entry must be a table")
		end
		local name = item.name
		local fn = item.fn
		if not name or type(fn) ~= "function" then
			error("ConfigMap: funcs require 'name' and 'fn' (function)")
		end
		if seen[name] then
			error("ConfigMap: duplicate func name: " .. name)
		end
		seen[name] = true
		-- no runtime exposure by design; validation is sufficient for now
	end
end

return M