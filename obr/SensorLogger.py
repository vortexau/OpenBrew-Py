
import os, time
from configparser import ConfigParser


class SensorLogger:
    sensors = None
    
    logger = None
    dbconn = None
    
    def __init__(self, logger, dbconn):
    
        self.logger = logger
        self.dbconn = dbconn
    
        # add the sensors
        self.sensors = ConfigParser()
        self.sensors.readfp(open('sensors.cfg'))
        
        # hlt
        if self.sensors['hlt']['use'] == 'yes': 
            self.hlt_temp = self.sensors['hlt']['hlt_temp']
            
        # mlt
        if self.sensors['mlt']['use'] == 'yes': 
            self.mlt_mashbed = self.sensors['mlt']['mlt_mashbed']
            self.rims_output = self.sensors['mlt']['rims_output']
            
        # kettle
        if self.sensors['kettle']['use'] == 'yes':
            self.ktl_temp = self.sensors['kettle']['ktl_temp']
            
        # chiller
        if self.sensors['chiller']['use'] == 'yes': 
            self.chiller_inlet = self.sensors['chiller']['inlet']
            self.chiller_outlet = self.sensors['chiller']['outlet']
        
        """
        hlt_temp    = Sensor(Sensor.HLT_WATER)
        mlt_return  = Sensor(Sensor.MLT_RETURN)
        mlt_mashbed = Sensor(Sensor.MLT_MASHBED)
        rims_output = Sensor(Sensor.RIMS_OUTPUT)
        ktl_temp    = Sensor(Sensor.KTL_TEMP)
        chiller_inlet  = Sensor(Sensor.CHILLER_INLET)
        chiller_outlet = Sensor(Sensor.CHILLER_OUTLET)
        """

    def actions(self):
        print("Setup of logger for sensors")
        print("Our PID is %s", os.getpid())
        
        # we shouldn't use this loop, we should check for something else.
        while True:
        
            #for sensor in sensors:
                # Check sensor exists.
                # Open the sensor
                # Read the value
                # Save to database
                # Close the sensor
        
            # Sleep for 60 seconds.
            time.sleep(60)
