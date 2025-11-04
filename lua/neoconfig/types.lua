--- EmmyLua type definitions for neoconfig.nvim
--- These are lightweight annotations to help editor completion.

---@class NCKeymapOpts
---@field remap boolean|nil
---@field silent boolean|nil
---@field expr boolean|nil
---@field nowait boolean|nil
---@field desc string|nil
---@field buffer boolean|number|nil
---@field replace_keycodes boolean|nil

---@class NCKeymap
--- Keymap entries must be provided in the same form as `vim.keymap.set`:
--- an array `{ mode, lhs, rhs, opts }`. `mode` may be a string or table.
---@field [1] string|string[] mode
---@field [2] string lhs
---@field [3] string|fun() rhs
---@field [4] NCKeymapOpts|nil opts

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
---@field keymaps? NCKeymap[]|fun():NCKeymap[]
---@field commands? NCCommand[]|fun():NCCommand[]
---@field funcs? NCFunc[]|fun():NCFunc[]
---@field autocmds? NCAutocmd[]|fun():NCAutocmd[]
---@field defaults? table

return {}
