--!strict

local Types = require(script.Parent.Parent.Types)

type IsGreaterThanOrEqual = Types.IsGreaterThanOrEqual

local IsGreaterThanOrEqual = {}

function IsGreaterThanOrEqual.Process(wrappedValues: IsGreaterThanOrEqual, expectedValues: { number }): boolean
    for index: number, value: number in wrappedValues.Values do
        if expectedValues[index] == nil then
            return false
        end

        if value < expectedValues[index] then
            return false
        end
    end

    return true
end

return IsGreaterThanOrEqual
