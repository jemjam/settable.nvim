local M = {}

--- Resolve a list from input (list or function)
---@param list {} | fun(): table
---@return table
function M.resolve_list(list)
	if type(list) == "function" then
		return list() or {}
	end
	return list or {}
end

--- Partition named and positional args from one input table into two separate.
---@param inputTable table
---@return {[number]: any} arrayProperties, {[string]: any} objectProperties
function M.splitTableProperties(inputTable)
	local arrayProperties = {}
	local objectProperties = {}

	for key, value in pairs(inputTable) do
		if type(key) == "number" then
			-- If the key is a number, it belongs to the array
			table.insert(arrayProperties, value)
		else
			-- Otherwise, it is a named property
			objectProperties[key] = value
		end
	end

	return arrayProperties, objectProperties
end

return M

