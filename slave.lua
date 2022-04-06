
-- configuration
local config = {
    side = {
        monitor = "left",
        modem = "left"
    },
    network = {
        serverPort = 1000, -- port to send to server
        clientPort = 2000, -- listen port for client
        slavePort = 3000, -- listen port for the slave
    }

}

local autoRefuel = true
local autoRefuelThreshold = 200

print("________  ______      ____")
print("/_  __/  |/  / _ |____/ __/")
print(" / / / /|_/ / __ /___/\\ \\ ") 
print("/_/ /_/  /_/_/ |_|  /___/ ")

local currentAction = {
    type = "NO",
    times = 0,
}
local slaveFuel = 0

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
        term.write("C>"..message.com)
        currentAction.type = message.com
        currentAction.times = message.times

    end

end
local function rprint(text)

    modem.transmit(config.network.serverPort, config.network.slavePort, "#"..text)

    print(text)
end



--[[
action types
NO - Do nothing

RF - Refuel
FL - Show fuel level

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

        
        if autoRefuel == true then
            if turtle.getFuelLevel() < autoRefuelThreshold then
                turtle.refuel(1)
            else
                -- rprint("Fuel level : "..turtle.getFuelLevel())
            end
        end




        if (currentAction.type == "NO") or (currentAction.times == 0) then
            -- rprint("NO ACTION - "..slaveFuel)
            os.sleep(1) -- leave to prevent stop thingy??
        else

            
            if currentAction.type == "FL" then
                rprint("Fuel level : "..turtle.getFuelLevel())
            end


            -- MOVEMENT
            if currentAction.type == "MF" then
                turtle.forward()
                rprint("Move forward")
            end
            if currentAction.type == "MB" then
                turtle.back()
                rprint("Move back")
            end
            if currentAction.type == "MU" then
                turtle.up()
                rprint("Move up")
            end
            if currentAction.type == "MD" then
                turtle.down()
                rprint("Move down")
            end
            if currentAction.type == "TL" then
                turtle.turnLeft()
                rprint("Turn left")
            end
            if currentAction.type == "TR" then
                turtle.turnRight()
                rprint("Turn right")
            end
            
            -- ACTION
            if currentAction.type == "DF" then
                turtle.dig()
                rprint("Dig forward")
            end
            if currentAction.type == "DU" then
                turtle.digUp()
                rprint("Dig up")
            end
            if currentAction.type == "DD" then
                turtle.digDown()
                rprint("Dig down")
            end


            -- tunnel
            if currentAction.type == "D1" then
                turtle.dig()
                turtle.forward()
                rprint("Tunnel 1")
            end


            -- if currentAction.type == "" then
            --     turtle.
            --     rprint("")
            -- end



            -- local slaveCommands = {
            --     {id="NO", fuelUse=false, action="print(\"Nop\")"},
            --     {id="RF", fuelUse=true, action="turtle.refuel(1) slaveFuel = slaveFuel + 80 print('Refueling 1')"},
            --     {id="MF", fuelUse=true, action="turtle.forward() print('forward')"},
            --     {id="MB", fuelUse=true, action="turtle.back()    print('back')"},
            --     {id="MU", fuelUse=true, action="turtle.up()      print('up')"},
            --     {id="MD", fuelUse=true, action="turtle.down()    print('down')"},
            --     {id="TL", fuelUse=true, action="turtle.turnLeft()print('turn left')"},
            --     {id="TR", fuelUse=true, action="turtle.turnRight()print('turn right')"},
            --     {id="DF", fuelUse=true, action="turtle.dig() print('dig')"},
            --     {id="DU", fuelUse=true, action=""},
            --     {id="DD", fuelUse=true, action=""},
            --     {id="DIE", fuelUse=true, action="exit()"},
            --     {id="NAH", fuelUse=true, action="print('just the noo')"},
            -- }
            -- n = 1
            -- while slaveCommands[n] ~= nil do

            --     if slaveCommands[n].id == currentAction.type then
            --         local func, err = loadstring(slaveCommands[n].action)
                    
            --         if func then -- check if the function is loaded
            --             func() -- run the function
            --             if slaveCommands[n].fuelUse == true then
            --                 slaveFuel = slaveFuel - 1
            --             end
            --         else
            --             print("Error: ", err) -- error loading the string
            --         end
            --     end
            --     n = n + 1
            -- end

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
    action
)



    -- display(displaySide)
    -- os.sleep(0.5) -- just to limit main loop

