

class Step:

    step_name = None
    step_type = None
    step_time = None
    step_temp = None
    step_description = None
    step_order = None
    
    def set_name(self, step_name): 
        self.step_name = step_name
        
    def set_type(self, step_type):
        self.step_type = step_type
        
    def set_time(self, step_time):
        self.step_time = step_time
        
    def set_temp(self, step_temp):
        self.step_temp = step_temp
        
    def set_desc(self, step_desc):
        self.step_description = step_desc
        
    def set_order(self, step_order):
        self.step_order = step_order
    
    """
    NAME Saccharification
    TYPE Temperature
    STEP_TIME 75.0000000
    STEP_TEMP 64.4444444
    RAMP_TIME 15.0000000
    END_TEMP 64.4444444
    DESCRIPTION Heat to 64.4 C over 15 min
    DISPLAY_STEP_TEMP 64.4 C
    """