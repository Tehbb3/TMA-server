

# TMTA
---
Tehbb's Mass Turtle Automation

Remote turtle control/mining system for the minecraft computercraft mod
Tested and developed in the 1.12.2 version

Cant really be bothered to document this right now :/
But with enough time you can probably work everything out
kina just threw this one together .-.


for updating:
http://www.computercraft.info/forums2/index.php?/topic/29920-simple-github-util/

## Possible actions
---

[command] [times to run]

e.g: D3 5
Digs 3x3 tunnel for 5 blocks
(or a 3x3x1 tunnel 5 times)

stopping a command just send a random command e.g "TL" and it will stop the turtles

command | description
NO - Do nothing

IDS - Request DID data from network
IDR - DID data response
IDI - Increment or update DID data

SID - Slave id

PL - Place selected item
SE - Select inventory slot
ST - What is the selected item??
SA - Show all items

RF - Refuel
FL - Show fuel level

DM - Dump most items (except slot 1 coal)

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

D1U - dig 1x1 up
D3U - dig 3x3 up

theres also
RECONSTRUCT - tries to re order all the turtles (kina broken??)
and
UPDATE - updates a turtle's code to this github (if you got the github script installed)


#### Control computer command:

BE - Change turtle control
e.g:
BE 4
will set turtle control to turtle 4

### Kina important:
---
turtle 0 is broadcast so you can send commands to every turtle at once
