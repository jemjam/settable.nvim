--- ConfigMap.nvim — minimal implementation (Phase 2)
--- Implements core helpers to create keymaps, commands, autocmds, and funcs

local M = {}

local function resolve_list(list)
	if type(list) == "function" then
		return list() or {}
	end
	return list or {}
end

local function merge_opts(defaults, opts)
	if not defaults and not opts then
		return {}
	end
	defaults = defaults or {}
	opts = opts or {}
	if vim.tbl_isempty(defaults) then
		return vim.deepcopy(opts)
	end
	return vim.tbl_deep_extend("force", defaults, opts)
end

local function apply_keymaps(list, defaults)
	local seen = {}
	for _, item in ipairs(resolve_list(list)) do
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
		local merged_opts = merge_opts(defaults, opts)

		-- normalize buffer boolean -> 0 (current buffer)
		if merged_opts.buffer == true then
			merged_opts.buffer = 0
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
		vim.keymap.set(modes, lhs, rhs, merged_opts)
	end
end

local function apply_commands(list, defaults)
	local seen = {}
	for _, item in ipairs(resolve_list(list)) do
		if type(item) ~= "table" then
			error("ConfigMap: command entry must be a table")
		end
		local name = item[1]
		if not name then
			error("ConfigMap: command entry requires first argument for 'name'")
		end
		if seen[name] then
			error("ConfigMap: duplicate command name: " .. name)
		end
		seen[name] = true

		local opts = merge_opts(defaults, item.opts)
		local handler = item[2]
		if not handler then
			error("ConfigMap: command '" .. name .. "' requires a handler (string or function)")
		end

		-- nvim_create_user_command accepts either a string (ex command) or a Lua function
		vim.api.nvim_create_user_command(name, handler, opts)
	end
end

local function ensure_augroup(name, clear)
	-- create (or return existing) augroup id
	if not name then
		return nil
	end
	return vim.api.nvim_create_augroup(name, { clear = (clear == true) })
end

local function apply_autocmds(list, defaults)
	for _, item in ipairs(resolve_list(list)) do
		if type(item) ~= "table" then
			error("ConfigMap: autocmd entry must be a table")
		end
		local events = item.events
		if not events then
			error("ConfigMap: autocmd entry requires 'events'")
		end
		if not item.callback and not item.command then
			error("ConfigMap: autocmd requires 'callback' or 'command'")
		end

		local evts = type(events) == "table" and events or { events }
		local opts = merge_opts(defaults, item.opts)

		local group_id = nil
		if item.group then
			group_id = ensure_augroup(item.group, opts.clear)
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

local function apply_funcs(list)
	local seen = {}
	for _, item in ipairs(resolve_list(list)) do
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

function M.setup(opts)
	local cfg = opts
	if type(opts) == "function" then
		cfg = opts()
	end
	cfg = cfg or {}

	-- support per-list functions
	cfg.keymaps = cfg.keymaps or {}
	cfg.commands = cfg.commands or {}
	cfg.autocmds = cfg.autocmds or {}
	cfg.funcs = cfg.funcs or {}
	cfg.defaults = cfg.defaults or {}

	apply_keymaps(cfg.keymaps, cfg.defaults.keymaps or {})
	apply_commands(cfg.commands, cfg.defaults.commands or {})
	apply_autocmds(cfg.autocmds, cfg.defaults.autocmds or {})
	apply_funcs(cfg.funcs)
end

return M
