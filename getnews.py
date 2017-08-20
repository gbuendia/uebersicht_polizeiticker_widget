# -*- coding: utf-8 -*-

# Parsing a RSS feed, as per
# https://stackoverflow.com/questions/12878903/how-to-parse-an-xml-feed-using-python
import urllib2
import json
from xml.etree import ElementTree as etree

regions = "ZH BE LU UR SZ OW NW GL ZG FR SO BS BL SH AR AI SG GR AG TG TI VD VS NE GE JU BW BY BB HB HH HE MV NI RP SL SN ST TH FL".split(" ")
# I removed BE and SH from the German länder as the collide with Bern and Schaffhausen, 
# As the news are CH-centered, I assume they won't use them or if they use them they will use another abbreviation?
# I couldn't find an example of news from Berlin or Schleswig in their feed to see what abbreviation they use.
# I will need to correct manually the NW news, as PT uses "NRW" as abbreviation

def parsetitle(title):
	# Can the title be divided by a hyphen?
	couple = title.split(" - ")
	if len(couple) > 2:   # The headline prolly uses one or more hyphens in the headline
		couple = [couple[0], " - ".join(couple[1:])] # Rejoin the supposed headline, make it a 2 member couple
		# Being length = 2, it should enter the following if too:
	if len(couple) == 2 and len(couple[0]) > 3: # The headline is prolly formatted as expected: place region - headline
		# See if the last two letters of the first half are recognizable and preceded by space
		if couple[0][-2:] in regions and couple[0][-3] == " ":
			place = couple[0][:-3] + ": "
			region = couple[0][-2:]
		# See if the region is NRW
		elif couple[0][-4:] == " NRW":
			place = couple[0][:-4] + ": "
			region = "NRW"
		else: # Probably it's PT's company advice, or region-wide/state-wide news
			place = couple[0] + ": "
			region = "XX" # We'll use a non-regional icon
		headline = couple[1] + "."
	elif len(couple) == 1:  # Treat the whole title as a big header
		place = ""        # We will not locate it
		region = "XX"     # We'll use a non regional icon
		headline = couple[0] + "."
	else: # Nothing should enter the else :|
		place = ""
		region = "XX"
		headline = "Error parsing article title"
	return [place, region, headline]

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
	# get details
	title = entry.findtext('title')
	link = entry.findtext('link')
	# make a dict with each item
	object = {}
	titlechunks = parsetitle(title)
	object["place"] = titlechunks[0]
	object["region"] = titlechunks[1]
	object["headline"] = titlechunks[2]
	object["link"] = link
	# Make a list of objects
	feed.append(object)
# Make a JSON object from the list
json_data = json.dumps(feed)

print json_data