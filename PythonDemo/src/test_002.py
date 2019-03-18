# -*-coding:utf-8-*-
'''
Created on 2016Äê10ÔÂ24ÈÕ

@author: Administrator
'''
import urllib
import re


 
def getHtml(url):
    page = urllib.urlopen(url);
    html = page.read();
    print html

def getImg(html):
    pattern = 'src="(.+?\.jpg)" pic_ext'
    m = re.compile(pattern)
    urls = re.findall(m, html)
 
    for i, url in enumerate(urls):
        urllib.urlretrieve(url, "%s.jpg" % (i, ))
    return urls
        
html = getHtml("http://tieba.baidu.com/p/2460150866")
print html
print getImg(html)
    
