import ConfigParser
import logging
from logging.config import fileConfig

from base import Base
from mootdao import MootDao

class Achievements(Base):

    def __init__(self, username):
        Base.__init__(self, __name__)
        self.username = username

        self.config = ConfigParser.ConfigParser()
        self.config.read('config.ini')

        self.logger.debug("TESTING ACHIEVEMENTS")

    def util(self):
        for attr in dir(self):
            if(attr.startswith('test_')):
                print(attr)
                test = getattr(self, attr)
                test()
        # self.logger.debug()


    def test_savings(self):
        self.logger.debug("test_savings()")
        db = MootDao()
        db.award_points('ebleiweiss', '1')
        # points = db.get_points('ebleiweiss')
        # self.logger.debug(points)
        # self.logger.debug("{}: {}".format("test_savings", points >= 1000))

    def test_savings2(self):
        self.logger.debug("test_savings2()")
        db = MootDao()
        db.award_points('ebleiweiss', '10')
        # db = MootDao()
        # points = db.get_points(self.username)
        # print "{}: {}".format("test_savings2", points >= 2000)
        # self.logger.debug("{}: {}".format("test_savings2", points >= 2000))


    def test_savings3(self):
        self.logger.debug("test_savings3()")
        db = MootDao()
        db.award_points('ebleiweiss', '100')