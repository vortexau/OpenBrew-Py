
import time, os

class SensorLogger:

    config = None

    def __init__(self, config):
        self.config = config

    def actions(self):
        print 'Actions for SensorLogger'

        sensors = {} 

        directory = self.config.get('sensors','directory')
        sensor_file = self.config.get('sensors','file')

        sensors['ambient'] = self.config.get('sensors','ambient')
        sensors['ambient_high'] = self.config.get('sensors','ambient_high')
        sensors['fridge1_air'] = self.config.get('sensors','fridge1_air')
        sensors['fridge1_wort'] = self.config.get('sensors','fridge1_wort')
        sensors['fridge2_air'] = self.config.get('sensors','fridge2_air')
        sensors['fridge2_wort'] = self.config.get('sensors','fridge2_wort')

        readwait = self.config.get('sensors','readwait')

        while True:
           for k, v in sensors.iteritems():
               thisSensor = directory + v + '/' + sensor_file
               print 'Sensor: ' + k
               print 'File: ' + thisSensor
               if os.path.isfile(thisSensor):
                   print thisSensor + ' is valid. Reading..'
               else:
                   print thisSensor + ' WAS NOT FOUND!'

           print readwait
           time.sleep(float(readwait))

