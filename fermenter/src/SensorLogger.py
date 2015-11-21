
class SensorLogger:

    config = Nothing

    def __init__(self, config):
        self.config = config

    def actions(self):
        print 'Actions for SensorLogger'

        sensors = {} 

        directory = self.config.get('sensors','directory')
        sensor_file = self.config.get('sensors','file')

        sensors['fridge1_air'] = self.config.get('sensors','fridge1_air')
        sensors['fridge1_wort'] = self.config.get('sensors','fridge1_wort')
        sensors['fridge2_air'] = self.config.get('sensors','fridge2_air')
        sensors['fridge2_wort'] = self.config.get('sensors','fridge2_wort')

        while true:
           for k, v in sensors.iteritems():
               print k, v 

