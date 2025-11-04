-- Example Lazy.nvim spec showing recommended usage
return {
  'jemjam/ConfigMap.nvim',
  opts = {
    defaults = { keymaps = { silent = true, noremap = true } },
    keymaps = {
      { 'n', '<leader>ff', ':Telescope find_files<CR>', { desc = 'Find files' } },
      { {'n','v'}, '<leader>p', ':Telescope live_grep<CR>', { desc = 'Live grep' } },
    },
    commands = {
      { name = 'SayHello', handler = function() print('hello from ConfigMap') end, opts = { desc = 'Say hello' } },
    },
    autocmds = {
      { events = 'BufWritePre', pattern = '*', callback = function() vim.lsp.buf.format() end, opts = { once = false } },
    },
  },
  config = function(_, opts) require('ConfigMap').setup(opts) end,
}
