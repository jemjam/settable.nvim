local utils = require("settable.utils")

describe("utils", function()
	describe("splitTableProperties", function()
		it("should partition numeric and string keys", function()
			local input = { "a", "b", key = "value" }
			local array, obj = utils.splitTableProperties(input)
			assert.are.same({ "a", "b" }, array)
			assert.are.same({ key = "value" }, obj)
		end)

		it("should handle empty table", function()
			local input = {}
			local array, obj = utils.splitTableProperties(input)
			assert.are.same({}, array)
			assert.are.same({}, obj)
		end)

		it("should handle only numeric keys", function()
			local input = { "x", "y" }
			local array, obj = utils.splitTableProperties(input)
			assert.are.same({ "x", "y" }, array)
			assert.are.same({}, obj)
		end)

		it("should handle only string keys", function()
			local input = { foo = "bar", baz = "qux" }
			local array, obj = utils.splitTableProperties(input)
			assert.are.same({}, array)
			assert.are.same({ foo = "bar", baz = "qux" }, obj)
		end)
	end)

	describe("resolve_list", function()
		it("should return table as is", function()
			local input = { 1, 2, 3 }
			assert.are.same({ 1, 2, 3 }, utils.resolve_list(input))
		end)

		it("should call function and return result", function()
			local f = function()
				return { 4, 5 }
			end
			assert.are.same({ 4, 5 }, utils.resolve_list(f))
		end)

		it("should return empty table if function returns nil", function()
			local f = function()
				return nil
			end
			assert.are.same({}, utils.resolve_list(f))
		end)

		it("should return empty table if input is nil", function()
			assert.are.same({}, utils.resolve_list(nil))
		end)

		it("should propagate errors from function", function()
			local f = function()
				error("test error")
			end
			assert.has_error(function()
				utils.resolve_list(f)
			end)
		end)
	end)
end)

