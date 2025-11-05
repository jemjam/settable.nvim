# ConfigMap.nvim

Tiny, dependency-free Neovim helper to declare and create keymaps, user
commands, and autocmds from a static Lua table.

This project is intentionally minimal: it focuses only on mapping configuration
data to Neovim APIs (no UI integrations).

Quick Lazy.nvim example:

```lua
{
  'jemjam/ConfigMap.nvim',
  ---@module 'ConfigMap'
  ---@type ConfigMap
  opts = {
    keymaps = {
      { '<leader>ff', ':Telescope find_files<CR>', desc = 'Find files' },
    },
    commands = {
      { 'SayHello', function() print('hello') end, opts = { desc = 'Say hello' } },
    },
  },
}
```

See `doc/ConfigMap.txt` for a short help doc.
