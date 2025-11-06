-- Example Lazy.nvim spec showing recommended usage
return {
	"jemjam/settable.nvim",
	---@module 'settable'
	---@type settable
	opts = {
		keymaps = {
			{ "<leader>ff", ":Telescope find_files<CR>", desc = "Find files" },
			{ "<leader>p", ":Telescope live_grep<CR>", desc = "Live grep", mode = { "n", "v" } },
		},
		commands = {
			{
				"SayHello",
				function()
					print("hello from settable")
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
