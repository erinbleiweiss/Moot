from logging.config import fileConfig
import ConfigParser
import logging

class Base:

    def __init__(self, name):
        self.config = ConfigParser.ConfigParser()

        fileConfig('logging_config.ini', disable_existing_loggers=False)
        self.name = name
        self.logger = logging.getLogger(name)

