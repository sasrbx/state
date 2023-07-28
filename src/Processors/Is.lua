--!strict

local Types = require(script.Parent.Parent.Types)

type Is<T> = Types.Is<T>

local Is = {}

function Is.Process<T>(wrappedValues: Is<T>, expectedValues: { T }): boolean
    for index: number, value: T in wrappedValues.Values do
        if expectedValues[index] == nil then
            return false
        end
        
        if value ~= expectedValues[index] then
            return false
        end
    end

    return true
end

return Is
