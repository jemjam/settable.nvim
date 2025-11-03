--- EmmyLua type definitions for neoconfig.nvim
--- These are lightweight annotations to help editor completion.

---@class NCKeymap
--- Keymap entries must be provided in the same form as `vim.keymap.set`:
--- an array `{ mode, lhs, rhs, opts }`. `mode` may be a string or table.
---@field _array table

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

---@class NeoConfig
---@field keymaps NCKeymap[]|fun():NCKeymap[]|nil
---@field commands NCCommand[]|fun():NCCommand[]|nil
---@field funcs NCFunc[]|fun():NCFunc[]|nil
---@field autocmds NCAutocmd[]|fun():NCAutocmd[]|nil
---@field defaults table|nil

return {}
