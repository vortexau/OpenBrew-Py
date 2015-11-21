
class FridgeControl:

    fridge = None

    def __init__(self, fridge):
        self.fridge = fridge

    def actions(self, fridge):
        print 'Actions to control fridge {0}'.format(fridge)
