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
        self.user_id = self.config.get('mootapp', 'test_user_id')
        self.password = self.config.get('mootapp', 'moot_password')
        self.TEST_UPC = '0746775167813'
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
            r = requests.get(url, params=payload, auth=(self.user_id,
                                                        self.password))
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
        url = "{0}{1}/{2}".format(self.hostname, self.rest_prefix, endpoint)
        if use_auth:
            r = requests.post(url, auth=(self.user_id, self.password),
                              data=payload)
        else:
            r = requests.post(url, data=payload)
        response = r.json()
        return response


    def test_login(self):
        response = self.api_get('login', use_auth=True)
        self.assertEqual(response["status"], self.good_status)

    def test_get_achievements(self):
        response = self.api_get('get_achievements', use_auth=True)
        self.assertEqual(response["status"], self.good_status)

    def test_get_unearned_achievements(self):
        response = self.api_get('get_unearned_achievements', use_auth=True)
        self.assertEqual(response["status"], self.good_status)

    def test_award_points(self):
        payload = {'points': 1}
        response = self.api_post('award_points', payload, use_auth=True)
        self.assertEqual(response["status"], self.good_status)

    def test_get_points(self):
        response = self.api_get('get_points', use_auth=True)
        self.assertEqual(response["status"], self.good_status)

    def test_save_product(self):
        payload = {'upc': '722252660091'}
        response = self.api_post('save_product', payload, use_auth=True)
        self.assertEqual(response["status"], self.good_status)

    # def test_all_scanned_product_letters(self):
    #     UPCS = {
    #         'A': '887386760502',
    #         'B': '0746775167813',
    #         'C': '722252165305',
    #         'D': '0028400038751',
    #         'E': '0026000013246',
    #         'F': '0041500000251',
    #         'G': '0052000328660',
    #         'H': '071100210453',
    #         'I': '0019014037353',
    #         'J': '0077900115530',
    #         'K': '0038000550195',
    #         'L': '0028400033459',
    #         'M': '0037925044000',
    #         'N': '0009800892204',
    #         'O': '0751746032182',
    #         'P': '029000016149',
    #         'Q': '042000963657',
    #         'R': '034000004409',
    #         'S': '0040000443278',
    #         'T': '0037000547334',
    #         'U': '0054800011254',
    #         'V': '0305212326000',
    #         'W': '0725835374163',
    #         'X': '0095205740929',
    #         'Y': '0070470433295',
    #         'Z': '0025700003915'
    #     }
    #     for (key, val) in UPCS.iteritems():
    #         payload = {'upc': val}
    #         response = self.api_post('save_product', payload,
    #                                  use_auth=True)
    #         self.assertEqual(response["status"], self.good_status)

    def test_generate_random_word(self):
        payload = {
            'difficulty': 1
        }
        response = self.api_get('generate_random_word', payload, use_auth=True)
        self.assertEqual(response["status"], self.good_status)

    def test_play_hangman(self):
        payload = {'upc': self.TEST_UPC,
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

    def test_image_colors(self):
        payload = {
            # 'upc': self.TEST_UPC
            'upc': "0052000328660"
        }
        response = self.api_get('image_colors', payload=payload, use_auth=True)
        self.assertEqual(response["status"], self.good_status)

    def test_generate_maze(self):
        payload = {
            'width': '5',
            'height': '5'
        }
        response = self.api_get('generate_maze', payload=payload)
        self.assertEqual(response["status"], self.good_status)

    def test_maze_move(self):
        payload = {
            'dir': 'east',
            'maze': '12_8_10_10_9_7_5_12_9_5_14_3_5_6_3_12_9_6_9_13_7_6_10_2_3',
            'row': '0',
            'col': '1'
        }
        response = self.api_get('maze_move', payload=payload)
        self.assertEqual(response["status"], self.good_status)

    def test_get_qr_code(self):
        payload = {
            'width': '4',
            'height': '4'
        }

        url = "{0}{1}/{2}".format(self.hostname, self.rest_prefix, 'get_qr_code')
        response = requests.get(url, params=payload, auth=(self.user_id,
                                                        self.password))
        self.assertEqual(response.status_code, 200)

    def test_check_qr_code(self):
        response = self.api_get('check_qr_code')
        self.assertEqual(response["status"], self.good_status)

    def test_check_for_achievements(self):
        response = self.api_get('check_for_achievements', use_auth=True)
        self.assertEqual(response["status"], self.good_status)






if __name__ == '__main__':

    unittest.main()
