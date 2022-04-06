
-- configuration
local monitor = peripheral.wrap("left") 

function display(dir)
   
   monitor.setTextScale(2)

   monitor.setCursorPos(1,1)
   monitor.clearLine()
   monitor.write("Display")
end




local runHandeler = true -- value so main loop can be killed
while runHandeler do -- main loop

    display(displaySide)

    os.sleep(0.5) -- just to limit main loop

end
