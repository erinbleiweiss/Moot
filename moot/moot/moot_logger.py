from __future__ import absolute_import
import os
from logging.config import fileConfig
import logging
import colorlog

def get_logger(name, isTestFile=False):
    name = "{0:^20}".format(name)
    if isTestFile:
        logger = logging.getLogger(__name__)
        handler = logging.FileHandler('info.log')
        formatter = colorlog.ColoredFormatter(
            '%(asctime)s %(blue)s[%(name)s] %(log_color)s%(levelname)8s: '
            '%(reset)s%(message)s')
        handler.setFormatter(formatter)
        logger.addHandler(handler)
        return logger
    else:
        logger_path = os.path.join(os.getcwd(), "moot/logging_config.ini")
        fileConfig(logger_path, disable_existing_loggers=False)
        logger = logging.getLogger(name)
        return logger

