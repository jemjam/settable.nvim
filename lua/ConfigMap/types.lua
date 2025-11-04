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
---@field name string
---@field handler string|fun()
---@field opts table|nil

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
