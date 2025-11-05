local M = {}

function M.resolve_list(list)
	if type(list) == "function" then
		return list() or {}
	end
	return list or {}
end



return M