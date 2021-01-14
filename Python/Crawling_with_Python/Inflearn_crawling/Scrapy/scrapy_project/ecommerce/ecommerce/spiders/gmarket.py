import scrapy


class GmarketSpider(scrapy.Spider):
    name = 'gmarket'
    allowed_domains = ['www.gmarket.co.kr'] # (지정된) 특정 도메인에 대한 크롤링만 허용
    start_urls = ['http://www.gmarket.co.kr/', 'http://corners.gmarket.co.kr/Bestsellers']

    def parse(self, response):
        print(response.url)
        