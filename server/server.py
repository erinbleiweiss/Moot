from tornado.wsgi import WSGIContainer
from tornado.httpserver import HTTPServer
from tornado.ioloop import IOLoop
from game import app

import logging
from logging.config import fileConfig

fileConfig('logging_config.ini')
logger = logging.getLogger('server')

http_server = HTTPServer(WSGIContainer(app))
http_server.listen(5000)
logger.info('Starting server')
IOLoop.instance().start()




