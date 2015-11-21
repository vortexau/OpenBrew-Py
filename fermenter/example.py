
from smbus import SMBus
import RPi.GPIO as GPIO
import time

# RasPi CPU Temp
# root@raspiferm:~# more /sys/class/thermal/thermal_zone0/temp 
# 44925


print "python"

RELAY_BOARD = 0x38

# All On= write 0x00
# All Off = write 0xFF

def readInput():
	return bus.read_byte(RELAY_BOARD)

def relayOn( n ):
	x = readInput() 
        x &= ~(1 << n) # Toogle n bit position to 0
        bus.write_byte(RELAY_BOARD, x)
        return

def relayOff( n ):
	x = readInput()
        x |= (1 << n) # Toogle n bit position to 1
        bus.write_byte(RELAY_BOARD, x)
        return


bus = SMBus(1)


#print "All on..."
#bus.write_byte(RELAY_BOARD, 0x00);
#print "Sleep for 1."
#time.sleep(1)
#bus.write_byte(RELAY_BOARD, 0xFF);
#print "All Off!"
#time.sleep(1)

print "Now going to run each relay for 2 seconds."

for x in range (0, 8):
	print "Switching on " + str(x)
	relayOn( x )
 	time.sleep(1)
	print "And off..."
	relayOff( x )
	time.sleep(1)
	print "Done"

