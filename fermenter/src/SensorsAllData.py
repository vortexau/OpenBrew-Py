
import cherrypy

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
