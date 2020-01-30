import scrapy
from ..items import ExtracreditItem
from _collections import OrderedDict

# inherit from scrapy.Spider, in which all must inherit
class spider(scrapy.Spider):

    # Name of spider
    name = "extracredit"

    # Give list of URLs to scrape
    start_urls = ['https://www.theguardian.com/travel/2013/may/25/top-10-live-music-venues-seattle']

    # The parse method is in charge of processing the response and returning scraped data and/or more URLs to follow.
    # handles response
    def parse(self, response):
        items_container = {}
        items = ExtracreditItem()
        a = response.css(".js-article__body").css("h2::text").getall()
        b = response.css(".js-article__body").css("em::text").getall()
        c = response.css(".js-article__body").css("p::text").getall()
        for i, j, k in zip(a, b, c):
            try:
                items['h2'] = i
                items['em'] = j
                items['p'] = k
                items_container.update(items)
                yield items_container
            except IndexError:
                yield items_container

