--!strict

local Types = require(script.Parent.Parent.Types)

type IsLessThanOrEqual = Types.IsLessThanOrEqual

local IsLessThanOrEqual = {}

function IsLessThanOrEqual.Process(wrappedValues: IsLessThanOrEqual, expectedValues: { number }): boolean
    for index: number, value: number in wrappedValues.Values do
        if expectedValues[index] == nil then
            return false
        end

        if value > expectedValues[index] then
            return false
        end
    end

    return true
end

return IsLessThanOrEqual
