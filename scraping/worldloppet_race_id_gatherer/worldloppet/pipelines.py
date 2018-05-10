# -*- coding: utf-8 -*-

# Define your item pipelines here
#
# Don't forget to add your pipeline to the ITEM_PIPELINES setting
# See: https://doc.scrapy.org/en/latest/topics/item-pipeline.html

import re
from scrapy.exceptions import DropItem
from scrapy.exporters import CsvItemExporter


# class WorldloppetPipeline(object):
#     def process_item(self, item, spider):
#         if item["race_id"]:
#             item["race_id"] = re.findall("\d+", item["race_id"])
#             return item

class WriteItemPipeline(object):
    def __init__(self):
        self.filename = 'worldloppet_.csv'
    def open_spider(self, spider):
        self.csvfile = open(self.filename, 'wb')
        self.exporter = CsvItemExporter(self.csvfile)
        self.exporter.start_exporting()
    def close_spider(self, spider):
        self.exporter.finish_exporting()
        self.csvfile.close()
    def process_item(self, item, spider):
        self.exporter.export_item(item)
        return item
