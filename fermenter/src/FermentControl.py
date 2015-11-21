
import os

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


    def run(self):
        print("Running...")

        self.sensor_logger = SensorLogger(self.config)
        self.fridge_control = FridgeControl(self.config)

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

