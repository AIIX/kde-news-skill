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
from word2number import w2n

__author__ = 'aix'

LOGGER = getLogger(__name__)

class KDENewsSkill(MycroftSkill):
    def __init__(self):
        super(KDENewsSkill, self).__init__(name="KDENewsSkill")

    @intent_handler(IntentBuilder("WhatsNewAtKde").require("WhatsNewKeyword").build())
    def handle_whatsnewatkde_intent(self, message):
        method = "GET"
        url = "https://api.rss2json.com/v1/api.json?rss_url=https://dot.kde.org/rss.xml"
        response = requests.request(method,url)
        global articleList
        global articleUrlList
        global articleDescList
        articleList = []
        articleDescList = []
        articleUrlList = []
        articleThumbList = []
        data = response.json()
        for item in data['items']:
            currentTitle = item['title']
            currentUrl = item['link']
            currentThumb = item['thumbnail']
            currentDesc = item['description']
            soup = BeautifulSoup(currentDesc)
            articleList.append(currentTitle)
            articleUrlList.append(currentUrl)
            articleThumbList.append(currentThumb)
            articleDescList.append(soup.get_text())
        for index,item in enumerate(articleList):
            speakData = "Article {0}: {1}".format(str(index+1), item)
            self.speak(speakData)
        self.enclosure.ws.emit(Message("kdenewsObject", {'desktop': {'data': {'titlelist': articleList, 'urllist': articleUrlList, 'thumb': articleThumbList}}}))
    
    @intent_handler(IntentBuilder("GetArticleDesc").require("ArticleNumberKeyword").build())
    def handle_getarticledesc_intent(self, message):
        utterance = message.data.get('utterance').lower()
        utterance = utterance.replace(message.data.get('ArticleNumberKeyword'), '')
        searchString = utterance
        getArticleVal = w2n.word_to_num(searchString)
        articlefetchindex = articleDescList[int(getArticleVal)-1]
        self.speak(articlefetchindex)
        
    def stop(self):
        pass
    
def create_skill():
    return KDENewsSkill()
