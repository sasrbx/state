--!strict

local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Janitor = require(ReplicatedStorage.Packages.Janitor)
local Processor = require(script.Parent.Processor)
local Types = require(script.Parent.Types)

type Janitor = Janitor.Janitor
type InstanceState = Types.InstanceState
type StateProcessor = Types.StateProcessor
type StateCallback = Types.StateCallback
type StateGetter = Types.StateGetter
type State = Types.State
type Processor<A, B> = Types.Processor<A, B>

local Is = Processor.GetWrapper("Is")

local State = {}
State.__index = State
State.ClassName = "State"

local function areAttributesValid(instance: Instance, instanceState: InstanceState)
    if not instanceState.Attributes then
        return true
    end

    for attributeName: string, expectedValue in instanceState.Attributes do
        if not Processor.Is(expectedValue) then
            expectedValue = Is(expectedValue)
        end

        local isValid = Processor.Process(expectedValue, { instance:GetAttribute(attributeName) })
        if not isValid then
            return false
        end
    end

    return true
end

local function arePropertiesValid(instance: Instance, instanceState: InstanceState)
    if not instanceState.Properties then
        return true
    end

    for propertyName: string, expectedValue in instanceState.Properties do
        if not Processor.Is(expectedValue) then
            expectedValue = Is(expectedValue)
        end

        local isValid = Processor.Process(expectedValue, { instance[propertyName] })
        if not isValid then
            return false
        end
    end

    return true
end

local function areTagsValid(instance: Instance, instanceState: InstanceState)
    if not instanceState.Tags then
        return true
    end

    local clientTagData: Folder? = instance:FindFirstChild("ClientTagData")
    
    -- No need to wrap! Tags are just booleans
    for tagName: string, expectedValue: boolean in instanceState.Tags do
        local isValid = instance:HasTag(tagName) == expectedValue or (clientTagData and clientTagData:HasTag(tagName) == expectedValue)
        if not isValid then
            return false
        end
    end
end

local function process(instance: Instance, instanceState: InstanceState): boolean
    return areAttributesValid(instance, instanceState) and arePropertiesValid(instance, instanceState) and areTagsValid(instance, instanceState)
end

function State.new(stateProcessor: StateProcessor): State
    local self: State = setmetatable({}, State) :: State
    self._stateProcessor = stateProcessor
    self._janitor = Janitor.new()

    return self
end

function State:Get()
    for instance, instanceState in self._stateProcessor do
        local isValid = process(instance, instanceState)
        if not isValid then
         return false
        end
     end

     return true
end

function State:Connect(stateCallback: StateCallback): Janitor
    local stateJanitor: Janitor = self._janitor:Add(Janitor.new())

    local function callStateCallback()
        stateCallback(self:Get())
    end

    for instance, instanceState in self._stateProcessor do
        if instanceState.Attributes then
            for attributeName: string, _ in instanceState.Attributes do
                stateJanitor:Add(instance:GetAttributeChangedSignal(attributeName):Connect(callStateCallback))
            end
        end

        if instanceState.Properties then
            for propertyName: string, _ in instanceState.Properties do
                stateJanitor:Add(instance:GetPropertyChangedSignal(propertyName):Connect(callStateCallback))
            end
        end

        if instanceState.Tags then
            for tagName: string, _ in instanceState.Tags do
                local function callForCorrectInstance(otherInstance: Instance)
                    if otherInstance ~= instance then
                        return
                    end

                    callStateCallback()
                end

                stateJanitor:Add(CollectionService:GetInstanceAddedSignal(tagName):Connect(callForCorrectInstance))
                stateJanitor:Add(CollectionService:GetInstanceRemovedSignal(tagName):Connect(callForCorrectInstance))
            end
        end
    end

    -- Setup initial state
    stateJanitor:Add(task.defer(callStateCallback))

    return stateJanitor
end

function State:Destroy()
    self._janitor:Destroy()
    setmetatable(self, nil)
end

return State.new