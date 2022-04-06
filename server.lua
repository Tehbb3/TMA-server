
-- configuration
local config = {
    side = {
        monitor = "left",
        modem = "back"
    }
    network = {
        serverPort = 1000, -- listening port for server
        clientPort = 2000, -- client recive port-transmit
    }

}



print("________  ______      ____")
print("/_  __/  |/  / _ |____/ __/")
print(" / / / /|_/ / __ /___/\\ \\ ") 
print("/_/ /_/  /_/_/ |_|  /___/ ")

local monitor = peripheral.wrap(config.side.monitor) 
local modem = peripheral.wrap(config.side.modem)

function display(dir)
   
   monitor.setTextScale(2)

   monitor.setCursorPos(1,1)
   monitor.clearLine()
   monitor.write("Display")
end

print("Display set to monitor: "..monitorDirection.."\n")

modem.open(config.network.serverPort)
print("Opended server port: "..config.network.serverPort)


print("loading main loop.")
local runHandeler = true -- value so main loop can be killed
while runHandeler do -- main loop

    -- display(displaySide)
    -- os.sleep(0.5) -- just to limit main loop

    local event, modemSide, senderChannel, 
    replyChannel, message, senderDistance = os.pullEvent("modem_message")
  
    print("===== Message Recive ======")
    print("Channel: "..senderChannel)
    print("Reply channel: "..replyChannel)
    print("Modem on "..modemSide.." side")
    print("Message contents: \n"..message)
    print("Sender is "..(senderDistance or "an unknown number of").." blocks away")

end
