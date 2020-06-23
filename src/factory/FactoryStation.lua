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

--[[
    Preconditions:
    - self.job == true

    Postconditions:
    - The job given to this factory station has begun processing
    - The items allocated to this job have been removed from the network
    - The items allocated to this job have been removed from the allocation tracker
    - The items allocated to this job have been inserted into the machine
]]--
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
            factoryState.itemAllocations[allocationID].amount = allocationAmount - ingredientQty
        end
        self.job.active = true
    end
end

--[[
    Preconditions:
    - FactoryStation:start() has been invoked

    Postconditions:
    - The state of the machine has been assessed
    - If the machine has finished its task, this station's job will be marked as completed
]]--
function FactoryStation:update()
    local completed = true
    -- if any input or output slot is not empty, completed = false
    for i=1, #self.job.inputInventorySlots do
        -- TODO: if not empty,
        if (true) then
            completed = false
        end
    end
    for i=1, #self.job.outputInventorySlots do
        -- TODO: if not empty,
        if (true) then
            completed = false
        end
    end
    -- TODO: if all slots are empty,
    -- TODO: then mark job as completed and do appropriate record-keeping
    self.job.completed = true
    self.job.active = false
end
