local utils = require("settable.utils")

local M = {}

function M.apply_keymaps(list)
	local seen = {}
	for _, item in ipairs(utils.resolve_list(list)) do
		if type(item) ~= "table" then
			error("settable: keymap entry must be a table: {lhs, rhs, desc?, mode?}")
		end

		local args, opts = utils.splitTableProperties(item)
		local lhs = args[1]
		local rhs = args[2]
		if not lhs or not rhs then
			error("settable: keymap entry requires lhs and rhs as first two elements")
		end

		local mode = "n"
		if opts.mode ~= nil then
			mode = opts.mode
			opts.mode = nil
		end
		local modes = type(mode) == "table" and mode or { mode }

		-- normalize buffer boolean -> 0 (current buffer)
		if opts.buffer == true then
			opts.buffer = 0
		end

		-- duplicate detection per-mode
		for _, m in ipairs(modes) do
			local key = m .. "::" .. lhs
			if seen[key] then
				error("settable: duplicate keymap for mode+lhs: " .. key)
			end
			seen[key] = true
		end

		-- use vim.keymap.set which accepts string or table of modes
		vim.keymap.set(modes, lhs, rhs, opts)
	end
end

return M
