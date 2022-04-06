
-- configuration
local config = {
    side = {
        monitor = "left",
        modem = "back"
    },
    network = {
        serverPort = 1000, -- port to send to server
        clientPort = 2000, -- listen port for client
    }

}



print("________  ______      ____")
print("/_  __/  |/  / _ |____/ __/")
print(" / / / /|_/ / __ /___/\\ \\ ") 
print("/_/ /_/  /_/_/ |_|  /___/ ")

local currentAction = {
    type = "NO",
    times = 0,
}
-- local monitor = peripheral.wrap(config.side.monitor) 
local modem = peripheral.wrap(config.side.modem)


local function display(dir)
   
   monitor.setTextScale(2)

   monitor.setCursorPos(1,1)
   monitor.clearLine()
   monitor.write("Display")
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
        currentAction.type = message
        currentAction.times = 1

    end

end



--[[
action types
NO - Do nothing

MF - Fowards
MB - move Backwards
MU - move upwards
MD - move downwards
TL - turn left
TR - turn right

DF - Dig fowards
DU - Dig up
DD - Dig down

D1 - Dig 1x1
D2 - Dig 3x2
D3 - Dig 3x3
]]--


local function action() 

    local runModule = true -- value so main loop can be killed
    while runModule do -- main loop

        if (currentAction.type == "NO") or (currentAction.times == 0) then
            print("NO ACTION")
            os.sleep(0.5)
        else

            -- if currentAction.type == "MF" then
            --     turtle.foward()
            -- end



            local slaveCommands = {
                {id="NO", action="print('Nop')"},
                {id="MF", action="turtle.forward()"},
                {id="MB", action="turtle.back()"},
                {id="MU", action="turtle.up()"},
                {id="MD", action="turtle.down()"},
                {id="TL", action="turtle.turnLeft()"},
                {id="TR", action="turtle.turnRight()"},
            }



            n = 1
            while slaveCommands[n] ~= nil do

                if slaveCommands[n].id == currentAction.type then
                    local func, err = loadstring(slaveCommands[n].action)
                    
                    if func then -- check if the function is loaded
                        func() -- run the function
                    else
                        print("Error: ", err) -- error loading the string
                    end
                end
                n = n + 1
            end

            currentAction.times = currentAction.times - 1 -- decrement action

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
    action,
)



    -- display(displaySide)
    -- os.sleep(0.5) -- just to limit main loop

