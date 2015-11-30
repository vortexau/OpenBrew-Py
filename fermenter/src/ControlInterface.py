import os, os.path
import random
import string
import json
import cherrypy
import decimal

class SensorsWebService:
    dbconn = None
  
    def __init__(self, dbconn):
        self.dbconn = dbconn
        self.sensors_all_data = SensorsAllData(self.dbconn)
        self.sensors_fermenter_data = SensorsFermenterData(self.dbconn)

    def _cp_dispatch(self, vpath):
        if len(vpath) == 1:
            cherrypy.request.params['sensors'] = vpath.pop(0)
            return self.sensors_all_data
        if len(vpath) == 2:
            cherrypy.request.params['sensors'] = vpath.pop(0)
            cherrypy.request.params['fermenter'] = vpath.pop(0)
            return self.sensors_fermenter_data

        return vpath
     
    @cherrypy.expose
    def index(self):
        return file('www/index.html')

class SensorsFermenterData:
    dbconn = None

    def __init__(self, dbconn):
        self.dbconn = dbconn

    @cherrypy.expose
    @cherrypy.tools.accept(media='application/json')
    @cherrypy.tools.json_out()
    def index(self, sensors, fermenter):
        var = []
        #other = {"title" : "abc", "temp" : 29.432}
        cur = self.dbconn.cursor()
        cur.execute("""
            SELECT
                r.id,
                CAST(r.value AS float),
                r.time,
                s.name "sensor_name",
                f.name "fermentor_name"
            FROM readings r,
                sensors s,
                fermenters f
            WHERE r.sensorid = s.id
            AND s.fermenterid = f.id
            AND (f.name = 'Fridge 1'
            OR f.name = 'Ambient')
        """)
        #return json.dumps(cur.fetchall())
        return cur.fetchall() # does not need to be dumped as JSON

class SensorsAllData:
    dbconn = None

    def __init__(self, dbconn):
        self.dbconn = dbconn

    @cherrypy.expose
    @cherrypy.tools.accept(media='application/json')
    @cherrypy.tools.json_out()
    def index(self, sensors):
        cur = self.dbconn.cursor()
        cur.execute('select id, cast(value as float), time, sensorid from readings order by time asc;')
        #return json.dumps(cur.fetchall(), default=self.decimal_default)
        return cur.fetchall() # does not need to be dumped as JSON

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
            '/sensorsssss': {
                'request.dispatch': cherrypy.dispatch.MethodDispatcher(),
                'tools.response_headers.on': True,
                #'tools.response_headers.headers': [('Content-Type', 'application/json')],
            }
        }
    
    def interface(self):
        cherrypy.quickstart(SensorsWebService(self.dbconn), '/', self.conf)
