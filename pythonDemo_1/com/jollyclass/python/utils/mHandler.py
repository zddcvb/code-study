#! /usr/bin/python!
# __*__ coding : utf-8 __*__
from xml.sax.handler import ContentHandler
class MsHandler(ContentHandler):
    def __init__(self):
        self.data = ''
        self.name = ''
        self.age = ''
    def startDocument(self):
        print 'startDocument'
    def endDocument(self):
        print 'endDocument'
     
    def startElement(self, name, attrs):
        self.data = name
        if name == 'person':
            print "=======person========="
            gendar = attrs['gendar']
            print "gendar:" + gendar
            
    def endElement(self, name):
        if self.data == 'name':
            print 'name:' + self.age
        if self.data == 'age':
            print 'age:' + self.age
        self.data = ''
    def characters(self, content):
        if self.data == 'name':
           self.name = content
        if self.data == 'age':
            self.age = content
    
