--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Janitor = require(ReplicatedStorage.Packages.Janitor)

export type StateListing<T> = { [string]: T }
export type StateCallback = (isEnabled: boolean) -> ()
export type StateGetter = () -> boolean
export type InstanceState = {
	Attributes: StateListing<any>?,
	Tags: StateListing<boolean>?,
	Properties: StateListing<any>?,
}

export type StateProcessor = { [Instance]: InstanceState }

export type Processor<ValueType, T> = {
	__Type: "Processor",
    StateType: ValueType,
    Values: { T }
}

export type Is<T> = Processor<"Is", T>
export type IsNot<T> = Processor<"IsNot", T>

-- All comparison wrappers should only work for types that are comparable
export type Comparable = number | string | {
	-- @TODO: there is no good way to check if a table has valid metamethods with the current state of typed Luau :(
	__eq: (self: Comparable, v: any) -> boolean,
	__lt: (self: Comparable, v: any) -> boolean,
	__le: (self: Comparable, v: any) -> boolean,
}

export type IsGreaterThan = Processor<"IsGreaterThan", Comparable>
export type IsGreaterThanOrEqual = Processor<"IsGreaterThanOrEqual", Comparable>
export type IsLessThan = Processor<"IsLessThan", Comparable>
export type IsLessThanOrEqual = Processor<"IsLessThanOrEqual", Comparable>

export type State = {
	Get: (self: State) -> boolean,
	Connect: (self: State, stateCallback: StateCallback) -> Janitor.Janitor,
	Destroy: (self: State) -> (),

	_stateProcessor: StateProcessor,
	_janitor: Janitor.Janitor,
}

return {}
