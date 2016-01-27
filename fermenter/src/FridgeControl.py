
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
        nofermwait = self.config.get('fermentor','nofermwait')
        
        while True:
            fermenting = False
            print 'Actions to control fermentor {0}'.format(fermentor)

            # Is there a fermenting batch at this moment?
            # Check the DB to find out.
            if fermenting = False:
                print "Nothing fermenting. Sleeping for {0}".format(nofermwait)
                time.sleep(float(nofermwait))
                continue


            # Check the wort temp

            # Check the air temp

            # Check the ambient?

            # Heating circuit is...

            # Cooling circuit is...

            # Defined setpoint at this point? Check the steps in the beerbatch

            print "Sleeping for {0}".format(readwait)
            time.sleep(float(readwait))
