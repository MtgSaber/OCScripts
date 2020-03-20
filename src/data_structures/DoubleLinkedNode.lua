--[[
Doubly-Linked List Node Implementation
--------------------------------------
Author: Andrew Arnold
Date: 3/17/2020
]]--

local node = {}

function node:new(data, prev, next)
    return {
        data = data,
        prev = prev,
        next = next,
        new = self.new
    }
end

return node
