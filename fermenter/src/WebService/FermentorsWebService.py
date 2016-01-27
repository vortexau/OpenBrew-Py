
import cherrypy

class FermentorsWebService:

    def __init__(self, dbconn):
        self.dbconn = dbconn

    @cherrypy.expose
    @cherrypy.tools.accept(media='application/json')
    @cherrypy.tools.json_out()
    def index(self, fermentor=0):
        return 'Data for fermentor', fermentor
