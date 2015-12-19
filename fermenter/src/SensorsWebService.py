
import cherrypy

class SensorsWebService:
    dbconn = None

    def __init__(self, dbconn):
        self.dbconn = dbconn

    @cherrypy.expose
    @cherrypy.tools.accept(media='application/json')
    @cherrypy.tools.json_out()
    def fermentor(self, fermentor=None, batch=None, daterange='oneday'):
        cherrypy.response.headers["Access-Control-Allow-Origin"] = "*"
        # This gets them OK when they're set
        #print 'Fermentor ' + fermentor + 'Batch ' + batch + ' Date range ' + daterange

        validdateranges = ['oneday','threeday', 'sevenday','all']

        if daterange not in validdateranges:
            return {"error": "Invalid date range"}

        return self.getdata(fermentor, batch, daterange)

    def getdata(self, fermentor=None, batch=None, daterange=None):
        cur = self.dbconn.cursor()

        query = """SELECT * FROM (
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
