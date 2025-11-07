# settable.nvim

A small, dependency-free plugin to declare neovim (keymaps, user commands, and
autocmds) that **don't already have a better home elsewhere**.

_The core function is "applying settings" via "lua tables"._ You are "setting"
with "tables". Set-Table. Get it? Everything you define is technically
`settable` too, am I right?

> "If you use lazy.nvim and configure everything via table specs, but need a
> place for global keymaps/commands that don't belong to specific plugins, this
> gives you a consistent table-based approach for those too."

## Installation

Include the plugin using your plugin manager of choice, including your
configuration during setup.

Quick Lazy.nvim example:

```lua
{
    "jemjam/settable.nvim",
    ---@module 'settable'
    ---@type settable
    opts = {
        keymaps = {
            -- Swap ; and : for faster command initiation
            { ";", ":", desc = "Enter command mode", mode = { "n", "v" } },
            { ":", ";", desc = "Repeat f/t motion", mode = { "n", "v" } },

            -- Swap ' and ` for easier precise navigation
            { "'", "`", desc = "Jump to mark (exact position)" },
            { "`", "'", desc = "Jump to mark (line)" },

            -- Speed up single line scrolling
            { "<C-e>", "4<C-e>", desc = "Scroll down faster" },
            { "<C-y>", "4<C-y>", desc = "Scroll up faster" },
        },
        commands = {
            {
                "SayHello",
                function()
                    vim.notify("Hello there!")
                end,
                opts = { desc = "Say hello" },
            },
        },
    },
},
```

See `doc/settable.txt` for a short help doc.

## Inspiration

Defining settings as data (lua tables) rather than scattered function calls has
several benefits: they're easier to inspect and modify, provide a single source
of truth, and enable better composability and tooling.

If you already configure plugins declaratively (e.g., with lazy.nvim), this
provides consistency in the way you also define your global keymaps, commands,
and autocmds that don't belong to specific plugins.

Imperative configuration in other spaces using `vim.keymap.set()` and related
functions is always valid too – this plugin simply offers an alternate approach
for folks preferring to keep their configuration declarative.

Hat tip to `legendary.nvim` which inspired putting all of these misc settings
into one big _legend_. That plugins deprecation prompted initial development of
this plugin.
