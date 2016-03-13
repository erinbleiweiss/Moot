from setuptools import setup, find_packages

setup(
    name = "moot",
    version = "0.1.0",
    author = "Erin Bleiweiss",
    author_email = "erinbleiweiss@gmail.com",
    description = ("Backend for Moot iOS app."),
    license = "All rights reserved",
    url = "http://www.erinbleiweiss.com",
    packages=find_packages(exclude='moot.tests')
)