--[[
An object representing a single factory station node.
-----------------------------------------------------
Author: Andrew Arnold
Date: 3/21/2020
]]--

local FactoryStation = {}
local metatable = {__index=FactoryStation}

function FactoryStation.new(id, controllerAddress, busAddress, inventorySide, busSide, supportedRecipes, job)
    return setmetatable(
            {
                id = id,
                controllerAddress = controllerAddress,
                busAddress = busAddress,
                inventorySide = inventorySide,
                busSide = busSide,
                supportedRecipes = supportedRecipes,
                job = job
            },
            metatable
    )
end

function FactoryStation.fromDataTable(table)
    return setmetatable(table, metatable)
end

function FactoryStation:start(factoryState)
    if self.job and not self.job.active then
        local bus = component.proxy(self.busAddress)
        local inv = component.proxy(self.controllerAddress)
        local recipe = self.job.jobInput.recipe
        for i=1, #recipe.dbIndices do
            local ingredientQty = recipe.inputAmounts * self.job.jobInput.amount
            -- set bus to export this ingredient
            bus.setExportConfiguration(self.busSide, 5, recipe.dbAddress, recipe.dbIndices[i])
            for j=1, #ingredientQty do
                -- tell bus to make an export operation
                bus.exportIntoSlot(self.busSide, recipe.inputInventorySlots[i])
            end
            local allocationID = recipe.dbAddress.."@"..recipe.dbIndices[i]
            local allocationAmount = factoryState.itemAllocations[allocationID].amount
            factoryState.itemAllocations[allocationID] = allocationAmount - ingredientQty
        end
        self.job.active = true
    end
end

function FactoryStation:checkStatus()
    -- TODO: check each input slot for the machine
    -- TODO: if all slots are empty,
    -- TODO: then mark job as completed and do appropriate record-keeping
end
