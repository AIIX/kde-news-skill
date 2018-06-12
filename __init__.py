import re
import sys
import json
import requests
from bs4 import BeautifulSoup
from adapt.intent import IntentBuilder
from os.path import join, dirname
from string import Template
from mycroft.skills.core import MycroftSkill, intent_handler
from mycroft.skills.context import *
from mycroft.util import read_stripped_lines
from mycroft.util.log import getLogger
from mycroft.messagebus.message import Message

__author__ = 'aix'

LOGGER = getLogger(__name__)

class KDENewsSkill(MycroftSkill):
    def __init__(self):
        super(KDENewsSkill, self).__init__(name="KDENewsSkill")

    @intent_handler(IntentBuilder("GetLatestNews").require("GetLatestKeyword").build())
    def handle_get_latestnews_intent(self, message):
        method = "GET"
        url = "https://api.rss2json.com/v1/api.json?rss_url=https://dot.kde.org/rss.xml"
        response = requests.request(method,url)
        data = response.json()
        currentTitle = data['items'][0]['title']
        currentDesc = data['items'][0]['description']
        soup = BeautifulSoup(currentDesc)
        self.speak(currentTitle)
        self.speak(soup.get_text())
        self.enclosure.ws.emit(Message("kdenewsObject", {'desktop': {'data': response.text}}))
        
    def stop(self):
        pass
    
def create_skill():
    return KDENewsSkill()
