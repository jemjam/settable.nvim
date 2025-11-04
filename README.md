# ConfigMap.nvim

Tiny, dependency-free Neovim helper to declare and create keymaps, user
commands, functions, and autocmds from a static Lua table.

This project is intentionally minimal: it focuses only on mapping configuration
data to Neovim APIs (no UI integrations).

Quick Lazy.nvim example:

```lua
{
  'jemjam/ConfigMap.nvim',
  opts = {
    defaults = { keymaps = { silent = true, noremap = true } },
    keymaps = {
      { 'n', '<leader>ff', ':Telescope find_files<CR>', { desc = 'Find files', silent = true } },
    },
    commands = {
      { name = 'SayHello', handler = function() print('hello') end, opts = { desc = 'Say hello' } },
    },
  },
  config = function(_, opts) require('ConfigMap').setup(opts) end,
}
```

See `doc/ConfigMap.txt` for a short help doc.
