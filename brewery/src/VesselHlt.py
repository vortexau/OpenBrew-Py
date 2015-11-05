
from Vessel import Vessel
import time,os

class VesselHlt(Vessel):

    target_timestamp = None
    target_starttime = None
    
    def __init__(self, logger, dbconn):
        super(VesselHlt, self).__init__(logger, dbconn)
        self.set_name("Hot Liquor Tank")
        self.set_type(self.VESSEL_HLT)

    def set_target_strike_time(self, target_timestamp=0):
        if(target_timestamp==0):
            print("Target time was 0, starting immediately")
            
        self.target_timestamp = target_timestamp
        # Start time is 1hr 30 mins prior to the target time.
        self.target_starttime = target_timestamp - (90 * 60) 

    def actions(self):
        print("Doing anything the HLT needs at this point")
        print("Our PID is %s", os.getpid())
        print(self.get_name())
        
        # If strike in mlt is true, we only use the 
        # mashout temp here as this is sparge water only, no strike water.
        #if self.strike_in_mlt is True:
        #    target_temp = self.vessel_steps.get_sparge_temp()
        #else:
        #    target_temp = self.vessel_steps.get_strike_temp()
        
        #if time.now() > target_starttime:
            # switch on the pump.
            # switch on the heater.

            
        time.sleep(105);
        print("Ending HLT Thread")
        
        
    def add_steps(self, steps):
        # HLT we only care about the strike temp and sparge/mash-out steps.
        print("HLT Steps")
        
