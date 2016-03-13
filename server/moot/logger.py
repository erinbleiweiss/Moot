import os
from logging.config import fileConfig
import logging

def get_logger(name):
    logger_path = os.path.join(os.getcwd(), "moot/logging_config.ini")
    fileConfig(logger_path, disable_existing_loggers=False)
    logger = logging.getLogger(name)
    return logger