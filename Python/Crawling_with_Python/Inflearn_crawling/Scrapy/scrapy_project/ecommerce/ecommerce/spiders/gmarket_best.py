import scrapy
from ecommerce.items import EcommerceItem


class GmarketBestSpider(scrapy.Spider):
    name = 'gmarket_best'
    allowed_domains = ['corners.gmarket.co.kr/Bestsellers']
    start_urls = ['http://corners.gmarket.co.kr/Bestsellers/']

    def parse(self, response):
        titles = response.css('div.best-list li > a::text').getall()
        prices = response.css('div.best-list li div.item_price div.s-price strong span::text').getall()
        
        for idx, title in enumerate(titles):
            item = EcommerceItem()
            item['title'] = title
            item['price'] = prices[idx].strip().replace('원', '').replace(',', '')
            yield item