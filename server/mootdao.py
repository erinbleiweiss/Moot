import psycopg2
import md5
import ConfigParser

import logging
from logging.config import fileConfig

# fileConfig('logging_config.ini')
# logger = logging.getLogger()

class MootDao:

    def __init__(self):
        # logger.debug("MOOT DAO")
        config = ConfigParser.ConfigParser()
        config.read('config.ini')
        self.dbname = config.get('psql', 'dbname')
        self.pgusername = config.get('psql', 'pgusername')
        self.pgpassword = config.get('psql', 'pgpassword')
        self.pghostname = config.get('psql', 'pghostname')


    def get_db(self):
        return psycopg2.connect(database=self.dbname,
                                user=self.pgusername,
                                password=self.pgpassword,
                                host=self.pghostname)


    def create_user(self, username, password, avatar):
        conn = self.get_db()
        with conn:
            c = conn.cursor()
            c.execute('SELECT COUNT(*) from gameuser WHERE username=%s',
                      (username,))
            n = int(c.fetchone()[0])

            if n == 0:
                hashedpass = md5.new(password).hexdigest()
                c.execute('INSERT INTO gameuser (username, password, avatar) '
                          'VALUES (%s, %s, %s)', (username, hashedpass, avatar))
                conn.commit()
            else:
                print ('User already exists')
