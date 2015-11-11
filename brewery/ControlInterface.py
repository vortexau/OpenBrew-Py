import os, os.path
import random
import string
import json
import cherrypy

class BaseWebService:
    @cherrypy.expose
    def index(self):
        return file('www/index.html')

class SensorsWebService:
     exposed = True

     @cherrypy.tools.accept(media='application/json')
     @cherrypy.tools.json_in()
     @cherrypy.tools.json_out()
     def GET(self):
         return cherrypy.session['mystring'] # return all the sensors current temps

     # POST, PUT, DELETE not implemented. Does't make sense for temp sensors which are read-only.
         
class PumpsWebService:
     exposed = True

     @cherrypy.tools.accept(media='application/json')
     @cherrypy.tools.json_in()
     @cherrypy.tools.json_out()
     def GET(self):
         return self.all_pump_status() # return all the pumps and their status

     @cherrypy.tools.accept(media='application/json')
     @cherrypy.tools.json_in()
     @cherrypy.tools.json_out()
     def POST(self, pump_status):
         some_string = ''.join(random.sample(string.hexdigits, int(length)))
         cherrypy.session['mystring'] = some_string
         return self.all_pump_status()

     @cherrypy.tools.accept(media='application/json')
     @cherrypy.tools.json_in()
     @cherrypy.tools.json_out()
     def PUT(self, pump_status):
         cherrypy.session['mystring'] = another_string # recieve all pump status - allows application to turn pumps on or off.
         return self.all_pump_status()
         
     def all_pump_status(self):
         # object with the status of all pumps here.
         return json.dumps('pump_status_will_go_here')         

class ControlInterface:

    def __init__(self, logger, dbconn):
        self.logger = logger
        self.dbconn = dbconn
        
        self.server.conf = {
            server.socket_host: '0.0.0.0',
            server.socket_port: 1469

        }

        self.conf = {
            '/': {
               'tools.sessions.on': True,
               'tools.staticdir.root': os.path.abspath(os.getcwd())
            },
            '/sensors': {
                'request.dispatch': cherrypy.dispatch.MethodDispatcher(),
                'tools.response_headers.on': True,
                'tools.response_headers.headers': [('Content-Type', 'application/json')],
            },
            '/pumps': {
                'request.dispatch': cherrypy.dispatch.MethodDispatcher(),
                'tools.response_headers.on': True,
                'tools.response_headers.headers': [('Content-Type', 'application/json')],
            }
        }
    
    def interface(self):
        webapp = BaseWebService()
        webapp.sensors = SensorsWebService()
        webapp.pumps = PumpsWebService()
        cherrypy.quickstart(webapp, '/', self.conf)
