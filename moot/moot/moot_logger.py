from __future__ import absolute_import
import os
from logging.config import fileConfig
import logging

def get_logger(name, isTestFile=False):
    name = "{0:^20}".format(name)
    if isTestFile:
        logger = logging.getLogger(__name__)
        handler = logging.FileHandler('info.log')
        formatter = logging.Formatter('%(asctime)s [%(name)s] %(levelname)8s: '
                                      '%(message)s')
        handler.setFormatter(formatter)
        logger.addHandler(handler)
        return logger
    else:
        logger_path = os.path.join(os.getcwd(), "moot/logging_config.ini")
        fileConfig(logger_path, disable_existing_loggers=False)
        logger = logging.getLogger(name)
        return logger