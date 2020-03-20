--[[
Table representing the state of this factory. Provides
methods for state control, to be used in a driver.
------------------------------------------------------
Author: Andrew Arnold
Date: 3/20/2020
]]--

local dequeueFactory = require("Dequeue")
local serial = require("serialization")
local factoryLib = require("FactoryDataDef")

local configPath = ""
local configFile = io.open(configPath, "r")
local config = serial.unserialize(configFile:read())
configFile:close()

-- TODO: do format verification for config
-- TODO: do value verification for config

local factory = {
    config = config,
    requests = {},
    requestCounter = 0,
    dispatchQueue = dequeueFactory:new(),
    dispatchCounter = 0,
    jobCounter = 0,
    stationStates = {},
    itemAllocations = {}
}

local i = 1
for station in pairs(config.stations) do
    factory.stationStates[i] = {station = station}
    i = i+1
end
i = nil

--[[ TOO COMPLEX FOR THIS SCOPE
function factory.canFulfil(self, recipe, amount, rawInputsNeeded)
    -- TODO: determine input qty's for this request
    -- TODO: for each input,
        -- TODO: query item allocations for this recipe's inputs
        -- TODO: check if network has required input amounts after allocations are considered
        -- TODO: if input items unavailable, make recursive call for fallback recipe
        -- TODO: if recursive call comes back as 'true', continue to next input item
        -- TODO: if input items are available, add them to the raw need
            -- TODO: CONSIDER THAT RECURSIVE CALLS MIGHT HAVE REQUESTED THIS ITEM!
        -- TODO: if input items are still unavailable, return nil
    return rawInputsNeeded
end
]]--

function factory:request(recipe, amount)
    -- get qty of input items already in network
    local db = component.proxy(recipe.dbAddress)
    local netItems = component.proxy(self.config.network_interface_address).getItemsInNetwork()
    local networkQtys = {}
    for i=1, #netItems do
        for j=1, #recipe.inputDBIndices do
            if not networkQtys[recipe.inputDBIndices[j]] then
                local netItem = netItems[i]
                local dbItem = db.get(j)
                if netItem.label == dbItem.label
                        and netItem.name == dbItem.name
                        and netItem.damage == dbItem.damage
                then
                    networkQtys[recipe.inputDBIndices[j]] = netItem.amount
                end
            end
        end
    end
    -- garbage
    db = nil
    netItems = nil

    -- query item allocations for this recipe's inputs
    local newAllocations = {}
    for i = 1, #recipe.inputDBIndices do
        local id = recipe.dbAddress.."@"..recipe.inputDBIndices[i]
        newAllocations[id] = factoryLib.ItemAllocation(
                id, recipe.dbAddress, recipe.inputDBIndices[i], recipe.inputAmounts[i]
        )
    end

    -- check if network has required input amounts after allocations are considered
    local deficitCounter = 1
    local deficits = {}
    for id, allocation in pairs(newAllocations) do
        -- if input unavailable, record the amount network is lacking
        if not networkQtys[allocation.dbIndex] then
            deficits[deficitCounter] = allocation
            deficitCounter = deficitCounter + 1
        else
            local available = networkQtys[allocation.dbIndex] - self.itemAllocations[id].amount
            if available < allocation.amount then
                deficits[deficitCounter] = allocation
                allocation.deficit = allocation.amount - available
                deficitCounter = deficitCounter + 1
            end
        end
    end

    -- if any inputs are unavailable, return false and message containing deficit records
    if #deficits ~= 0 then
        return false, deficits
    end

    -- allocate items
    for id, allocation in pairs(newAllocations) do
        if not self.itemAllocations[id] then
            self.itemAllocations[id] = allocation
        else
            self.itemAllocations[id].amount = self.itemAllocations[id].amount + allocation.amount
        end
    end

    -- create requests
    local id = "r_"..recipe.id.."#"..tostring(requestCounter)
    self.requests[id] = factoryLib.Request(id, recipe, amount, newAllocations)
    for i=1, amount // recipe.maxBatchSize do
        self.dispatchQueue:pushLeft(factoryLib.JobInput(id, self.requests[id], recipe.maxBatchSize))
    end
    local rem = amount % recipe.maxBatchSize
    if rem ~= 0 then
        self.dispatchQueue:pushLeft(factoryLib.JobInput(id, self.requests[id], rem))
    end

    return true, newAllocations
end

function factory:dispatch()
    local tempQueue = dequeueFactory:new()
    while true do
        -- if there are no jobs left in the queue, quit.
        if self.dispatchQueue:getSize() == 0 then
            while tempQueue:getSize() ~= 0 do
                self.dispatchQueue:pushRight(tempQueue:popLeft())
            end
            return nil
        end
        tempQueue:pushLeft(self.dispatchQueue:popRight())
        local curRecipe = tempQueue:peekLeft()
        for i=1, #self.stationStates do
            -- if this job can be performed by this station, and the station isn't preoccupied,
            if self.stationStates[i].station.supportedRecipes[curRecipe.id]
                    and not self.stationStates[i].job
            then
                -- Assign this job to the station and remove it from the queue.

            end
        end
    end
end

return factory
