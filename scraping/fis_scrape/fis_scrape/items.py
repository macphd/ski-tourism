# -*- coding: utf-8 -*-

# Define here the models for your scraped items
#
# See documentation in:
# https://doc.scrapy.org/en/latest/topics/items.html

import scrapy


class FisScrapeItem(scrapy.Item):
    race_name = scrapy.Field()
    race_description = scrapy.Field()
    racer_nationality = scrapy.Field()
    racer_time = scrapy.Field()
