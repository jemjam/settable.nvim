--- EmmyLua type definitions for ConfigMap.nvim
--- These are lightweight annotations to help editor completion.

---@class KeymapOpts See the `opts` used: "h vim.keymap.set()"
---@field [1] string lhs - They keys that will trigger whatever mapping.
---@field [2] string|fun() rhs - The keys that are fired instead when `lhs` triggers
---@field mode string|string[]? - Mode for keymap, may provide multiple, defaults to "n"
---@field noremap boolean? - Disables recursive mapping if true.
---@field desc string? - A human-readable description for the mapping.
---@field callback fun()? - A Lua function that is called instead of the right-hand side.
---@field replace_keycodes boolean? - If setting "expr" to true, replacement of keycodes in the resulting string.
---@field silent boolean? - Suppresses output during the mapping.
---@field expr boolean? - Allows for expression mappings.
---@field remap boolean? - Allows for remapping to previously set keys.
---@field nowait boolean? - Prevents waiting for further key presses in multi-key sequences.
---@field script boolean? - Allows for script mappings count.

---@class UserCommandFnArgs
---@field name string Command name
---@field args string The args passed to the command, if any
---@field fargs table The args split by unescaped whitespace
---@field nargs string Number of arguments
---@field bang boolean "true" if the command was executed with a ! modifier
---@field line1 number The starting line of the command range
---@field line2 number The final line of the command range
---@field range number The number of items in the command range: 0, 1, or 2
---@field count number Any count supplied
---@field reg string The optional register, if specified
---@field mods string Command modifiers, if any
---@field smods table Command modifiers in a structured format

---@class UserCommandOpts See the `opts` used: "h nvim_create_user_command()"
---@field [1] string Command - The name/label for this command. User commands MUST be capitalized. You MAY optionally include a ":" (colon) prefix.
---@field [2] string|fun(UserCommandFnArgs) Replacement command to execute when this user command is executed.
---@field desc string? - A human-readable description for the command.
---@field force boolean? - Override any previous definition (defaults true)
---@field nargs string|number? - Number of arguments allowed ('0', '1', '*', '?', or '+').
---@field complete string? - Completion behavior for arguments (e.g., 'file', 'buffer', 'custom').
---@field range string? - Specifies range behavior ('', '!', '%', 'N').
---@field count boolean? - Indicates if command can take a count.
---@field bang boolean? - Indicates if command accepts a '!' modifier.
---@field bar boolean? - Indicates if the command can be followed by a pipe '|'.
---@field register boolean? - Indicates if the command can take an optional register name.
---@field buffer boolean? - Indicates if the command is buffer-local.
---@field keepscript boolean? - Do not show location of command definition in error messages.
---@field preview function? - Preview function for incremental preview feature.
---@field addr string? - Specifies the kind of address the command can take (e.g., 'lines', 'arguments').
---@field custom_args boolean? - For using <f-args> to pass command arguments to function.
---@field custom_quoting boolean? - For using <q-args> to handle quoted arguments.

---@class NCAutocmd
---@field events string|string[]
---@field pattern string|string[]|nil
---@field callback fun()|nil
---@field command string|nil
---@field group string|nil
---@field opts table|nil

---@class ConfigMap
---@field keymaps? KeymapOpts[]|fun():KeymapOpts[]
---@field commands? UserCommandOpts[]|fun():UserCommandOpts[]
---@field autocmds? NCAutocmd[]|fun():NCAutocmd[]

return {}
