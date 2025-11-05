--- ConfigMap.nvim — minimal implementation (Phase 2)
--- Implements core helpers to create keymaps, commands, autocmds, and funcs

local M = {}

local keymaps = require("ConfigMap.keymaps")
local commands = require("ConfigMap.commands")
local autocmds = require("ConfigMap.autocmds")
local funcs = require("ConfigMap.funcs")

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

	keymaps.apply_keymaps(cfg.keymaps)
	commands.apply_commands(cfg.commands)
	autocmds.apply_autocmds(cfg.autocmds)
	funcs.apply_funcs(cfg.funcs)
end

return M
