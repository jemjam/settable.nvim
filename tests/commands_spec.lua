local commands = require("settable.commands")
local stub = require("luassert.stub")

describe("commands", function()
	describe("apply_commands", function()
		it("should create basic command with string handler", function()
			local test_commands = {
				{ "TestCommand", "echo 'test'", desc = "test command" },
			}

			stub(vim.api, "nvim_create_user_command")

			commands.apply_commands(test_commands)

			assert.stub(vim.api.nvim_create_user_command).was_called_with(
				"TestCommand",
				"echo 'test'",
				{ desc = "test command" }
			)

			vim.api.nvim_create_user_command:revert()
		end)

		it("should create command with function handler", function()
			local test_commands = {
				{ "TestFunc", function() print("test") end, desc = "function command" },
			}

			stub(vim.api, "nvim_create_user_command")

			commands.apply_commands(test_commands)

			assert.stub(vim.api.nvim_create_user_command).was_called_with(
				"TestFunc",
				test_commands[1][2],
				{ desc = "function command" }
			)

			vim.api.nvim_create_user_command:revert()
		end)

		it("should handle command with options", function()
			local test_commands = {
				{ "ComplexCmd", "echo 'complex'", desc = "complex command", nargs = "*" },
			}

			stub(vim.api, "nvim_create_user_command")

			commands.apply_commands(test_commands)

			assert.stub(vim.api.nvim_create_user_command).was_called_with(
				"ComplexCmd",
				"echo 'complex'",
				{ desc = "complex command", nargs = "*" }
			)

			vim.api.nvim_create_user_command:revert()
		end)

		it("should normalize command name by removing leading colon", function()
			local test_commands = {
				{ ":ColonCmd", "echo 'colon'", desc = "colon command" },
			}

			stub(vim.api, "nvim_create_user_command")

			commands.apply_commands(test_commands)

			assert.stub(vim.api.nvim_create_user_command).was_called_with(
				"ColonCmd",
				"echo 'colon'",
				{ desc = "colon command" }
			)

			vim.api.nvim_create_user_command:revert()
		end)

		it("should error on duplicate command names", function()
			local test_commands = {
				{ "DuplicateCmd", "echo 'first'", desc = "first command" },
				{ "DuplicateCmd", "echo 'second'", desc = "second command" },
			}

			assert.has_error(function()
				commands.apply_commands(test_commands)
			end, "settable: duplicate command name: DuplicateCmd")
		end)

		it("should error when command entry is not a table", function()
			local test_commands = {
				"not a table",
			}

			assert.has_error(function()
				commands.apply_commands(test_commands)
			end, "settable: command entry must be a table")
		end)

		it("should error when command name is missing", function()
			local test_commands = {
				{ [2] = "echo 'test'", desc = "missing name" },
			}

			assert.has_error(function()
				commands.apply_commands(test_commands)
			end)
		end)

		it("should error when command handler is missing", function()
			local test_commands = {
				{ "MissingHandler", desc = "no handler" },
			}

			assert.has_error(function()
				commands.apply_commands(test_commands)
			end, "settable: command 'MissingHandler' requires a handler (string or function)")
		end)

		it("should handle function-based command list", function()
			local command_func = function()
				return { { "FuncCmd", "echo 'func'", desc = "function command" } }
			end

			stub(vim.api, "nvim_create_user_command")

			commands.apply_commands(command_func)

			assert.stub(vim.api.nvim_create_user_command).was_called_with(
				"FuncCmd",
				"echo 'func'",
				{ desc = "function command" }
			)

			vim.api.nvim_create_user_command:revert()
		end)
	end)
end)