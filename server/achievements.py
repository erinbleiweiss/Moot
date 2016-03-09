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
        self.all_achievements = MootDao().get_achievements(self.username)

    def check_all_achievements(self):
        for attr in dir(self):
            if(attr.startswith('test_')):
                test = getattr(self, attr)
                test_result = test()
                achievement_name = test_result[0]
                should_award = test_result[1]
                if should_award and self.is_new_achievement(achievement_name):
                    db = MootDao()
                    db.award_achievement(self.username, achievement_name)
                    self.logger.info("Awarded achievement '{0}' to user '{1}"
                                     .format(achievement_name, self.username))


    def is_new_achievement(self, achievement_name):
        """
        Determines whether an achievement is unearned for a particular user

        :param achievement_name: (String) corresponding to name in
        achievement table

        :return: True if user does not have the achievement
                 or False if user has already earned the achievement
        """
        for ach in self.all_achievements:
            if ach["name"] == achievement_name:
                return False
        return True


    def test_new_moot(self):
        """
        Tests whether user should be awarded "New Moot" Achievement

        :return:    Tuple in the form (ID, Boolean)
                    ID = String (corresponds to name in achievement table)
                    Boolean = Whether achievement should be awarded
        """
        self.logger.debug("test_new_moot()")
        return ("New Moot", True)

    def test_savings_account(self):
        """
        Tests whether user should be awarded "Savings Account" Achievement

        :return:    Tuple in the form (ID, Boolean)
                    ID = String (corresponds to name in achievement table)
                    Boolean = Whether achievement should be awarded
        """
        self.logger.debug("test_savings_account()")
        db = MootDao()
        points = db.get_points(self.username)
        return ("Savings Account", points >= 1000)

