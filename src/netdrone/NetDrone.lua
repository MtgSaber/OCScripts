--[[
    Author: MtgSaber
    Date: 2/14/2020

    my_id should be unique for each drone.

    When broadcasting, the format is:
        cmdPort, cmdMsgType, my_id, FUNC_BODY_STR

        * where FUNC_BODY_STR is the body of the function you wish
          to run, but in the form of a string.
          Effectively sending source code.

        An example is:
            modem.broadcast(123, "drone_cmd", "Bob", "computer.beep() return \"Success!\"")
]]--

--- configurable fields
local cmdMsgType = "drone_cmd"
local retMsgType = "drone_rsp"
local my_id = "Bob"
local cmdPort = 123
local retPort = 321

--- init
local modem = component.proxy(component.list("modem")())
modem.open(cmdPort)
modem.open(retPort)

--- main loop
while true do
    -- pull the next signal
    local name, _, remdAdr, _, _, type, id, funcStr = computer.pullSignal()

    -- if this was from a the network card, and it is meant for me,
    if name == "modem_message" and type == cmdMsgType and id == my_id then

        -- parse the source code as the body of 'f'
        local f = load(funcStr)

        -- execute the source code and record the result
        local ret = f()

        -- let the sender know what happened
        modem.send(remdAdr, retPort, ret)
    end
end
