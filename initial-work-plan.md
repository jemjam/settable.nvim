# ConfigMap.nvim — Initial Work Plan

## Objective

Provide a minimal, dependency-free Neovim Lua module (`ConfigMap`) that makes it convenient to declare and create keymaps, user commands, functions, and autocmds from a static configuration table. The module should be tiny, predictable, and easy to use from lazy.nvim plugin specs.

## Scope & Constraints

- No UI integrations (which-key, telescope, etc.).
- No external runtime dependencies.
- Support `keymaps`, `commands`, `funcs`, `autocmds` via a single `setup(opts)` entrypoint.
- `setup` accepts either a table or a function returning a table.
- Keep APIs minimal and idiomatic for Neovim users.
- Provide EmmyLua types and a standard `:help` document.

## Deliverables (v0.1 Minimum Viable Product)

- `lua/ConfigMap/init.lua` — main module with `setup(opts)` and lightweight stubs for the apply helpers.
- `lua/ConfigMap/types.lua` — EmmyLua typedefs for editor completion.
- `doc/ConfigMap.txt` — standard Neovim help file with quick usage and Lazy.nvim snippet.
- `README.md` — short overview and example usage.
- `initial-work-plan.md` — this file.

These should be small, well-commented, and intentionally conservative in scope.

## Milestones & Phases

Phase 1 — Placeholders & Docs (this phase)
- Create placeholder module with `setup` stub and TODOs for each helper.
- Add EmmyLua types file with clear type definitions.
- Add `doc/ConfigMap.txt` help file containing synopsis and a Lazy.nvim example.
- Add short README with usage snippet.
- Goal: land minimal files so other changes can be incremental and reviewable.

Phase 2 — Core Implementation
- Implement `normalize_config(raw)` to accept table or function, apply `defaults` merging.
- Implement `apply_keymaps(list)` using `vim.keymap.set` with support for `mode`, `lhs`, `rhs`, `opts`, `desc`, and `buffer`.
- Implement `apply_commands(list)` using `vim.api.nvim_create_user_command` with support for `nargs`, `bang`, `range`, `complete`, `desc`.
- Implement `apply_autocmds(list)` using `vim.api.nvim_create_augroup` + `vim.api.nvim_create_autocmd`.
- Implement `apply_funcs(list)` which will simply execute registration where necessary (no runtime exposure).
- Add a small `validate_item(item, kind)` helper for robust error messages.
- Goal: feature parity with the minimal behaviour described in the README.

Phase 3 — Examples & Tests
- Add example `lua` config files, and at least one integration example for `lazy.nvim` using `opts` + `config = function(_, opts) require('ConfigMap').setup(opts) end`.
- Add simple unit-style tests (e.g., using busted or plain `luassert` if available) to validate normalization and that correct Neovim APIs would be called. If repository policy prohibits adding test infra, include manual test instructions in the README.
- Goal: provide reproducible examples and basic automated validation.

Phase 4 — Polish & Release
- Finalize README, help doc, and license (MIT by default).
- Add CHANGELOG and release tag (v0.1.0) when ready.
- Optional: add CI for linting/formatting if requested.

## File Map (initial)

- `lua/ConfigMap/init.lua` — implementation entrypoint + TODO stubs.
- `lua/ConfigMap/types.lua` — EmmyLua annotations.
- `doc/ConfigMap.txt` — Neovim help doc.
- `README.md` — short usage guide and examples.
- `initial-work-plan.md` — this file.

## API Sketch

`require('ConfigMap').setup(opts)`
- `opts` can be a table or a function returning a table.
- Top-level keys in `opts`:
  - `keymaps` = array of Keymap entries
  - `commands` = array of Command entries
  - `funcs` = array of Func entries
  - `autocmds` = array of Autocmd entries
  - `defaults` = table with per-kind defaults e.g. `{ keymaps = { silent = true, noremap = true } }`

Keymap entry (example, `vim.keymap.set` array form):
```
{ 'n', '<leader>ff', ':Telescope find_files<CR>', { desc = 'Find files', silent = true } }
```
Command entry (example):
```
{ name = 'SayHello', handler = function() print('hello') end, opts = { desc = 'Say hello', nargs = 0 } }
```
Autocmd entry (example):
```
{ events = 'BufWritePre', pattern = '*', callback = function() vim.lsp.buf.format() end, opts = { once = false } }
```
Func entry (example):
```
{ name = 'DoThing', fn = function() ... end }
```

Notes: `funcs` are simply registered/validated at setup time; no global exposure by default.

## Testing & Validation

- Manual test plan (quick):
  1. Use a local Neovim instance and a minimal `init.lua` requiring this module.
  2. Provide `opts` via a `lazy.nvim`-style spec (preferred) or pass the same `opts` table to `require('ConfigMap').setup(opts)` if used directly.
  3. Verify mappings, commands, and autocmds exist using `:map`, `:command`, and `:au`.
- Automated tests: add tests for `normalize_config` and helpers; mock Neovim APIs if necessary.

## Acceptance Criteria

- `setup` accepts `opts` (table or fn) and runs without runtime errors in a standard Neovim (0.8+) environment.
- `keymaps`, `commands`, `autocmds`, and `funcs` are parsed and applied according to the API sketch.
- Docs and examples demonstrate Lazy.nvim usage using `opts` and explicit `config` function.

## Risks & Open Questions

- Buffer-local behavior and numeric buffer IDs — start with `buffer = true` boolean, extend if required.
- Neovim API compatibility for older versions (we assume >= 0.7 where `nvim_create_user_command` and `vim.keymap.set` are available). Add compatibility shims if needed.

## Contribution & Workflow Notes

- Make minimal, incremental PRs. Start with Phase 1 placeholders and docs.
- Keep code small and well-commented; follow existing repo style.
- Avoid adding test infra unless necessary; prefer small, easily-reviewable changes.

---

This plan is intentionally conservative: implement the smallest useful surface first, then iterate. The next actionable item is Phase 1 (placeholders + docs). The repository now contains `initial-work-plan.md` describing the above steps and priorities.
