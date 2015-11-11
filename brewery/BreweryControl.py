

import os, time, logging #, psycopg2 # postgresql
from inspect import getmembers
import pprint

from configparser import ConfigParser
from VesselHlt import VesselHlt
from VesselMlt import VesselMlt
from VesselKettle import VesselKettle
from Pump import Pump
from Sensor import Sensor
from Recipe import Recipe
from SensorLogger import SensorLogger
from ControlInterface import ControlInterface

class BreweryControl():

    vessel_hlt = None
    vessel_mlt = None
    vessel_ktl = None
    
    VESSEL_COUNT = 3

    config  = None
    sensors = None
    dbconn  = None
    logger  = None

    strike_in_mlt = True 

    def __init__(self):
        print("OpenBrew init.")

        # https://docs.python.org/3/library/logging.html
        logging.basicConfig(format='%(message)s', level=logging.DEBUG)
        self.logger = logging.getLogger('BreweryControl').setLevel(logging.WARNING) 

        # Setup the config parser
        self.config = ConfigParser()
        self.config.readfp(open('config.cfg'))
    
        #sensors = Sensors() 
        #sensors.load(self.config)
        
        # Make sure we have a connection to the database
        # http://initd.org/psycopg/docs/
        dsn = "dbname=" + self.config['database']['database'] + " user=" + self.config['database']['username'] + " password=" + self.config['database']['password']
        #self.dbconn = psycopg2.connect(dsn)

    def run(self):
        print("Running..")
        
        brews = 1
        brewcount = 0
        
        # add the pumps
        hlt_recirc = Pump(Pump.PUMP_BROWN)
        mlt_recirc = Pump(Pump.PUMP_MARCH)
        transfer   = Pump(Pump.PUMP_MARCH)
        
        # This will run forever.
        while True:        
        
            # Initially this will just be doing a single batch at a time
            # but this could allow recipes to be stacked.
            try:
                # load the recipe xml
                recipe = Recipe('step_mash_recipe.xml')
        
                # parse the recipe xml
                recipe.parse()
            except Exception as e:
                error_str = "Recipe parsing failed!"
                self.logger.critical(error_str)
                print(error_str)
                
            print("Mash steps are:")
            mash_steps = recipe.get_mash_steps()
            
            for steps in mash_steps:
                print(steps.tag, steps.attrib)
                for step in steps:
                    print(step.tag, step.text)
            
            # setup the vessels 
            self.vessel_hlt = VesselHlt(self.logger, self.dbconn)
            self.vessel_hlt.strike_in_mlt(self.strike_in_mlt)
            self.vessel_hlt.set_target_strike_time() # UNIX timestamp
            self.vessel_hlt.add_steps(recipe.get_mash_steps())
            
            self.vessel_mlt = VesselMlt(self.logger, self.dbconn)
            self.vessel_mlt.strike_in_mlt(self.strike_in_mlt)
            self.vessel_mlt.add_steps(recipe.get_mash_steps())
            
            self.vessel_ktl = VesselKettle(self.logger, self.dbconn)
        
            self.sensor_logger = SensorLogger(self.logger, self.dbconn)
            
            self.control = ControlInterface(self.logger, self.dbconn)
        
            children = []
        
            # Create forks for each vessel.
            # from http://www.petercollingridge.co.uk/blog/running-multiple-processes-python
            start_time = time.time()
            processes = self.VESSEL_COUNT + 2 # number of vessels plus the logger and webservice threads
            for process in range(self.VESSEL_COUNT):
                pid = os.fork()
                if pid:
                    children.append(pid)
                else:
                    self.processLauncher(process)
                    os._exit(0)
            
            # Wait for all the vessels to complete.
            for i, child in enumerate(children):
                os.waitpid(child, 0)
            
            brewcount += 1
            
            if(brewcount == brews):
                print("All batches completed. Exiting.")
                os._exit(0) 
            # Program end.
        
    def processLauncher(self, process):
        if process is 0:
            self.sensor_logger.actions()
        elif process is 1:
            self.control.interface()
        elif process is 2:
            #self.logger.info("HLT Fork starting up")
            self.vessel_hlt.actions()
        elif process is 3:
            #self.logger.info("MLT Fork starting up")
            self.vessel_mlt.actions()
        elif process is 4:
            #self.logger.info("Kettle Fork starting up")
            self.vessel_ktl.actions()
