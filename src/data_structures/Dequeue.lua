--[[
Dynamic Double-Ended Queue Implementation
-----------------------------------------
Author: Andrew Arnold
Date: 3/17/2020
]]--

local node = require("DoubleLinkedNode")

local dequeue = { ERR_EMPTY={ message="Error - Empty List"}}

function dequeue:pushLeft(data)
    if not self._head then
        self._head = node:new(data, nil, nil)
        self._tail = self._head
        self._size = 1
    else
        self._head = node:new(data, nil, self._head)
        self._head.next.prev = self._head
        self._size = self._size + 1
    end
end

function dequeue:pushRight(data)
    if not self._tail then
        self._head = node:new(data, nil, nil)
        self._tail = self._head
        self._size = 1
    else
        self._tail = node:new(data, self._tail, nil)
        self._tail.prev.next = self._tail
        self._size = self._size + 1
    end
end

function dequeue:popLeft()
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

function dequeue:popRight()
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

function dequeue:peekLeft()
    if self._head then
        return self._head.data
    else
        return self.ERR_EMPTY
    end
end

function dequeue:peekRight()
    if self._tail then
        return self._tail.data
    else
        return self.ERR_EMPTY
    end
end

function dequeue:getSize()
    return self._size
end

function dequeue:new()
    return {
        pushLeft = self.pushLeft,
        pushRight = self.pushRight,
        popLeft = self.popLeft,
        popRight = self.popRight,
        peekLeft = self.peekLeft,
        peekRight = self.peekRight,
        getSize = self.getSize,
        new = self.new,
        ERR_EMPTY = self.ERR_EMPTY,
        _size = 0
    }
end

return dequeue
