
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
local controlPrefix = "C>"
-- local monitor = peripheral.wrap(config.side.monitor) 
local modem = peripheral.wrap(config.side.modem)


local function display(dir)

    local runModule = true -- value so main loop can be killed
    while runModule do -- main loop


        local x, y = term.getCursorPos()

        term.setCursorPos(1, 2)
        term.clearLine()
        write("Tehbb's MA V1.0 | HOST:"..currentControl.. " | ")

        term.setCursorPos(x, y)
        
        os.sleep(1)
    end
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
    
    
        -- print("===== Message Recive ======")
        -- print("Channel: "..senderChannel)
        -- print("Reply channel: "..replyChannel)
        -- print("Modem on "..modemSide.." side")
        -- print("Message contents: \n"..message)
        -- print("Sender is "..(senderDistance or "an unknown number of").." blocks away")
        term.setCursorPos(1, 19)
        term.write("S>"..message)
        term.scroll(1)


        term.setCursorPos(1, 19)
        term.clearLine()
        term.write(controlPrefix)

    end

end



local function ui()

    local runModule = true -- value so main loop can be killed
    while runModule do -- main loop

        -- setup ui
        term.setCursorPos(1, 19)
        term.clearLine()
        term.write(controlPrefix)
        local input = read()


        -- term.setCursorPos(1, 19)
        -- term.write("C>"..input)
        -- term.scroll(1)

        local inputSplit =  split(input, " ")

        if inputSplit[1] == "BE" then -- set controlled host
            currentControl = inputSplit[2]
        else -- foward other commands
            
            local times = 1
            if inputSplit[2] == nil then
                times = 1
            else
                times = tonumber(inputSplit[2])
            end

            local data = {host=currentControl, com=inputSplit[1], qty=times}
            modem.transmit(config.network.serverPort, config.network.clientPort, data)
        
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
    ui,
    display
)



    -- display(displaySide)
    -- os.sleep(0.5) -- just to limit main loop

