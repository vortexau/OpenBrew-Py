

class PumpHlt(Pump):

    def __init__(self, logger, dbconn):
        super(PumpHlt, self).__init__(logger, dbconn)    
        self.set_name("HLT Recirc Pump")
        self.set_type(self.PUMP_BROWN)