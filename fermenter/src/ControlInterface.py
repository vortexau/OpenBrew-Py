import os, os.path
import random
import string
import json
import cherrypy
import decimal

class BaseWebService:
    @cherrypy.expose
    def index(self):
        return file('www/index.html')

class SensorsWebService:
     exposed = True

     dbconn = None
  
     def __init__(self, dbconn):
         self.dbconn = dbconn

     @cherrypy.tools.accept(media='application/json')
     @cherrypy.tools.json_in()
     @cherrypy.tools.json_out()
     def GET(self):
         return self.all_sensor_readings() # return all the sensor readings

     # POST, PUT, DELETE not implemented. Does't make sense for temp sensors which are read-only.
     def all_sensor_readings(self):
         cur = self.dbconn.cursor()
         cur.execute('select * from readings;')
         sensor_values = cur.fetchall()

         return json.dumps(sensor_values, default=self.decimal_default)

     def decimal_default(self, obj):
         if isinstance(obj, decimal.Decimal):
             return float(obj)
         raise TypeError
         
class ControlInterface:
  
    logger = None
    dbconn = None
    config = None

    def __init__(self, logger, dbconn, config):
        self.logger = logger
        self.dbconn = dbconn
        self.config = config
       
        # Also: www.zacwitte.com/using-ssl-https-with-cherrypy-3-2-0-example 
        cherrypy.config.update({
            'server.socket_host': '0.0.0.0',
            'server.socket_port': 1469
        })

        self.conf = {
            '/': {
               'tools.sessions.on': True,
               'tools.staticdir.root': os.path.abspath(os.getcwd())
            },
            '/sensors': {
                'request.dispatch': cherrypy.dispatch.MethodDispatcher(),
                'tools.response_headers.on': True,
                'tools.response_headers.headers': [('Content-Type', 'application/json')],
            }
        }
    
    def interface(self):
        webapp = BaseWebService()
        webapp.sensors = SensorsWebService(self.dbconn)
        cherrypy.quickstart(webapp, '/', self.conf)
