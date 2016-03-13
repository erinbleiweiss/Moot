from __future__ import absolute_import
import psycopg2
import md5

from moot.base import Base

class UserAlreadyExistsException(Exception):
    def __init__(self, err):
        self.err = err
    def __str__(self):
        return 'Exception: ' + self.err

class NoUserExistsException(Exception):
    def __init__(self, err):
        self.err = err
    def __str__(self):
        return 'Exception: ' + self.err

class BadArgumentsException(Exception):
    """Exception for entering bad arguments"""
    def __init__(self, err):
        self.err = err
    def __str__(self):
        return 'Exception: ' + self.err

class MootDao(Base):

    def __init__(self):
        Base.__init__(self, __name__)

        self.logger.debug(self.config)

        self.dbname = self.config.get('psql', 'dbname')
        self.pgusername = self.config.get('psql', 'pgusername')
        self.pgpassword = self.config.get('psql', 'pgpassword')
        self.pghostname = self.config.get('psql', 'pghostname')


    def get_db(self):
        return psycopg2.connect(database=self.dbname,
                                user=self.pgusername,
                                password=self.pgpassword,
                                host=self.pghostname)


    def create_user(self, username, password, email):
        self.logger.debug("create_user()")
        self.logger.debug("Parameters: \n"
                          "\tusername: '{}'\n"
                          "\tpassword: '{}'\n"
                          "\temail: '{}'".format(username, password, email))
        conn = self.get_db()
        with conn:
            c = conn.cursor()
            c.execute('SELECT COUNT(*) from gameuser WHERE username=%s',
                      (username,))
            n = int(c.fetchone()[0])

            if n == 0:
                hashedpass = md5.new(password).hexdigest()
                c.execute('INSERT INTO gameuser (username, password, email) '
                          'VALUES (%s, %s, %s)', (username, hashedpass, email))
                conn.commit()
                self.setup_points(username)
            else:
                self.logger.warn(('User "{}" already exists').format(username))

    def check_username_exists(self, username):
        conn = self.get_db()
        with conn:
            c = conn.cursor()
            c.execute('SELECT COUNT(*) from gameuser WHERE username=%s',
                      (username,))
            n = int(c.fetchone()[0])

        exists = (n != 0)
        self.logger.debug("Username exists: {}".format(exists))
        return (exists)

    def login(self, username, password):
        conn = self.get_db()
        with conn:
            c = conn.cursor()
            cmd = ('select password from gameuser where username=%s')
            c.execute(cmd, (username,))
            hashedpass = md5.new(password).hexdigest()
            u = c.fetchone()
            if u == None:
                raise NoUserExistsException(u)
            self.logger.debug('database contains {}, entered password was '
                         '{}'.format(u[0],hashedpass))
            return u[0] == hashedpass

    def setup_points(self, username):
        conn = self.get_db()
        with conn:
            c = conn.cursor()
            cmd = ('INSERT INTO user_score (user_id, score_value) values '
                   '((select user_id from gameuser where username=%s), 0)')
            c.execute(cmd, (username,))
            conn.commit()


    def award_points(self, username, points):
        self.logger.debug("Awarding {0} points to user '{1}'".format(
            points, username))
        conn = self.get_db()
        with conn:
            c = conn.cursor()
            cmd = ('update user_score set score_value = score_value+%s where '
                 'user_id = (select user_id from gameuser where username=%s)')
            c.execute(cmd, (points, username))
            conn.commit()

    def get_points(self, username):
        self.logger.debug("Getting points for {0}".format(username))
        conn = self.get_db()
        with conn:
            c = conn.cursor()
            cmd = ('select score_value from user_score where user_id = '
                   '(select user_id from gameuser where username=%s)')
            c.execute(cmd, (username,))
            points = c.fetchone()[0]
        return points

    def award_achievement(self, username, achievementname):
        conn = self.get_db()
        with conn:
            c = conn.cursor()
            cmd = ('insert into user_achievement (user_id, achievement_id, created_at) '
                   'values ((select user_id from gameuser where username=%s), '
                   '(select achievement_id from achievement where name=%s), now());')
            c.execute(cmd, (username, achievementname))
            conn.commit()


    def get_achievements(self, username):
        conn = self.get_db()
        with conn:
            c = conn.cursor()
            cmd = ('select name, description, created_at from achievement, user_achievement '
                   'where achievement.achievement_id = user_achievement.achievement_id '
                   'and user_achievement.user_id = '
                   '(select user_id from gameuser where username=%s);')
            c.execute(cmd, (username,))
            achievements = []
            for row in c.fetchall():
                d = {}
                d["name"] = row[0]
                d["description"] = row[1]
                d["created_at"] = row[2]
                achievements.append(d)
        return achievements

    def get_unearned_achievements(self, username):
        conn = self.get_db()
        with conn:
            c = conn.cursor()
            cmd = ('SELECT name, description FROM achievement a WHERE NOT '
                   'EXISTS (SELECT 1 FROM user_achievement u '
                   'WHERE u.user_id=(select user_id from gameuser '
                   'where username=%s) and '
                   'a.achievement_id = u.achievement_id );')
            c.execute(cmd, (username,))
            achievements = []
            for row in c.fetchall():
                d = {}
                d["name"] = row[0]
                d["description"] = row[1]
                achievements.append(d)
        return achievements


    def save_product(self, username, upc, product_name, color, type):
        conn = self.get_db()
        with conn:
            c = conn.cursor()
            cmd = ('insert into scanned_product (user_id, upc, product_name, '
                   'color, type, date) values ((select user_id from '
                   'gameuser where username=%s), %s, %s, %s, %s, now())')
            c.execute(cmd, (username, upc, product_name, color, type))
            conn.commit()


    def get_products(self, username):
        conn = self.get_db()
        with conn:
            c = conn.cursor()
            cmd = ('select product_name, color, type, date from '
                   'scanned_product where user_id = '
                   '(select user_id from gameuser where username=%s)')
            c.execute(cmd, (username,))
            products = []
            for row in c.fetchall():
                d = {}
                d["product_name"] = row[0]
                d["color"] = row[1]
                d["type"] = row[2]
                d["date"] = row[3]
                products.append(d)
            return products
