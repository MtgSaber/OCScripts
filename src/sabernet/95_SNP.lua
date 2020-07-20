--[[
Boot script for SaberNet hosts
-------------------------------------------------------------------
Author: Andrew Arnold
Date: 7/18/2020
]]--

local snp = {}

-- functions for API calls

function snp.send(target, remotePort, localPort, data)

end

function snp.isConnected()

end

function snp.setPreferredAddress(hostAddr)

end

function snp.deletePreferredAddress()

end

function snp.connect()

end

function snp.disconnect()

end

function snp.getHostAddress()

end

function snp.emptyDNSCache()

end

function snp.emptyRARPCache()

end

function snp.getRouterAddress()

end

function snp.dnsLookup(siteName)

end

function snp.rarpLookup(snpAddr)

end

function snp.listen(port, timeout)

end

-- register API signal listeners
local event = require("event")
for key, val in pairs(snp) do
    event.listen("snpq_"..key, val)
end

-- create aliases
local modem = require("component").modem
snp.bind = modem.bind
snp.unbind = modem.unbind


-- create semaphores
snp.dnsSem, snp.rarpSem, snp.hostInfoSem, snp.fragTableSem = 0

-- create driver constants
snp.FRAGMENT_WAIT_TIME = 30

-- set up Tx & Rx queues
local deqlib = require("Dequeue")
snp.txQueue = deqlib:new()
snp.rxQueues = {}
deqlib = nil

-- set up Rx packet fragments table
snp.fragments = {}

-- set up Rx modem listener
event.listen("modem_message", function(loc, rem, locport, dist, protocol, fragmux, transmux, addrmux, data)
    if protocol=="SNP01" and type(fragmux)=="number" and type(transmux)=="number" and type(addrmux)=="number" then
        -- demux fragmentation data
        local id = math.floor(fragmux/0x100000000)
        fragmux = fragmux % 0x100000000
        local packetNum = math.floor(fragmux/0x1000000)
        fragmux = fragmux % 0x1000000
        local packetQTY, datatype = math.floor(fragmux/0x10000), fragmux % 0x10000

        -- demux transport data
        local service = math.floor(transmux/0x100000000)
        transmux = transmux % 0x100000000
        local rxPort, txPort = math.floor(transmux/0x10000), transmux % 0x10000

        -- demux address data
        local rxNet = math.floor(addrmux/0x1000000000)
        addrmux = addrmux % 0x1000000000
        local rxHost = math.floor(addrmux/0x1000000)
        addrmux = addrmux % 0x1000000
        local txNet, txHost = math.floor(addrmux/0x1000), addrmux % 0x1000

        local computer = require("computer")

        local isNotSingleFragment = packetQTY > 1
        -- if more than one fragment,
        if isNotSingleFragment then
            -- assert that data is string type
            if type(data) ~= "string" then return end

            -- wait for the fragmentation table maintenance thread to finish its work
            while _G._SNP.fragTableSem > 0 do os.sleep(.25) end
            -- block fragmentation table maintenance thread
            _G._SNP.fragTableSem = 1

            -- add fragment
            if packetNum == 1 then
                _G._SNP.fragments[id] = {
                    deadline=computer.uptime()+_G._SNP.FRAGMENT_WAIT_TIME,

                    packetQTY = packetQTY,
                    packetNum = packetNum,
                    datatype = datatype,

                    service = service,
                    rxPort = rxPort,
                    txPort = txPort,

                    rxNet = rxNet,
                    rxHost = rxHost,
                    txNet = txNet,
                    txHost = txHost,

                    data = data
                }
            else
                if _G._SNP.fragments[id] then
                    _G._SNP.fragments[id].data = _G._SNP.fragments[id].data .. data
                else
                    _G._SNP.fragTableSem = 0
                    return
                end
            end
        end

        -- if this is the final fragment,
        if packetNum == packetQTY then
            -- build full packet
            local packet = {}
            if packetQTY == 1 then
                packet.packetQTY = packetQTY
                packet.datatype = datatype
                packet.service = service

                packet.rxPort = rxPort
                packet.txPort = txPort

                packet.rxNet = rxNet
                packet.rxHost = rxHost
                packet.txNet = txNet
                packet.txHost = txHost

                packet.data = data
                packet.id = id
            else
                packet = _G._SNP.fragments[id]
                packet.id = id
                packet.packetNum = nil
                packet.deadline = nil
            end
            -- push the packet to whoever is listening for it
            computer.pushSignal("snp_packet_rx_port="..packet.rxPort, packet)
        end
        -- unblock fragmentation table maintenance thread if needed
        if isNotSingleFragment then _G._SNP.fragTableSem = 0 end
    end
end)

-- main loop for Tx thread
local function txLoop()

end

-- main loop for fragmentation table maintenance thread
local function fragTableMaintenanceLoop()

end


_G._SNP = snp
