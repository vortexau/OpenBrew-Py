
class FridgeControl:

    fridge = None
    dbconn = None

    def __init__(self, fridge, dbconn):
        self.fridge = fridge
        self.dbconn = dbconn

    def actions(self, fridge):
        print 'Actions to control fridge {0}'.format(fridge)
