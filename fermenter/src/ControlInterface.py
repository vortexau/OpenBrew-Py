import os, os.path
import random, string, json, cherrypy

from BatchesWebService import BatchesWebService
from RootWebService import RootWebService
from SensorsAllData import SensorsAllData
from FermentorsWebService import FermentorsWebService
from SensorsWebService import SensorsWebService

class ControlInterface:
  
    logger = None
    dbconn = None
    config = None

    def __init__(self, logger, dbconn, config):
        self.logger = logger
        self.dbconn = dbconn
        self.config = config
       
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

        batches_config = {
            '/': {
                'tools.response_headers.on': True,
                'tools.response_headers.headers': [('Content-Type', 'application/json')],
            }
        }

        cherrypy.tree.mount(RootWebService(self.dbconn), '/', config=root_config)
        cherrypy.tree.mount(SensorsWebService(self.dbconn), '/sensors', config=sensors_config)
        cherrypy.tree.mount(FermentorsWebService(self.dbconn), '/fermentors', config=sensors_config)
        cherrypy.tree.mount(BatchesWebService(self.dbconn), '/batches', config=batches_config)
    
    def interface(self):
        cherrypy.config.update({'server.socket_host': '0.0.0.0', })
        cherrypy.config.update({'server.socket_port': 1469, })
        cherrypy.engine.start()
        cherrypy.engine.block()
