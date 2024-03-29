-- Import JSON module
local json = require("json")

-- Constants
local ORBIT_PROCESS = "WSXUI2JjYUldJ7CKq9wE1MGwXs-ldzlUlHOQszwQe0s"
local COINGECKO_BASE_URL = "https://api.coingecko.com/api/v3/simple/price"

-- Function to send HTTP GET request
local function sendGetRequest(url)
    ao.send({ Target = ORBIT_PROCESS, Action = "Get-Real-Data", Url = url })
end

-- Process when user queries token price
Handlers.add(
    "QueryTokenPrice",
    Handlers.utils.hasMatchingTag("Action", "QueryTokenPrice"),
    function(message)
        local token_symbol = message.Data
        local url = COINGECKO_BASE_URL .. "?ids=" .. token_symbol .. "&vs_currencies=usd"

        -- Send a tip message
        local tipMsg = "You are querying the price of " .. token_symbol .. ", please wait for a moment to get the result"
        ao.send({ Target = message.From, Data = tipMsg })

        -- Query token price
        sendGetRequest(url)
    end
)

-- Process when receiving data feed
Handlers.add(
    "ProcessOrbitReceive",
    Handlers.utils.hasMatchingTag("Action", "Receive-data-feed"),
    function(msg)
        local jsonData = json.decode(msg.Data)
        ao.send({ Target = msg.From, Data = jsonData })
    end
)

-- Example usage: Send({ Target = ao.id, Action = "QueryTokenPrice", Data = "bitcoin" })
