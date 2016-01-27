
import cherrypy

class BatchesWebService:

    def __init__(self, dbconn):
        self.dbconn = dbconn

    @cherrypy.expose
    @cherrypy.tools.accept(media='application/json')
    @cherrypy.tools.json_out()
    def index(self):
        return 'get all batches in order'

    @cherrypy.expose
    def batch(self, batchid=0):
        return 'Get batch details for batchid' + str(batchid)

