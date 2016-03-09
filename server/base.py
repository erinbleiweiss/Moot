from logging.config import fileConfig
import logging

class Base:

    def __init__(self, name):
        fileConfig('logging_config.ini')
        self.name = name
        self.logger = logging.getLogger(name)
