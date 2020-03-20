--[[
Dynamic Double-Ended Queue Implementation
-----------------------------------------
Author: Andrew Arnold
Date: 3/17/2020
]]--

local nodeFactory = require("DoubleLinkedListNode")

local factory = {ERR_EMPTY={message="Error - Empty List"}}

function factory:pushLeft(data)
    if ~self._head then
        self._head = nodeFactory:new(data, nil, nil)
        self._tail = self._head
        self._size = 1
    else
        self._head = nodeFactory:new(data, nil, self._head)
        self._size = self._size + 1
    end
end

function factory:pushRight(data)
    if ~self._tail then
        self._head = nodeFactory:new(data, nil, nil)
        self._tail = self._head
        self._size = 1
    else
        self._tail = nodeFactory:new(data, self._tail, nil)
        self._size = self._size + 1
    end
end

function factory:popLeft()
    if ~self._head then
        return self.ERR_EMPTY
    else
        val = self._head.data
        old = self._head
        self._head = self._head.next
        old = nil
        self._size = self._size - 1
        return val
    end
end

function factory:popRight()
    if ~self._tail then
        return self.ERR_EMPTY
    else
        val = self._tail.data
        old = self._tail
        self._tail = self._tail.prev
        old = nil
        self._size = self._size - 1
        return val
    end
end

function factory:peekLeft()
    if self._head then
        return self._head.data
    else
        return self.ERR_EMPTY
    end
end

function factory.peekRight(dequeue)
    if dequeue._tail then
        return dequeue._tail.data
    else
        return dequeue.ERR_EMPTY
    end
end

function factory.getSize(dequeue)
    return dequeue._size
end

function factory.new(self)
    return {
        pushLeft = self.pushLeft,
        pushRight = self.pushRight,
        popLeft = self.popLeft,
        popRight = self.popRight,
        peekLeft = self.peekLeft,
        peekRight = self.peekRight,
        getSize = self.size,
        new = self.new,
        ERR_EMPTY = self.ERR_EMPTY,
        _size = 0
    }
end

return factory
