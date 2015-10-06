
import xml.etree.ElementTree as ET
import os.path
import json

# documentation on this library here: https://docs.python.org/2/library/xml.etree.elementtree.html

class Recipe:

    recipe_root = None

    def __init__(self, recipe_file):
        if(os.path.isfile(recipe_file)):
            self.tree = ET.parse(recipe_file)
        else:
            raise FileNotFoundException()
        
    def parse(self):
        self.recipe_root = self.tree.getroot()

        if(self.recipe_root is None):
            raise Exception('Parse error')
        else:
            return True
        
    def get_fermentables(self):
        return self.recipe_root.findall("./recipes/recipe/fermentables")
        
    def get_hops(self):
        return self.recipe_root.findall("./recipes/recipe/hops")
    
    def get_misc(self):
        return self.recipe_root.findall("./recipes/recipe/misc")
    
    def get_strike_temp(self):
        # get the strike temp only from the recipe
        return self.recipe_root.strike_temp
        
    def get_mash_out_temp(self):
        # just get the mashout temp from the recipe
        return self.recipe_root.mash_out
    
    def get_mash_steps(self):
        # all steps from the mash itself
        return self.recipe_root.findall("./RECIPE/MASH/MASH_STEPS/MASH_STEP")
    
    def get_hlt_steps(self):
        # strike temp step
        return self.recipe_root.hlt_steps
    
    def export(self, format):
        # format json or xml
        if(format == 'json'):
            return json.dumps(self.recipe_root)
        else:
            return self.recipe_root
    
