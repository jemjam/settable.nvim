# settable.nvim

A small, dependency-free plugin to declare neovim (keymaps, user commands, and
autocmds) that **don't already have a better home elsewhere**.

_The core function is "applying settings" via "lua tables"._ You are "setting"
with "tables". Set-Table. Get it? Everything you define is technically
`settable` too, am I right?

## Inspiration

Neovim is infinitely configurable. There are many methods for applying custom
configuration. If all of your configuration has a better home already, then this
plugin might not be for you.

For example: I use Lazy.nvim as my plugin manager. Using lazy, you define all of
your plugins (along with their config and dependencies) as lua-tables
(essentially big lists). Then the plugin manager handles loading individual
plugin specs asynchronously, and only as required. This pattern keeps config
related to plugins alongside their plugin definitions. Almost everything can be
configured this way, loaded incrementally as required, and can lead to better
performance, at least initially.

But then there are the miscellaneous things: Those custom user keymaps and
commands that don't tie into one specific plugin. IF all of your other config
already lives within a set of plugin specs, where should you place your global
customizations, user maps and commands?

At some point I ran into `legendary.nvim`, which is specifically designed for
creating tables of config that you can then look up easily (like a "legend"). I
used this for awhile before the plugin author ended up deprecating it. In the
deprecation post he describes that he's stopped using it, and found a work
around with (telescope or mini.picker or something) instead. It sounds like his
plugin was concerned with both loading and looking values up.

I already use telesecope and am happy with oher means of looking "stuff up", so
I didn't care about the "display" part of legendary. BUT -- I was still
attracted to the idea of creating config easily in one big table...

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
