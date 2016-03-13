from __future__ import absolute_import

from tornado.wsgi import WSGIContainer
from tornado.httpserver import HTTPServer
from tornado.ioloop import IOLoop

from moot.game import app
from moot.moot_logger import get_logger

logger = get_logger("server")

http_server = HTTPServer(WSGIContainer(app))
http_server.listen(5000)
logger.info('Starting server')
IOLoop.instance().start()




