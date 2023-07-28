--!strict

local Processor = require(script.Processor)
local Types = require(script.Types)

export type Is<T> = Types.Is<T>
export type IsNot<T> = Types.IsNot<T>
export type IsGreaterThan = Types.IsGreaterThan
export type IsLessThan = Types.IsLessThan
export type IsGreaterThanOrEqual = Types.IsGreaterThanOrEqual
export type IsLessThanOrEqual = Types.IsLessThanOrEqual
export type StateGetter = Types.StateGetter

type Comparable = Types.Comparable

return {
    new = require(script.New),
    Is = Processor.GetWrapper("Is"),
    IsNot = Processor.GetWrapper("IsNot"),  
    IsGreaterThan = Processor.GetWrapper("IsGreaterThan") :: (...Comparable) -> IsGreaterThan,
    IsLessThan = Processor.GetWrapper("IsLessThan") :: (...Comparable) -> IsLessThan,
    IsGreaterThanOrEqual = Processor.GetWrapper("IsGreaterThanOrEqual") :: (...Comparable) -> IsGreaterThanOrEqual,
    IsLessThanOrEqual = Processor.GetWrapper("IsLessThanOrEqual") :: (...Comparable) -> IsLessThanOrEqual,
}
