local keymaps = require("settable.keymaps")
local stub = require("luassert.stub")

describe("keymaps", function()
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

	describe("apply_keymaps", function()
		it("should apply a basic keymap", function()
			local test_keymaps = {
				{ "a", "b", desc = "test keymap" },
			}

			local keymap_stub = stub(vim.keymap, "set")
			table.insert(teardown, keymap_stub)

			keymaps.apply_keymaps(test_keymaps)

			assert.stub(keymap_stub).was_called_with({ "n" }, "a", "b", { desc = "test keymap" })
		end)

		it("should apply keymap with multiple modes", function()
			local test_keymaps = {
				{ "c", "d", mode = { "n", "v" }, desc = "multi-mode keymap" },
			}

			stub(vim.keymap, "set")

			keymaps.apply_keymaps(test_keymaps)

			assert.stub(vim.keymap.set).was_called_with({ "n", "v" }, "c", "d", { desc = "multi-mode keymap" })

			vim.keymap.set:revert()
		end)

		it("should handle buffer option correctly", function()
			local test_keymaps = {
				{ "e", "f", buffer = true, desc = "buffer keymap" },
			}

			stub(vim.keymap, "set")

			keymaps.apply_keymaps(test_keymaps)

			-- Buffer true should be converted to 0
			assert.stub(vim.keymap.set).was_called_with({ "n" }, "e", "f", { buffer = 0, desc = "buffer keymap" })

			vim.keymap.set:revert()
		end)

		it("should error on duplicate keymap definitions", function()
			local test_keymaps = {
				{ "g", "h", desc = "first keymap" },
				{ "g", "i", desc = "duplicate keymap" },
			}

			assert.has_error(function()
				keymaps.apply_keymaps(test_keymaps)
			end, "settable: duplicate keymap for mode+lhs: n::g")
		end)

		it("should error on invalid keymap entry type", function()
			local test_keymaps = {
				"not a table",
			}

			assert.has_error(function()
				keymaps.apply_keymaps(test_keymaps)
			end, "settable: keymap entry must be a table: {lhs, rhs, desc?, mode?}")
		end)

		it("should error on incomplete keymap definition", function()
			local test_keymaps = {
				{ "lhs only" },
			}

			assert.has_error(function()
				keymaps.apply_keymaps(test_keymaps)
			end, "settable: keymap entry requires lhs and rhs as first two elements")
		end)
	end)
end)
