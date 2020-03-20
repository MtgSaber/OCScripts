print("~~~ START DEQUEUE TEST ~~~")
print("Requiring library.")
local dequeue = require("Dequeue")

print("Creating new Dequeue 'q1'.")
local q1 = dequeue:new()
print("q1:getSize() -> "..tostring(q1:getSize()))

print("Adding 1-10 into q1 from the left.")
for i = 1, 10 do
    q1:pushLeft(i)
end
print("q1:getSize() -> "..tostring(q1:getSize()))

print("q1 elements, popped from the right:\n{")
while q1:getSize() ~= 0 do
    print("\t"..q1:popRight()..",")
end
print("}")
print("q1:getSize() -> "..tostring(q1:getSize()))

print("Adding 1-10 into q1 from the left.")
for i = 1, 10 do
    q1:pushLeft(i)
end
print("q1:getSize() -> "..tostring(q1:getSize()))

print("q1 elements, popped from the left:\n{")
while q1:getSize() ~= 0 do
    print("\t"..q1:popRight()..",")
end
print("}")
print("q1:getSize() -> "..tostring(q1:getSize()))

