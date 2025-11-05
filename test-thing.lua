local function splitTableProperties(inputTable)
	local arrayProperties = {}
	local objectProperties = {}

	for key, value in pairs(inputTable) do
		if type(key) == "number" then
			-- If the key is a number, it belongs to the array
			table.insert(arrayProperties, value)
		else
			-- Otherwise, it is a named property
			objectProperties[key] = value
		end
	end

	return arrayProperties, objectProperties
end

-- Example usage:
local exampleTable = {
	"fourth", -- index 2, this goes to arrayProperties
	"first", -- index 1, this goes to arrayProperties
	"second", -- index 2, this goes to arrayProperties
	a = 42, -- named property a
	b = "test", -- named property b
	"third", -- index 2, this goes to arrayProperties
	c = "pizza", -- named property b
}

for i, v in pairs(exampleTable) do
	print(i, v)
end

local arrayProps, objectProps = splitTableProperties(exampleTable)

-- To inspect the results:
print("Array Properties:")
for i, v in ipairs(arrayProps) do
	print(i, v)
end

print("Object Properties:")
for k, v in pairs(objectProps) do
	print(k, v)
end
