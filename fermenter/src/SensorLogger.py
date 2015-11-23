
import time, os, re

class SensorLogger:

    config = None
    dbconn = None

    def __init__(self, config, dbconn):
        self.config = config
        self.dbconn = dbconn

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
                   sensorTemp = self.getSensorTemp(thisSensor)
                   print 'Temp is: ' + sensorTemp
                   self.logSensorTemp(sensorTemp, k)
                   print '----'
               else:
                   print thisSensor + ' WAS NOT FOUND!'

           print readwait
           time.sleep(float(readwait))

    def logSensorTemp(self, sensorTemp, sensorName):
        # log the sensor value to the database here.
        print sensorTemp, sensorName
        if sensorName is 'ambient':
            sensorid = 6
        elif sensorName is 'ambient_high':
            sensorid = 11
        elif sensorName is 'fridge1_air':
            sensorid = 7 
        elif sensorName is 'fridge1_wort':
            sensorid = 8 
        elif sensorName is 'fridge2_air':
            sensorid = 9 
        elif sensorName is 'fridge2_wort':
            sensorid = 10

        cur = self.dbconn.cursor()
        cur.execute(
            """INSERT INTO readings (value, time, sensorid)
               VALUES (%(value)s, %(time)s, %(sensorid)s);""",
            {'value': sensorTemp, 'time': time.time(), 'sensorid': sensorid}) 
        self.dbconn.commit()
        cur.close()

    def getSensorTemp(self, sensorFile):
        f = open(sensorFile, 'r')
        fileContent = f.read()

        return self.getTemp(fileContent)

    def getTemp(self, fileContent):
        # Look for the string YES
        if re.search('[YES]', fileContent):
            # Valid file content

            # Look for the string 't=18062'
            p = re.compile('t=\d+', re.MULTILINE)
            m = p.search(fileContent)
            if m:
                # found a valid temp string.
                fulltemp = m.group(0)
                if fulltemp is 't=85000':
                    return 0.000

                temp = fulltemp.split('=')
                actualTemp = float(temp[1]) / 1000
                return "{:3.3f}".format(actualTemp)



