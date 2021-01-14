# Define here the models for your scraped items
#
# See documentation in:
# https://docs.scrapy.org/en/latest/topics/items.html

import scrapy


class NaveropenapiItem(scrapy.Item):
    # define the fields for your item here like:
    # name = scrapy.Field()
    title = scrapy.Field()
    link = scrapy.Field()
    image = scrapy.Field()
    lprice = scrapy.Field()
    hprice = scrapy.Field()
    mallName = scrapy.Field()
    productId = scrapy.Field()
    productType = scrapy.Field()