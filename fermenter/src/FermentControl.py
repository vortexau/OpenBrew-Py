
import os, time, logging, psycopg2

from configparser import ConfigParser
from SensorLogger import SensorLogger
from FridgeControl import FridgeControl

class FermentControl:

    THREADS = 3

    sensor_logger = None
    fridge_control = None

    def __init__(self):
        print("OpenBrew - Ferment")

        # Setup the config parser
        self.config = ConfigParser()
        self.config.readfp(open('config.cfg'))

        # Make sure we have a connection to the database
        # http://initd.org/psycopg/docs/
        dsn = "host=" + self.config['database']['host'] + " dbname=" + self.config['database']['database'] + " user=" + self.config['database']['username'] + " password=" + self.config['database']['password']
        self.dbconn = psycopg2.connect(dsn)

    def run(self):
        print("Running...")

        self.sensor_logger = SensorLogger(self.config, self.dbconn)
        self.fridge_control = FridgeControl(self.config, self.dbconn)

        children = []

        for process in range(self.THREADS):
            pid = os.fork()
            if pid:
                children.append(pid)
            else:
                self.runFermentThread(process)
                os._exit(0)

        for i, child in enumerate(children):
            os.waitpid(child, 0)

    def runFermentThread(self, process):
        print 'This is process thread {0} for fermenter tasks'.format(process)
        if process is 0:
            self.sensor_logger.actions()
        elif process is 1:
            self.fridge_control.actions(1)
        elif process is 2:
            self.fridge_control.actions(2)

