--- EmmyLua type definitions for ConfigMap.nvim
--- These are lightweight annotations to help editor completion.

---@class NCKeymap
--- Keymap entries are provided as a table: {lhs, rhs, desc?, mode?}.
--- `mode` may be a string or table, defaults to "n" if not specified.
---@field [1] string lhs
---@field [2] string|fun() rhs
---@field desc string|nil
---@field mode string|string[]|nil

---@class NCCommand
---@field [1] string name -- user commands must be capitalized
---@field [2] string|fun() -- Command to execute, or a fn
---@field opts table|nil -- Additional opts to pass

---@class NCFunc
---@field name string
---@field fn fun()

---@class NCAutocmd
---@field events string|string[]
---@field pattern string|string[]|nil
---@field callback fun()|nil
---@field command string|nil
---@field group string|nil
---@field opts table|nil

---@class ConfigMap
---@field keymaps? NCKeymap[]|fun():NCKeymap[]
---@field commands? NCCommand[]|fun():NCCommand[]
---@field funcs? NCFunc[]|fun():NCFunc[]
---@field autocmds? NCAutocmd[]|fun():NCAutocmd[]
---@field defaults? table

return {}
