
from abc import ABCMeta, abstractmethod

class Vessel:

    __metaclass__ = ABCMeta

    vessel_name = None
    vessel_vol  = None
    vessel_type = None
    
    vessel_steps   = []
    vessel_pumps   = []
    vessel_sensors = []

    strike_in_mlt = False

    VESSEL_HLT = "HLT"
    VESSEL_MLT = "MLT"
    VESSEL_KETTLE = "KETTLE"

    logger = None
    dbconn = None

    # type
    # steps
    # pumps
    # sensors

    def __init__(self, logger, dbconn):
        self.logger = logger
        self.dbconn = dbconn

    def set_name(self, vessel_name): 
        self.vessel_name = vessel_name
    
    def get_name(self):
        return self.vessel_name
        
    def set_volume(self, vessel_volume):
        self.vessel_volume = vessel_volume
        
    def get_volume(self):
        return self.vessel_volume
        
    def set_type(self, type):
        self.vessel_type = type
        
    def get_type(self):
        return self.vessel_type
        
    def add_step(self, step):
        self.vessel_steps.append(step)
        
    def add_steps(self, steps):
        self.vessel_steps = steps
        
    def add_pump(self, pump):
        self.vessel_pumps.append(pump)
        
    def add_sensor(self, sensor):
        self.vessel_sensors.append(sensor)
        
    def strike_in_mlt(self, strike_in_mlt):
        self.strike_in_mlt = strike_in_mlt
        
    @abstractmethod
    def actions(self): pass
