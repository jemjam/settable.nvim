local autocmds = require("settable.autocmds")
local stub = require("luassert.stub")

-- Test constants
local TEST_GROUP_ID = 12345
local TEST_ALT_GROUP_ID = 67890
local TEST_BUFFER_ID = 42

describe("autocmds", function()
	local teardown

	before_each(function()
		teardown = {}
	end)

	after_each(function()
		for _, stub_fn in ipairs(teardown) do
			stub_fn:revert()
		end
		teardown = {}
	end)

	describe("ensure_augroup", function()
		it("should create augroup with clear option", function()
			local augroup_stub = stub(vim.api, "nvim_create_augroup").returns(TEST_GROUP_ID)
			table.insert(teardown, augroup_stub)

			local group_id = autocmds.ensure_augroup("TestGroup", true)

			assert.stub(augroup_stub).was_called_with("TestGroup", { clear = true })
			assert.are.equal(group_id, TEST_GROUP_ID)
		end)

		it("should create augroup without clear option", function()
			local augroup_stub = stub(vim.api, "nvim_create_augroup").returns(TEST_ALT_GROUP_ID)
			table.insert(teardown, augroup_stub)

			local group_id = autocmds.ensure_augroup("TestGroup", false)

			assert.stub(augroup_stub).was_called_with("TestGroup", { clear = false })
			assert.are.equal(group_id, TEST_ALT_GROUP_ID)
		end)

		it("should return nil when name is nil", function()
			local group_id = autocmds.ensure_augroup(nil, true)
			assert.is_nil(group_id)
		end)
	end)

	describe("apply_autocmds", function()
		it("should create basic autocmd with callback function", function()
			local test_autocmds = {
				{
					events = "BufWrite",
					callback = function() print("buffer written") end,
					desc = "test autocmd",
				},
			}

			local autocmd_stub = stub(vim.api, "nvim_create_autocmd")
			table.insert(teardown, autocmd_stub)

			autocmds.apply_autocmds(test_autocmds)

			assert.stub(autocmd_stub).was_called_with(
				{ "BufWrite" },
				{
					pattern = "*",
					group = nil,
					callback = test_autocmds[1].callback,
					command = nil,
					once = nil,
					nested = nil,
					buffer = nil,
				}
			)
		end)

		it("should create autocmd with command string", function()
			local test_autocmds = {
				{
					events = "BufEnter",
					command = "echo 'buffer entered'",
					desc = "command autocmd",
				},
			}

			stub(vim.api, "nvim_create_autocmd")

			autocmds.apply_autocmds(test_autocmds)

			assert.stub(vim.api.nvim_create_autocmd).was_called_with(
				{ "BufEnter" },
				{
					pattern = "*",
					group = nil,
					callback = nil,
					command = "echo 'buffer entered'",
					once = nil,
					nested = nil,
					buffer = nil,
				}
			)

			vim.api.nvim_create_autocmd:revert()
		end)

		it("should handle multiple events", function()
			local test_autocmds = {
				{
					events = { "BufRead", "BufNewFile" },
					callback = function() print("file read") end,
					desc = "multi-event autocmd",
				},
			}

			stub(vim.api, "nvim_create_autocmd")

			autocmds.apply_autocmds(test_autocmds)

			assert.stub(vim.api.nvim_create_autocmd).was_called_with(
				{ "BufRead", "BufNewFile" },
				{
					pattern = "*",
					group = nil,
					callback = test_autocmds[1].callback,
					command = nil,
					once = nil,
					nested = nil,
					buffer = nil,
				}
			)

			vim.api.nvim_create_autocmd:revert()
		end)

		it("should handle pattern matching", function()
			local test_autocmds = {
				{
					events = "BufWrite",
					callback = function() print("lua file written") end,
					pattern = "*.lua",
					desc = "lua file autocmd",
				},
			}

			stub(vim.api, "nvim_create_autocmd")

			autocmds.apply_autocmds(test_autocmds)

			assert.stub(vim.api.nvim_create_autocmd).was_called_with(
				{ "BufWrite" },
				{
					pattern = "*.lua",
					group = nil,
					callback = test_autocmds[1].callback,
					command = nil,
					once = nil,
					nested = nil,
					buffer = nil,
				}
			)

			vim.api.nvim_create_autocmd:revert()
		end)

		it("should handle group assignment and creation", function()
			local test_autocmds = {
				{
					events = "BufEnter",
					callback = function() print("group test") end,
					group = "TestGroup",
					desc = "group autocmd",
				},
			}

			local autocmd_stub = stub(vim.api, "nvim_create_autocmd")
			local augroup_stub = stub(vim.api, "nvim_create_augroup").returns(TEST_GROUP_ID)
			table.insert(teardown, autocmd_stub)
			table.insert(teardown, augroup_stub)

			autocmds.apply_autocmds(test_autocmds)

			assert.stub(augroup_stub).was_called_with("TestGroup", { clear = false })
			assert.stub(autocmd_stub).was_called_with(
				{ "BufEnter" },
				{
					pattern = "*",
					group = TEST_GROUP_ID,
					callback = test_autocmds[1].callback,
					command = nil,
					once = nil,
					nested = nil,
					buffer = nil,
				}
			)
		end)

it("should handle buffer-specific autocmds", function()
			local test_autocmds = {
				{
					events = "BufWrite",
					callback = function() print("buffer specific") end,
					opts = { buffer = TEST_BUFFER_ID },
					desc = "buffer autocmd",
				},
			}

			local autocmd_stub = stub(vim.api, "nvim_create_autocmd")
			table.insert(teardown, autocmd_stub)

			autocmds.apply_autocmds(test_autocmds)

			assert.stub(autocmd_stub).was_called_with(
				{ "BufWrite" },
				{
					pattern = "*",
					group = nil,
					callback = test_autocmds[1].callback,
					command = nil,
					once = nil,
					nested = nil,
					buffer = TEST_BUFFER_ID,
				}
			)
		end)

		it("should handle once and nested options", function()
			local test_autocmds = {
				{
					events = "BufEnter",
					callback = function() print("once nested") end,
					opts = { once = true, nested = true },
					desc = "once nested autocmd",
				},
			}

			stub(vim.api, "nvim_create_autocmd")

			autocmds.apply_autocmds(test_autocmds)

			assert.stub(vim.api.nvim_create_autocmd).was_called_with(
				{ "BufEnter" },
				{
					pattern = "*",
					group = nil,
					callback = test_autocmds[1].callback,
					command = nil,
					once = true,
					nested = true,
					buffer = nil,
				}
			)

			vim.api.nvim_create_autocmd:revert()
		end)

		it("should error when events are missing", function()
			local test_autocmds = {
				{
					callback = function() print("no events") end,
					desc = "missing events",
				},
			}

			assert.has_error(function()
				autocmds.apply_autocmds(test_autocmds)
			end, "settable: autocmd entry requires 'events'")
		end)

		it("should error when callback and command are missing", function()
			local test_autocmds = {
				{
					events = "BufEnter",
					desc = "missing callback",
				},
			}

			assert.has_error(function()
				autocmds.apply_autocmds(test_autocmds)
			end, "settable: autocmd requires 'callback' or 'command'")
		end)

		it("should error when autocmd entry is not a table", function()
			local test_autocmds = {
				"not a table",
			}

			assert.has_error(function()
				autocmds.apply_autocmds(test_autocmds)
			end, "settable: autocmd entry must be a table")
		end)

		it("should handle function-based autocmds", function()
			local autocmd_func = function()
				return {
					{
						events = "BufWrite",
						callback = function() print("function autocmd") end,
						desc = "function-based autocmd",
					},
				}
			end

			stub(vim.api, "nvim_create_autocmd")

			autocmds.apply_autocmds(autocmd_func)

			-- Just verify the function was called
			assert.stub(vim.api.nvim_create_autocmd).was_called()

			vim.api.nvim_create_autocmd:revert()
		end)
	end)
end)