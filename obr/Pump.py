
import time

class Pump:

    PUMP_BROWN = "BROWN"
    PUMP_MARCH = "MARCH"
    
    status = 0
    pump_type = None
    
    def __init__(self, pump_type):
        self.set_pump_type(pump_type)
        
    def set_pump_type(self, pump_type):
        self.pump_type = pump_type
    
    def get_pump_status(self):
        return self.status
        
    def set_pump_status(self, status):
        self.status = status
        
    def pulse_pump(self, pulses=5):
        for x in range(0, pulses):
            # pulse on
            self.pump_on()
            time.sleep(1)
            # pulse off
            self.pump_off()
            time.sleep(1)
            
    def pump_on(self, pulse=True, pulses=5):
    
        # Should we pulse the pump before turning it on?
        if(pulse == True):
            self.pulse_pump(pulses)
    
        if(self.get_pump_status() == 0):
            # do what's needed to switch it on.
            self.set_pump_status(1)
            
        return True
        
    def pump_off(self):
        if(self.get_pump_status() == 1):
            # switch it off.
            self.set_pump_status(0)
            
        return True
    
    