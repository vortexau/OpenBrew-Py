
import os, time

class FridgeControl:

    config = None
    fermentor = None
    dbconn = None

    def __init__(self, config, dbconn):
        self.config = config
        self.dbconn = dbconn

    def actions(self, fermentor):
        self.fermentor = fermentor

        readwait = self.config.get('fermentor','readwait')
        
        while True:
            fermenting = False
            print 'Actions to control fermentor {0}'.format(fermentor)

            # Is there a fermenting batch at this moment?
            if fermenting = False:
                readwait = 3600 # 1 hour. 
            else:
                print "Sleeping for {0}".format(readwait)

            time.sleep(float(readwait))
