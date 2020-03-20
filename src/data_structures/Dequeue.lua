--[[
Dynamic Double-Ended Queue Implementation
-----------------------------------------
Author: Andrew Arnold
Date: 3/17/2020
]]--

local nodeFactory = require("DoubleLinkedListNode")

local factory = {ERR_EMPTY={message="Error - Empty List"}}

function factory.pushLeft(dequeue, data)
    if ~dequeue._head then
        dequeue._head = node(data, nil, nil)
        dequeue._tail = dequeue._head
        dequeue._size = 1
    else
        dequeue._head = node(data, nil, dequeue._head)
        dequeue._size = dequeue._size + 1
    end
end

function factory.pushRight(dequeue, data)
    if ~dequeue._tail then
        dequeue._head = node(data, nil, nil)
        dequeue._tail = dequeue._head
        dequeue._size = 1
    else
        dequeue._tail = node(data, dequeue._tail, nil)
        dequeue._size = dequeue._size + 1
    end
end

function factory.popLeft(dequeue)
    if ~dequeue._head then
        return dequeue.ERR_EMPTY
    else
        val = dequeue._head.data
        old = dequeue._head
        dequeue._head = dequeue._head.next
        old = nil
        dequeue._size = dequeue._size - 1
        return val
    end
end

function factory.popRight(dequeue)
    if ~dequeue._tail then
        return dequeue.ERR_EMPTY
    else
        val = dequeue._tail.data
        old = dequeue._tail
        dequeue._tail = dequeue._tail.prev
        old = nil
        dequeue._size = dequeue._size - 1
        return val
    end
end

function factory.peekLeft(dequeue)
    if dequeue._head then
        return dequeue._head.data
    else
        return dequeue.ERR_EMPTY
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
