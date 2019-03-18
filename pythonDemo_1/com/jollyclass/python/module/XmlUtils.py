#! /usr/bin/python!
# __*__ coding : utf-8 __*__
import xml.sax
from xml.sax.handler import feature_namespaces
from com.jollyclass.python.utils.mHandler import MsHandler


if __name__ == '__main__':
   print 'hello'.decode('utf-8')
   mParse = xml.sax.make_parser()
   mParse.setFeature(feature_namespaces, 0)
   handler = MsHandler()
   mParse.setContentHandler(handler)
   mParse.parse("d:/person.xml");
