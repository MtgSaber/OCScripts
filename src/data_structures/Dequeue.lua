--[[
Dynamic Double-Ended Queue Implementation
-----------------------------------------
Author: Andrew Arnold
Date: 3/17/2020
]]--

local Node = require("DoubleLinkedNode")

local Dequeue = { ERR_EMPTY={ message="Error - Empty List"}}
local metatable = {__index= Dequeue }


function Dequeue:pushLeft(data)
    if not self._head then
        self._head = Node:new(data, nil, nil)
        self._tail = self._head
        self._size = 1
    else
        self._head = Node:new(data, nil, self._head)
        self._head.next.prev = self._head
        self._size = self._size + 1
    end
end

function Dequeue:pushRight(data)
    if not self._tail then
        self._head = Node:new(data, nil, nil)
        self._tail = self._head
        self._size = 1
    else
        self._tail = Node:new(data, self._tail, nil)
        self._tail.prev.next = self._tail
        self._size = self._size + 1
    end
end

function Dequeue:popLeft()
    if not self._head then
        return self.ERR_EMPTY
    else
        local val = self._head.data
        self._head = self._head.next
        if self._head then
            self._head.prev = nil
        else
            self._tail = nil
        end
        self._size = self._size - 1
        return val
    end
end

function Dequeue:popRight()
    if not self._tail then
        return self.ERR_EMPTY
    else
        local val = self._tail.data
        self._tail = self._tail.prev
        if self._tail then
            self._tail.next = nil
        else
            self._head = nil
        end
        self._size = self._size - 1
        return val
    end
end

function Dequeue:peekLeft()
    if self._head then
        return self._head.data
    else
        return self.ERR_EMPTY
    end
end

function Dequeue:peekRight()
    if self._tail then
        return self._tail.data
    else
        return self.ERR_EMPTY
    end
end

function Dequeue:getSize()
    return self._size
end

function Dequeue:new()
    return setmetatable({_size = 0}, metatable)
end

return Dequeue
