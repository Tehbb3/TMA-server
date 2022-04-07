
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


print('TMA Slave V1') -- less configgy
os.setComputerLabel("Tehbb's Slave") -- default
local slaveLavelPrefix = "TehSlave-"
local slaveID = 0
local totalSlaves = 0

local currentAction = {
    type = "NO",
    times = 0,
}
local slaveFuel = 0

-- local monitor = peripheral.wrap(config.side.monitor) 
local modem = peripheral.wrap(config.side.modem)





local function listen()

    local runModule = true -- value so main loop can be killed
    while runModule do -- main loop


        local event, modemSide, senderChannel, 
        replyChannel, message, senderDistance = os.pullEvent("modem_message")
    
        if (tonumber(message.host) == 0) or (tonumber(message.host) == slaveID) then -- only care if need to

            -- print("===== Message Recive ======")
            -- print("Channel: "..senderChannel)
            -- print("Reply channel: "..replyChannel)
            -- print("Modem on "..modemSide.." side")
            -- print("Message contents: \n"..message)
            -- print("Sender is "..(senderDistance or "an unknown number of").." blocks away")
            term.setCursorPos(1, 19)

            term.write("C>"..message.data)
            currentAction.type = message.data

            currentAction.times = message.qty

        end
        

    end

end


local runModuleDID = true -- value external so can be killed externally


local function dynamicId()

            
    print("Attempting to resolve DID with network...")

    local data = {host=0, data="IDS", qty=1}

    modem.transmit(config.network.clientPort, config.network.slavePort, data)


    while runModuleDID do -- main loop

        print("Listening for DID")

        local event, modemSide, senderChannel, 
        replyChannel, message, senderDistance = os.pullEvent("modem_message")
    
        if (tonumber(message.host) == 0) or (tonumber(message.host) == slaveID) then -- only care if need to

            if message.data == "IDR" then

                print("Network DID data recevied")
                totalSlaves = message.com
                slaveID = totalSlaves + 1
                totalSlaves = totalSlaves + 1
    
                local data = {host=0, data="IDI", qty=totalSlaves}

                modem.transmit(config.network.clientPort, config.network.slavePort, data)
                
                os.setComputerLabel(slaveLavelPrefix..slaveID) -- default
                
                print("Updated self to DID Network")
                
                runModule = false
                print("Run module killed")
            

            end

        end

    end

end
local function dynamicIdWaiter()

    sleep(5) -- delay before giving up on network

    if totalSlaves == 0 then -- if still on default net position

        print("No network found setting defaults")
        -- set some defaults
        totalSlaves = 1
        slaveID = 1

        os.setComputerLabel(slaveLavelPrefix..slaveID) -- default
    end

end




local function rprint(text)


    local data = {host=slaveID, com="NO", data=text}

    modem.transmit(config.network.clientPort, config.network.slavePort, data)

    -- print(text) --Y broken????? tf

    print(slaveID)

    -- term.setCursorPos(1, 19)
    -- term.write("$>"..text)
    -- term.scroll(1)
end



--[[
action types
NO - Do nothing

IDS - Request DID data from network
IDR - DID data response
IDI - Increment or update DID data

SID - Slave id

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

DS - Dig srip mine

D1D - Dig 1x1 Down
D21D- Dig 2x1 Down
D2D - Dig 2x2 down
D3D - Dig 1x1 Down

PL - Place selected item
SE - Select inventory slot
ST - What is the selected item??

]]--


