local settable = require("settable")
local stub = require("luassert.stub")

describe("settable", function()
	describe("setup", function()
		it("should handle basic setup with empty configuration", function()
			stub(require("settable.keymaps"), "apply_keymaps")
			stub(require("settable.commands"), "apply_commands")
			stub(require("settable.autocmds"), "apply_autocmds")

			settable.setup({})

			assert.stub(require("settable.keymaps").apply_keymaps).was_called_with({})
			assert.stub(require("settable.commands").apply_commands).was_called_with({})
			assert.stub(require("settable.autocmds").apply_autocmds).was_called_with({})

			require("settable.keymaps").apply_keymaps:revert()
			require("settable.commands").apply_commands:revert()
			require("settable.autocmds").apply_autocmds:revert()
		end)

		it("should setup with keymaps, commands, and autocmds", function()
			local config = {
				keymaps = {
					{ "n", "j", "k", desc = "down" },
				},
				commands = {
					{ "TestCmd", "echo 'test'", desc = "test command" },
				},
				autocmds = {
					{
						events = "BufEnter",
						callback = function() print("entered") end,
						desc = "test autocmd",
					},
				},
			}

			stub(require("settable.keymaps"), "apply_keymaps")
			stub(require("settable.commands"), "apply_commands")
			stub(require("settable.autocmds"), "apply_autocmds")

			settable.setup(config)

			assert.stub(require("settable.keymaps").apply_keymaps).was_called_with(config.keymaps)
			assert.stub(require("settable.commands").apply_commands).was_called_with(config.commands)
			assert.stub(require("settable.autocmds").apply_autocmds).was_called_with(config.autocmds)

			require("settable.keymaps").apply_keymaps:revert()
			require("settable.commands").apply_commands:revert()
			require("settable.autocmds").apply_autocmds:revert()
		end)

		it("should setup with function-based configuration", function()
			local config_func = function()
				return {
					keymaps = {
						{ "n", "k", "j", desc = "up" },
					},
					commands = {
						{ "FuncCmd", "echo 'func'", desc = "function command" },
					},
					autocmds = {
						{
							events = "BufWrite",
							callback = function() print("written") end,
							desc = "function autocmd",
						},
					},
				}
			end

			stub(require("settable.keymaps"), "apply_keymaps")
			stub(require("settable.commands"), "apply_commands")
			stub(require("settable.autocmds"), "apply_autocmds")

			settable.setup(config_func)

			-- Just verify the functions were called, not the exact function references
			assert.stub(require("settable.keymaps").apply_keymaps).was_called()
			assert.stub(require("settable.commands").apply_commands).was_called()
			assert.stub(require("settable.autocmds").apply_autocmds).was_called()

			require("settable.keymaps").apply_keymaps:revert()
			require("settable.commands").apply_commands:revert()
			require("settable.autocmds").apply_autocmds:revert()
		end)

		it("should handle nil configuration", function()
			stub(require("settable.keymaps"), "apply_keymaps")
			stub(require("settable.commands"), "apply_commands")
			stub(require("settable.autocmds"), "apply_autocmds")

			settable.setup(nil)

			assert.stub(require("settable.keymaps").apply_keymaps).was_called_with({})
			assert.stub(require("settable.commands").apply_commands).was_called_with({})
			assert.stub(require("settable.autocmds").apply_autocmds).was_called_with({})

			require("settable.keymaps").apply_keymaps:revert()
			require("settable.commands").apply_commands:revert()
			require("settable.autocmds").apply_autocmds:revert()
		end)

		it("should handle partial configuration with missing sections", function()
			local config = {
				keymaps = {
					{ "n", "l", "h", desc = "right" },
				},
				-- commands and autocmds missing
			}

			stub(require("settable.keymaps"), "apply_keymaps")
			stub(require("settable.commands"), "apply_commands")
			stub(require("settable.autocmds"), "apply_autocmds")

			settable.setup(config)

			assert.stub(require("settable.keymaps").apply_keymaps).was_called_with(config.keymaps)
			assert.stub(require("settable.commands").apply_commands).was_called_with({})
			assert.stub(require("settable.autocmds").apply_autocmds).was_called_with({})

			require("settable.keymaps").apply_keymaps:revert()
			require("settable.commands").apply_commands:revert()
			require("settable.autocmds").apply_autocmds:revert()
		end)

		it("should integrate all modules working together", function()
			local config = {
				keymaps = {
					{ "test", "echo 'test'", desc = "integration test" },
				},
				commands = {
					{ "IntegrationCmd", "echo 'integration'", desc = "integration command" },
				},
				autocmds = {
					{
						events = "BufEnter",
						callback = function() print("integration autocmd") end,
						desc = "integration autocmd",
					},
				},
			}

			-- Mock the actual Neovim API calls
			stub(vim.keymap, "set")
			stub(vim.api, "nvim_create_user_command")
			stub(vim.api, "nvim_create_autocmd")

			settable.setup(config)

			-- Verify all modules were called
			assert.stub(vim.keymap.set).was_called()
			assert.stub(vim.api.nvim_create_user_command).was_called()
			assert.stub(vim.api.nvim_create_autocmd).was_called()

			vim.keymap.set:revert()
			vim.api.nvim_create_user_command:revert()
			vim.api.nvim_create_autocmd:revert()
		end)

		it("should handle function that returns nil", function()
			local nil_func = function()
				return nil
			end

			stub(require("settable.keymaps"), "apply_keymaps")
			stub(require("settable.commands"), "apply_commands")
			stub(require("settable.autocmds"), "apply_autocmds")

			settable.setup(nil_func)

			assert.stub(require("settable.keymaps").apply_keymaps).was_called_with({})
			assert.stub(require("settable.commands").apply_commands).was_called_with({})
			assert.stub(require("settable.autocmds").apply_autocmds).was_called_with({})

			require("settable.keymaps").apply_keymaps:revert()
			require("settable.commands").apply_commands:revert()
			require("settable.autocmds").apply_autocmds:revert()
		end)
	end)
end)