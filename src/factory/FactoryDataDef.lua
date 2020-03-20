--[[
Data definitions for FactoryState.lua
--------------------------------
Author: Andrew Arnold
Date: 3/17/2020
]]--

local api = {}

function api.Recipe(
        id, dbAddress, inputDBIndices,
        inputAmounts, inputInventorySlots,
        maxBatchSize
)
    return {
        id = id,
        dbAddress = dbAddress,
        inputDBIndices = inputDBIndices,
        inputAmounts = inputAmounts,
        inputInventorySlots = inputInventorySlots,
        maxBatchSize = maxBatchSize,
    }
end

function api.Station(id, controllerAddress, busAddress, inventorySide, busSide, supportedRecipes)
    return {
        id = id,
        controllerAddress = controllerAddress,
        busAddress = busAddress,
        inventorySide = inventorySide,
        busSide = busSide,
        supportedRecipes = supportedRecipes
    }
end

function api.Job(id, jobInput, station)
    return {
        id = id,
        input = jobInput,
        station = station,
        completed = false,
        active = false,
    }
end

function api.Request(id, recipe, amount, allocation)
    return {
        id = id,
        recipe = recipe,
        amount = amount,
        allocation = allocation,
        progress = 0
    }
end

function api.JobInput(id, request, amount)
    return {
        id = id,
        request = request,
        amount = amount
    }
end

function api.ItemAllocation(id, dbAddress, dbIndex, amount)
    return {
        id = id,
        dbAddress = dbAddress,
        dbIndex = dbIndex,
        amount = amount,
    }
end

return api
