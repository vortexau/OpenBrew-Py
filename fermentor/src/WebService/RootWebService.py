
import cherrypy

class RootWebService:
    dbconn = None

    def __init__(self, dbconn):
        self.dbconn = dbconn

    @cherrypy.expose
    def index(self):
        return file('www/index.html')

    @cherrypy.expose
    def graphs(self):
        return file('www/graphs.html')
