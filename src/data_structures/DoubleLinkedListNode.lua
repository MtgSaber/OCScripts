--[[
Doubly-Linked List Node Implementation
--------------------------------------
Author: Andrew Arnold
Date: 3/17/2020
]]--

local factory = {}

function factory.new(self, data, prev, next)
    return {
        data = data,
        prev = prev,
        next = next,
        new = self.new
    }
end

return factory