local function action() 

    local runModule = true -- so that module can be kill
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


            if currentAction.type == "IDS" then
                
                local data = {host=0, data="IDR", com=totalSlaves, qty=1}

                modem.transmit(config.network.clientPort, config.network.slavePort, data)
                rprint("IDS data requested")
            end

            
            if currentAction.type == "IDI" then

                totalSlaves = currentAction.times
                currentAction.times = 1 -- will be decremented to 0 later :/
                rprint("IDS data incremented")
            end

            if currentAction.type == "UPDATE" then
                rprint("Updating slave ...")
                shell.run('/update')
                rprint('Done! Rebooting...')
                shell.run('reboot')
            end
            
            if currentAction.type == "REBOOT" then
                rprint("Rebooting...")
                shell.run('reboot')
            end

            if currentAction.type == "RECONSTRUCT" then
                rprint("Waiting for reconstruct :"..((totalSlaves-slaveID)/2)+6)
                sleep(((totalSlaves-slaveID)/2)+6) -- wait based on network order
                rprint("Rebooting...")
                shell.run('reboot')

            end



            if currentAction.type == "FL" then
                rprint("Fuel level : "..turtle.getFuelLevel())
            end

            if currentAction.type == "SID" then
                rprint("sid:"..slaveID)
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
                rprint("Tunnel 1x1")
            end

            if currentAction.type == "D2" then
                -- move layer
                turtle.dig()
                turtle.forward()
                

                turtle.turnLeft()
                turtle.digUp()
                turtle.dig()
                turtle.up()
                turtle.dig()

                turtle.turnRight()
                turtle.turnRight()

                turtle.dig()
                turtle.digDown()
                turtle.down()
                turtle.dig()
                turtle.turnLeft()
                rprint("Tunnel 3x2")
            end

            if currentAction.type == "DS" then
                -- move layer
                turtle.dig()
                turtle.forward()
                turtle.digUp()

                rprint("Tunnel Strip")
            end

            if currentAction.type == "D3" then
                -- move layer
                turtle.dig()
                turtle.forward()
                

                turtle.turnLeft()
                turtle.digUp()
                turtle.dig()
                turtle.up()
                turtle.digUp()
                turtle.dig()
                turtle.up()
                turtle.dig()
                

                turtle.turnRight()
                turtle.turnRight()

                turtle.dig()
                turtle.digDown()
                turtle.down()
                turtle.dig()
                turtle.digDown()
                turtle.down()
                turtle.dig()

                turtle.turnLeft()
                rprint("Tunnel 3x3")
            end


            if currentAction.type == "D1D" then
                turtle.digDown()
                turtle.down()
                rprint("Tunnel 1x1 Down")
            end




            if currentAction.type == "D2D" then
                turtle.digDown()
                turtle.down()

                turtle.dig()
                turtle.forward()

                turtle.turnRight()
                turtle.dig()
                turtle.turnRight()

                turtle.dig()
                turtle.forward()

                turtle.turnLeft()
                turtle.dig()

                turtle.turnLeft()

                rprint("Tunnel 2x2 Down")
            end

            if currentAction.type == "D21D" then
                turtle.digDown()
                turtle.down()

                turtle.dig()


                rprint("Tunnel 2x1 Down")
            end


            if currentAction.type == "D3D" then
                turtle.digDown()
                turtle.down()

                turtle.dig()
                turtle.forward()

                turtle.turnRight()
                turtle.dig()
                turtle.turnLeft()

                turtle.turnLeft()
                turtle.dig()
                turtle.forward()

                turtle.turnLeft()
                turtle.dig()
                turtle.forward()

                turtle.dig()
                turtle.forward()

                turtle.turnLeft()
                turtle.dig()
                turtle.forward()

                turtle.dig()
                turtle.forward()

                turtle.turnLeft()
                turtle.dig()
                turtle.forward()

                turtle.turnLeft()
                turtle.forward()
                turtle.turnRight()

                rprint("Tunnel 3x3 Down")
            end


            if currentAction.type == "D1U" then
                turtle.digUp()
                turtle.up()
                rprint("Tunnel 1x1 Up")
            end

            if currentAction.type == "D3U" then
                turtle.digUp()
                turtle.up()

                turtle.dig()
                turtle.forward()

                turtle.turnRight()
                turtle.dig()
                turtle.turnLeft()

                turtle.turnLeft()
                turtle.dig()
                turtle.forward()

                turtle.turnLeft()
                turtle.dig()
                turtle.forward()

                turtle.dig()
                turtle.forward()

                turtle.turnLeft()
                turtle.dig()
                turtle.forward()

                turtle.dig()
                turtle.forward()

                turtle.turnLeft()
                turtle.dig()
                turtle.forward()

                turtle.turnLeft()
                turtle.forward()
                turtle.turnRight()

                rprint("Tunnel 3x3 Up")
            end

            

            if currentAction.type == "PL" then
                turtle.place()
                rprint("Place")
            end

            if currentAction.type == "SE" then
                turtle.select(currentAction.times)
                rprint("Select slot"..currentAction.times)
                currentAction.times = 1 -- will be decremented to 0 later :/
            end

            if currentAction.type == "ST" then
                local item = turtle.getItemDetail()

                if item then
                print("Item name: ", item.name)
                print("Item damage value: ", item.damage)
                print("Item count: ", item.count)
                rprint("dmg:"..item.damage.." qty:"..item.count.." nme:"..item.name)
                end
                
                
            end


            -- VV probably the better way but multiple commands is broken i think? idk ^^^ easier

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



modem.open(config.network.slavePort)
-- modem.open(3000)

print("Opended server port: "..config.network.slavePort)




parallel.waitForAny( -- get dynaic id
    dynamicId,
    dynamicIdWaiter
)

print("main function.")

rprint("Booted!")

-- term.setCursorPos(1, 18)
parallel.waitForAny(
    listen,
    action
)



    -- display(displaySide)
    -- os.sleep(0.5) -- just to limit main loop

