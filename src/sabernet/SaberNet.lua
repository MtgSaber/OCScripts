--[[
End-User API for interacting with this host's SaberNet service.
-------------------------------------------------------------------
Author: Andrew Arnold
Date: 7/18/2020
]]--

local api = {_event = require("event")}

function api.send(target, remotePort, localPort, data)
    self._event.push("snpq_send", target, remotePort, localPort, data)
    return event.listen()
end

function api.bind(port)

end

function api.unbind(port)

end

function api.isConnected()

end

function api.setPreferredAddress(hostAddr)

end

function api.deletePreferredAddress()

end

function api.connect()

end

function api.disconnect()

end

function api.getHostAddress()

end

function api.emptyDNSCache()

end

function api.emptyRARPCache()

end

function api.getRouterAddress()

end

function api.dnsLookup(siteName)

end

function api.rarpLookup(snpAddr)

end

function api.listen(port, timeout)

end
