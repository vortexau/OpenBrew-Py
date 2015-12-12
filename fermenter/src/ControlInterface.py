import os, os.path
import random
import string
import json
import cherrypy
import decimal

class RootWebService:
    dbconn = None
  
    def __init__(self, dbconn):
        self.dbconn = dbconn

    @cherrypy.expose
    def index(self):
        return file('www/index.html')

class SensorsFermentorData:
    dbconn = None

    def __init__(self, dbconn):
        self.dbconn = dbconn

    @cherrypy.expose
    @cherrypy.tools.accept(media='application/json')
    @cherrypy.tools.json_out()
    def fermentorone(self, batch=None, daterange=None):
        cherrypy.response.headers["Access-Control-Allow-Origin"] = "*"

        cur = self.dbconn.cursor()

        query = """SELECT   * 
            FROM     ( 
              SELECT   Cast(ambient AS FLOAT), 
                       Cast(air AS FLOAT), 
                       Cast(wort AS FLOAT), 
                       Cast(ambienthigh AS FLOAT), 
                       runbatchid, 
                       to_char(to_timestamp(runtime), 'YYYY-MM-DD HH24:MI:SS') as runtimedate,
                       runtime 
              FROM     v_fridgeone 
              ORDER BY runtime DESC limit 400 ) AS foo 
            ORDER BY runbatchid; """

        cur.execute(query)
        data = cur.fetchall()

        return self.formatdata(data) 

    def formatdata(self, data):
        wort = {"key": "Wort temp", "color": "#7777ff", "values": [] }
        air  = {"key": "Air temp", "color": "#ff7f0e", "values": [] }
        ambient = {"key": "Ambient", "color": "#2ca02c", "values": [] }

        for row in data:
            wort['values'].append({ "x": row['runtime'], "y": row['wort']})
            air['values'].append({ "x": row['runtime'], "y": row['air']})
            ambient['values'].append({ "x": row['runtime'], "y": row['ambient']})

        rowdata = [wort, air, ambient]

        return rowdata

    @cherrypy.expose
    @cherrypy.tools.accept(media='application/json')
    @cherrypy.tools.json_out()
    def other(self):
        return 'something'

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

class FermentorsWebService:

    def __init__(self, dbconn):
        self.dbconn = dbconn

    @cherrypy.expose
    @cherrypy.tools.accept(media='application/json')
    @cherrypy.tools.json_out()
    def index(self, fermentor=0):
        return 'Data for fermentor', fermentor
         
class ControlInterface:
  
    logger = None
    dbconn = None
    config = None

    def __init__(self, logger, dbconn, config):
        self.logger = logger
        self.dbconn = dbconn
        self.config = config
       
        # Also: www.zacwitte.com/using-ssl-https-with-cherrypy-3-2-0-example 
        '''
        cherrypy.config.update({
            'server.socket_host': '0.0.0.0',
            'server.socket_port': 1469,
        })

        self.conf = {
            '/': {
               'tools.sessions.on': True,
               'tools.staticdir.root': os.path.abspath(os.getcwd())
            },
            '/fermentors': {
                'request.dispatch': cherrypy.dispatch.MethodDispatcher(),
                'tools.response_headers.on': True,
                'tools.response_headers.headers': [('Content-Type', 'application/json')],
            }
        }
        '''

        root_config = {
            '/': {
               'tools.sessions.on': True,
               'tools.staticdir.root': os.path.abspath(os.getcwd())
            },
        }

        sensors_config = {
            '/': {
             
             }
        }
        fermentors_config = {
            '/': {

            }
        }

        cherrypy.tree.mount(RootWebService(self.dbconn), '/', config=root_config)
        cherrypy.tree.mount(SensorsFermentorData(self.dbconn), '/sensors', config=sensors_config)
        cherrypy.tree.mount(FermentorsWebService(self.dbconn), '/fermentors', config=sensors_config)
    
    def interface(self):
        cherrypy.config.update({'server.socket_host': '0.0.0.0', })
        cherrypy.config.update({'server.socket_port': 1469, })
        cherrypy.engine.start()
        cherrypy.engine.block()
