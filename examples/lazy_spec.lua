-- Example Lazy.nvim spec showing recommended usage
return {
	"jemjam/ConfigMap.nvim",
	---@module 'ConfigMap'
	---@type ConfigMap
	opts = {
		keymaps = {
			{ "<leader>ff", ":Telescope find_files<CR>", desc = "Find files" },
			{ "<leader>p", ":Telescope live_grep<CR>", desc = "Live grep", mode = { "n", "v" } },
		},
		commands = {
			{
				"SayHello",
				function()
					print("hello from ConfigMap")
				end,
				opts = { desc = "Say hello" },
			},
		},
		autocmds = {
			{
				events = "BufWritePre",
				pattern = "*",
				callback = function()
					vim.lsp.buf.format()
				end,
				opts = { once = false },
			},
		},
	},
}
