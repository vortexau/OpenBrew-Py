


class Sensor:

    sensor_type = None
    
    HLT_WATER      = "HLT_WATER"
    MLT_RETURN     = "MLT_RETURN"
    MLT_MASHBED    = "MLT_MASHBED"
    RIMS_OUTPUT    = "RIMS_OUTPUT"
    KTL_TEMP       = "KTL_TEMP"
    CHILLER_INLET  = "CHILLER_INLET"
    CHILLER_OUTLET = "CHILLER_OUTLET"

    def __init__(self, sensor_type):
        self.sensor_type = sensor_type