--- NetDrone [MtgSaber, 20.02.14]
local cmdMsgType="drone_cmd"
local retMsgType="drone_rsp"
local my_id="HAL"
local cmdPort=420
local retPort=421
local modem=component.proxy(component.list("modem")())
modem.open(cmdPort)
modem.open(retPort)
computer.beep(293.66)
computer.beep(293.66)
computer.beep(587.33)
computer.beep(440)
while true do
local name,_,remdAdr,_,_,type,id,funcStr=computer.pullSignal()
if name=="modem_message"and type==cmdMsgType and id==my_id then
local f = load(funcStr)
local ret = f()
modem.send(remdAdr,retPort,ret)
end
end
