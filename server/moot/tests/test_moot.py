from __future__ import absolute_import
import os
import unittest
import ConfigParser
from logging.config import fileConfig
import logging
import requests

from moot.logger import get_logger

class MootTest(unittest.TestCase):

    def __init__(self, *args, **kwargs):
        unittest.TestCase.__init__(self, *args, **kwargs)

    def setUp(self):

        self.config = ConfigParser.ConfigParser()
        config_path = os.path.join(os.getcwd(), "config.ini")
        self.config.read(config_path)

        self.hostname = self.config.get('server', 'hostname')
        self.rest_prefix = self.config.get('server', 'rest_prefix')
        self.username = self.config.get('mootapp', 'username')
        self.password = self.config.get('mootapp', 'password')
        self.email = self.config.get('mootapp', 'email')
        self.bad_status = "failure"
        self.good_status = "success"

        logger_path = os.path.join(os.getcwd(), "logging_config.ini")
        fileConfig(logger_path, disable_existing_loggers=False)
        self.logger = logging.getLogger(__name__)

    def tearDown(self):
        print "MootTest.tearDown()"

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

    def test_check_for_achievements(self):
        response = self.api_get('check_for_achievements', use_auth=True)
        self.assertEqual(response["status"], self.good_status)


if __name__ == '__main__':

    unittest.main()
