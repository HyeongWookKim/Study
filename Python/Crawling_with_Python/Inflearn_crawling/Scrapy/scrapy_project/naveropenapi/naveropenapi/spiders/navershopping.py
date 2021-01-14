import scrapy
import json
from naveropenapi.items import NaveropenapiItem


class NavershoppingSpider(scrapy.Spider):
    name = 'navershopping'

    def start_requests(self):
        start_url = 'https://openapi.naver.com/v1/search/shop.json?query='
        client_id = '0eOeLBsYC_jmAu5ydx_1'
        client_secret = 'uYiamO0Wt2'
        header_params = {'X-Naver-Client-Id': client_id, 'X-Naver-Client-Secret': client_secret}
        query = 'iphone'
        for idx in range(10):
            # callback = self.parse 는 default 이므로 굳이 안 써줘도 됨
            yield scrapy.Request(url = start_url + query + '&display=100&start=' + str(idx * 100 + 1), headers = header_params)

    def parse(self, response):
        data = json.loads(response.body_as_unicode()) # 한글이 포함되어 있으므로, response.body_as_unicode()를 입력
        for item in data['items']:
            doc = NaveropenapiItem()
            doc['title'] = item['title']
            doc['link'] = item['link']
            doc['image'] = item['image']
            doc['lprice'] = item['lprice']
            doc['hprice'] = item['hprice']
            doc['mallName'] = item['mallName']
            doc['productId'] = item['productId']
            doc['productType'] = item['productType']
            yield doc