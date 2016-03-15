from __future__ import absolute_import
import os
import sys
import unittest
import ConfigParser

import requests

from moot.moot_logger import get_logger

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

        self.logger = get_logger(__name__, isTestFile=True)

    def tearDown(self):
        print("tearDown")

    def api_get(self, endpoint, payload=None, use_auth=False):
        """
        Helper function to make HTTP GET requests to the server
        :param endpoint: (String) URL of HTTP call
        :param use_auth: (Boolean) Whether or not to use authentication
                         (False if not specified)
        :return:
        """
        url = "{0}{1}/{2}".format(self.hostname, self.rest_prefix, endpoint)
        print(url)
        if use_auth:
            r = requests.get(url, params=payload, auth=(self.username, self.password))
        else:
            r = requests.get(url, params=payload)
        response = r.json()
        return response

    def api_post(self, endpoint, payload, use_auth=False):
        """
        Helper function to make HTTP POST requests to the server
        :param endpoint: (String) URL of HTTP call
        :param payload:  (Dict) Da0746775167813ta to be passed as JSON
        :param use_auth: (Boolean) Whether or not to use authentication
                         (False if not specified)
        :return:
        """
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

    def test_generate_random_word(self):
        payload = {
            'difficulty': 1
        }
        response = self.api_get('generate_random_word', payload, use_auth=True)
        self.assertEqual(response["status"], self.good_status)

    def test_play_hangman(self):
        payload = {'upc': '0746775167813',
                   'target_word': 'butts',
                   'letters_guessed': '_utts'}
        response = self.api_get('play_hangman', payload, use_auth=True)
        self.assertEqual(response["status"], self.good_status)

    def test_play_hangman_incorrect(self):
        payload = {'upc': '0746775167813',
                   'target_word': 'poop',
                   'letters_guessed': '_oo_'}
        response = self.api_get('play_hangman', payload, use_auth=True)
        self.assertEqual(response["status"], self.good_status)

if __name__ == '__main__':

    unittest.main()
