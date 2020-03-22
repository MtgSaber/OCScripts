--[[
Doubly-Linked List Node Implementation
--------------------------------------
Author: Andrew Arnold
Date: 3/17/2020
]]--

local Node = {}
local metatable = {__index = Node }

function Node:new(data, prev, next)
    return setmetatable(
            { data = data, prev = prev, next = next },
            metatable
    )
end

return Node
