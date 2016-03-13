import os
import ConfigParser

from moot.logger import get_logger

class Base:

    def __init__(self, name):
        self.config = ConfigParser.ConfigParser()
        config_path = os.path.join(os.getcwd(), "moot/config.ini")
        self.config.read(config_path)

        self.name = name
        self.logger = get_logger(self.name)

