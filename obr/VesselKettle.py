
from Vessel import Vessel
import time

class VesselKettle(Vessel):

    def __init__(self, logger, dbconn):
        super(VesselKettle, self).__init__(logger, dbconn)    
        self.set_name("Boil Kettle")
        self.set_type(self.VESSEL_KETTLE)
        
    def actions(self):
        print("Doing anything the Kettle needs at this point")
        print(self.get_name())
        time.sleep(5);
        print("Ending Kettle Thread")