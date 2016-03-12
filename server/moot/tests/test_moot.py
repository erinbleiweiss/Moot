from logging.config import fileConfig
from logging import getLogger
import unittest
import requests
import ConfigParser

from moot.base import Base

hostname = "http://108.84.181.177:5000"
rest_prefix = "/v1"

class MootTest(unittest.TestCase):

    # def __init__(self, name):
    #     unittest.TestCase.__init__(self)
    #     # Base.__init__(self, __name__)
    #
    #     self.config = ConfigParser.ConfigParser()
    #     self.hostname = self.config.get('server, hostname')
    #     self.rest_prefix = self.config.get('server, rest_prefix')
    #     self.username = self.config.get('mootapp, username')
    #     self.password = self.config.get('mootapp, password')

    def __init__(self, *args, **kwargs):
        unittest.TestCase.__init__(self, *args, **kwargs)


    def setUp(self):
        self.config = ConfigParser.ConfigParser()
        self.config.read('config.ini')
        self.hostname = self.config.get('server', 'hostname')
        self.rest_prefix = self.config.get('server', 'rest_prefix')
        self.username = self.config.get('mootapp', 'username')
        self.password = self.config.get('mootapp', 'password')

    def tearDown(self):
        print "Base.tearDown()"

    def runTest(self):
        assert(True == True)

    def api_get(self, endpoint, use_auth=False):
        url = "{0}{1}/{2}".format(self.hostname, self.rest_prefix, endpoint)
        print(url)
        if use_auth:
            r = requests.get(url, auth=(self.username, self.password))
        else:
            r = requests.get(url)
        response = r.json()
        return response

    def api_post(self, endpoint, payload, use_auth=False):
        url = "{}{}/{}".format(self.hostname, self.rest_prefix, endpoint)
        if use_auth:
            r = requests.post(url, auth=(self.username, self.password),
                              data=payload)
        else:
            r = requests.post(url)
        response = r.json()
        return response

    def test_login(self):
        response = self.api_get('login', use_auth=True)
        self.assertEqual(response["status"], "success")


if __name__ == '__main__':
    unittest.main()
