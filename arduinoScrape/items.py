"""Items for Arduino Project Scraper"""
# -*- coding: utf-8 -*-

# Define here the models for your scraped items
#
# See documentation in:
# https://doc.scrapy.org/en/latest/topics/items.html

import scrapy


class ArduinoscrapeItem(scrapy.Item):
    """Items for Arduino data"""
    # define the fields for your item here like:
    Title = scrapy.Field()
    Views = scrapy.Field()
    CommentsNum = scrapy.Field()
    Respects = scrapy.Field()
    Topics = scrapy.Field()
    Date = scrapy.Field()
    Creator = scrapy.Field()
    Projects = scrapy.Field()
    Followers = scrapy.Field()
    Description = scrapy.Field()
