from scrapy import Spider, Request
from worldloppet.items import WorldloppetItem
import re

class Worldloppet_Spider(Spider):
    name = "worldloppet_spider"
    allowed_urls = ["http://www.worldloppet.com/"]
    start_urls = ["http://www.worldloppet.com/browse.php"]

    #re-attempt to rewrite in one package, rather than copy-pasting list
    # def parse_race_id_urls(self, response):
    #     # selects tables for last 5 years of data
    #     race_url_id = []
    #     for i in range(2018,2012,-1):
    #         race_id_lst = response.xpath("//*[@id=" + str(i) + "]/table/tr/td[3]//@href").extract()
    #         new_id_lst = re.findall('\d+', race_id_lst)
    #         print(len(race_url_id))
    #         print(50*"=")
    #         race_url_id.extend(new_id_lst)
    #     yield race_url_id
    #
        #list comprehension writes urls for above races
        #race_urls = [ ]

    def parse(self, response):
        race_id_lst = []

        #select previous 5 years of ids to enable url list comprehension later
        for i in range(2018,2012,-1):
            race_id = response.xpath("//*[@id=" + str(i) + "]/table/tr/td[3]//@href").extract()
            print(race_id)
            race_id_lst.extend(race_id)

        item = WorldloppetItem()

        item["race_id"] = race_id_lst

        yield item
