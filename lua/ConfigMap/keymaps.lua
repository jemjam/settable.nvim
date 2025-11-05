local utils = require("ConfigMap.utils")

local M = {}

function M.apply_keymaps(list)
	local seen = {}
	for _, item in ipairs(utils.resolve_list(list)) do
		if type(item) ~= "table" then
			error("ConfigMap: keymap entry must be a table: {lhs, rhs, desc?, mode?}")
		end

		local lhs = item[1]
		local rhs = item[2]
		local desc = item.desc
		local mode = item.mode or "n"
		if not lhs or not rhs then
			error("ConfigMap: keymap entry requires lhs and rhs as first two elements")
		end

		local modes = type(mode) == "table" and mode or { mode }
		local opts = {}
		if desc then
			opts.desc = desc
		end

		-- normalize buffer boolean -> 0 (current buffer)
		if opts.buffer == true then
			opts.buffer = 0
		end

		-- duplicate detection per-mode
		for _, m in ipairs(modes) do
			local key = m .. "::" .. lhs
			if seen[key] then
				error("ConfigMap: duplicate keymap for mode+lhs: " .. key)
			end
			seen[key] = true
		end

		-- use vim.keymap.set which accepts string or table of modes
		vim.keymap.set(modes, lhs, rhs, opts)
	end
end

return M