

class PumpRims(Pump):

    def __init__(self, logger, dbconn):
        super(PumpRims, self).__init__(logger, dbconn)    
        self.set_name("RIMS Recirc Pump")
        self.set_type(self.PUMP_MARCH)