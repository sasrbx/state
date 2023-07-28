--!strict

local Types = require(script.Parent.Parent.Types)

type IsNot<T> = Types.IsNot<T>

local IsNot = {}

function IsNot.Process<T>(wrappedValues: IsNot<T>, notExpectedValues: { T }): boolean
    for index: number, value: T in wrappedValues.Values do
        if notExpectedValues[index] == nil then
            return false
        end

        if value == notExpectedValues[index] then
            return false
        end
    end

    return true
end

return IsNot
