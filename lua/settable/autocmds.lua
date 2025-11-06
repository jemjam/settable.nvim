local utils = require("settable.utils")

local M = {}

function M.ensure_augroup(name, clear)
	-- create (or return existing) augroup id
	if not name then
		return nil
	end
	return vim.api.nvim_create_augroup(name, { clear = (clear == true) })
end

function M.apply_autocmds(list)
	for _, item in ipairs(utils.resolve_list(list)) do
		if type(item) ~= "table" then
			error("settable: autocmd entry must be a table")
		end
		local events = item.events
		if not events then
			error("settable: autocmd entry requires 'events'")
		end
		if not item.callback and not item.command then
			error("settable: autocmd requires 'callback' or 'command'")
		end

		local evts = type(events) == "table" and events or { events }
		local opts = item.opts or {}

		local group_id = nil
		if item.group then
			group_id = M.ensure_augroup(item.group, opts.clear)
		end

		local aucmd_opts = {
			pattern = item.pattern or opts.pattern or "*",
			group = group_id,
			callback = item.callback,
			command = item.command,
			once = opts.once,
			nested = opts.nested,
			buffer = opts.buffer,
		}

		vim.api.nvim_create_autocmd(evts, aucmd_opts)
	end
end

return M