
-- configuration
local config = {
    side = {
        monitor = "left",
        modem = "back"
    },
    network = {
        serverPort = 2000, -- port to send to server
        clientPort = 2000, -- listen port for client
    }

}



print("________  ______      ____")
print("/_  __/  |/  / _ |____/ __/")
print(" / / / /|_/ / __ /___/\\ \\ ") 
print("/_/ /_/  /_/_/ |_|  /___/ ")

local currentControl = 0 -- host 0 is all

-- local monitor = peripheral.wrap(config.side.monitor) 
local modem = peripheral.wrap(config.side.modem)

local function display(dir)
   
   monitor.setTextScale(2)

   monitor.setCursorPos(1,1)
   monitor.clearLine()
   monitor.write("Display")
end


function split(pString, pPattern)
    local Table = {}  -- NOTE: use {n = 0} in Lua-5.0
    local fpat = "(.-)" .. pPattern
    local last_end = 1
    local s, e, cap = pString:find(fpat, 1)
    while s do
           if s ~= 1 or cap ~= "" then
          table.insert(Table,cap)
           end
           last_end = e+1
           s, e, cap = pString:find(fpat, last_end)
    end
    if last_end <= #pString then
           cap = pString:sub(last_end)
           table.insert(Table, cap)
    end
    return Table
 end

local function listen()

    local runModule = true -- value so main loop can be killed
    while runModule do -- main loop


        local event, modemSide, senderChannel, 
        replyChannel, message, senderDistance = os.pullEvent("modem_message")
    
        term.setCursorPos(1, 19)
    
        -- print("===== Message Recive ======")
        -- print("Channel: "..senderChannel)
        -- print("Reply channel: "..replyChannel)
        -- print("Modem on "..modemSide.." side")
        -- print("Message contents: \n"..message)
        -- print("Sender is "..(senderDistance or "an unknown number of").." blocks away")
        term.setCursorPos(1, 19)
        term.write("S>"..message)

    end

end



local function ui()

    local runModule = true -- value so main loop can be killed
    while runModule do -- main loop

        term.setCursorPos(1, 19)
        term.clearLine()
        -- term.write("C>")
        local input = read()
        term.setCursorPos(1, 19)
        -- term.write("C>"..input)
        local split =  Split(input, " ")

        if split[1] == "BE" then -- set controlled host
            currentControl = split[2]
        else -- foward other commands

            local data = {host=currentControl, com=split[1], qty=split[2]}
            modem.transmit(config.network.serverPort, config.network.clientPort, input)
        
        end
    
    end

end



print("Display set to monitor: "..config.side.monitor.."\n")

modem.open(config.network.clientPort)
print("Opended server port: "..config.network.serverPort)



print("main function.")

term.setCursorPos(1, 18)
parallel.waitForAny(
    listen,
    ui
)



    -- display(displaySide)
    -- os.sleep(0.5) -- just to limit main loop

