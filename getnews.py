# -*- coding: utf-8 -*-

# Parsing a RSS feed, as per
# https://stackoverflow.com/questions/12878903/how-to-parse-an-xml-feed-using-python
import urllib2
from xml.etree import ElementTree as etree

def parsetitle(title):
	couple = title.split(" - ")
	canton = couple[0][-3:]
	place = couple[0][:-3]
	return canton + "xxx2xxx" + place + "xxx2xxx" + couple[1]

# parse
pt_file = urllib2.urlopen('http://www.polizeiticker.ch/polizeiticker-rss.xml')
# convert to string
pt_data = pt_file.read()
pt_file.close()

# entire feed
pt_root = etree.fromstring(pt_data)
items = pt_root.findall('channel/item')

feed = []
for entry in items:
	#get details
	title = entry.findtext('title')
	link = entry.findtext('link')
	feed.append([title,link])

# For some reason Coffee interprets the array as a string
# This is an ungly way to make it easier to work with later:
objects = ""
for i in feed:
	objects += parsetitle(i[0]).encode("utf-8")
	objects += "xxx1xxx"
	objects += i[1].encode("utf-8")
	objects += "xxx0xxx"

print objects