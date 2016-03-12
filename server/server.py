from tornado.wsgi import WSGIContainer
from tornado.httpserver import HTTPServer
from tornado.ioloop import IOLoop
from tornado import options
from logging.config import fileConfig
import logging

from moot.game import app

fileConfig('logging_config.ini', disable_existing_loggers=False)
logger = logging.getLogger('server')

http_server = HTTPServer(WSGIContainer(app))
http_server.listen(5000)
logger.info('Starting server')
IOLoop.instance().start()




