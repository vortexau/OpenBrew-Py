
from Vessel import Vessel
import time

class VesselMlt(Vessel):

    run = False

    def __init__(self, logger, dbconn):
        super(VesselMlt, self).__init__(logger, dbconn)    
        self.set_name("Mash/Lauter Tun")
        self.set_type(self.VESSEL_MLT)
        
    def actions(self):
        print("Doing anything the MLT needs at this point")
        print(self.get_name())
        
        while(run == False):
            time.sleep(5)
            #waiting to be given the OK.
        
      
        print("Processing all configured steps.")
        
        
        time.sleep(5)
        print("Ending MLT thread")
        
    def add_steps(self, mash_steps):
        # MLT we care about all steps.
        print("Mash Steps")
        
        for steps in mash_steps:
            print(steps.tag, steps.attrib)
            for step in steps:
                #print(step.tag, step.text)
                if(step.tag is "mash in"):
                    print("Mash In")
                    
                    
