--!strict

local Types = require(script.Parent.Parent.Types)

type IsLessThan = Types.IsLessThan

local IsLessThan = {}

function IsLessThan.Process(wrappedValues: IsLessThan, expectedValues: { number }): boolean
    for index: number, value: number in wrappedValues.Values do
        if expectedValues[index] == nil then
            return false
        end

        if value >= expectedValues[index] then
            return false
        end
    end

    return true
end

return IsLessThan
