from logging.config import fileConfig
from logging import getLogger
import unittest
import requests
import ConfigParser

from moot.base import Base

hostname = "http://108.84.181.177:5000"
rest_prefix = "/v1"

class MootTest(unittest.TestCase, Base):

    def __init__(self, *args, **kwargs):
        unittest.TestCase.__init__(self, *args, **kwargs)
        Base.__init__(self, __name__)


    def setUp(self):
        print "MootTest.setUp()"
<<<<<<< HEAD

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

        self.config.read('config.ini')
        self.hostname = self.config.get('server', 'hostname')
        self.rest_prefix = self.config.get('server', 'rest_prefix')
        self.username = self.config.get('mootapp', 'username')
        self.password = self.config.get('mootapp', 'password')
        self.email = self.config.get('mootapp', 'email')
        self.bad_status = "failure"
        self.good_status = "success"


    def tearDown(self):
        print "MootTest.tearDown()"
e)

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
            r = requests.post(url, data=payload)
        response = r.json()
        return response

    def test_register(self):
        payload = {'username': self.username,
                   'password': self.password,
                   'confirmPassword': self.password,
                   'email': self.email}
        response = self.api_post('register', payload)
        if (response["status"] == self.bad_status):
            self.assertEqual(response["errors"]["username"][0],
                             "Username unavailable")
        else:
            self.assertEqual(response["status"], self.good_status)

    def test_login(self):
        response = self.api_get('login', use_auth=True)
        self.assertEqual(response["status"], self.good_status)

    def test_award_points(self):
        payload = {'points': 1}
        response = self.api_post('award_points', payload, use_auth=True)
        self.assertEqual(response["status"], self.good_status)

    def test_get_points(self):
        response = self.api_get('get_points', use_auth=True)
        self.assertEqual(response["status"], self.good_status)

    def test_get_achievements(self):
        response = self.api_get('get_achievements', use_auth=True)
        self.assertEqual(response["status"], self.good_status)


if __name__ == '__main__':
    unittest.main()
