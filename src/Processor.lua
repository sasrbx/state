--!strict

local Types = require(script.Parent.Types)

type Processor<A, B> = Types.Processor<A, B>

local Processor = {}

function Processor.Is(value: any): boolean
    return typeof(value) == "table" and typeof(value.__Type) == "string" and value.__Type == "Processor"
end

function Processor.GetProcessCallback(value)
    local processorModule: ModuleScript? = script.Parent.Processors:FindFirstChild(value.StateType)
    if not processorModule then
        return false
    end

    local processor = require(processorModule)
    return processor.Process
end

function Processor.GetWrapper<ValueType, T>(valueType: ValueType): (...T) -> (Processor<ValueType, T>)
    return function(...: T): Processor<ValueType, T>
        return {
            __Type = "Processor",
            StateType = valueType,
            Values = { ... },
        }
    end
end

function Processor.Process<ValueType, T>(value: Processor<ValueType, T>, expectedValues: { T }): boolean
    local processorModule: ModuleScript? = script.Parent.Processors:FindFirstChild(value.StateType)
    if not processorModule then
        return false
    end

    local processor = require(processorModule)
    return processor.Process(value, expectedValues)
end

return Processor
