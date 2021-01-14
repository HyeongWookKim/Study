import scrapy
from ecommerce.items import EcommerceItem


class GmarketCategoryAllSpider(scrapy.Spider):
    name = 'gmarket_category_all'

    def start_requests(self):
        yield scrapy.Request(url = 'http://corners.gmarket.co.kr/Bestsellers', callback = self.parse_mainpages)

    def parse_mainpages(self, response):
        print('parse_mainpages')
        category_links = response.css('div.gbest-cate ul.by-group li a::attr(href)').getall()
        category_names = response.css('div.gbest-cate ul.by-group li a::text').getall()
        
        # 1st category crawling
        for idx, category_link in enumerate(category_links):
            yield scrapy.Request(url = 'http://corners.gmarket.co.kr' + category_link, callback = self.parse_items, 
                                 meta = {'maincategory_name': category_names[idx], 'subcategory_name': 'ALL'})
        # 2nd category crawling
        for idx, category_link in enumerate(category_links):
            yield scrapy.Request(url = 'http://corners.gmarket.co.kr' + category_link, callback = self.parse_subcategory, 
                                 meta = {'maincategory_name': category_names[idx]})

    def parse_subcategory(self, response):
        print('parse_subcategory', response.meta['maincategory_name'])
        subcategory_links = response.css('div.navi.group > ul > li > a::attr(href)').getall()
        subcategory_names = response.css('div.navi.group > ul > li > a::text').getall()

        for idx, subcategory_link in enumerate(subcategory_links):
            yield scrapy.Request(url = 'http://corners.gmarket.co.kr' + subcategory_link, callback = self.parse_items, 
                                 meta = {'maincategory_name': response.meta['maincategory_name'], 'subcategory_name': subcategory_names[idx]})

    def parse_items(self, response):
        print('parse_maincategory', response.meta['maincategory_name'], response.meta['subcategory_name'])

        best_items = response.css('div.best-list')
        for idx, item in enumerate(best_items[1].css('li')):
            doc = EcommerceItem()
            ranking = idx + 1
            title = item.css('a.itemname::text').get()
            org_price = item.css('div.o-price span span::text').get()
            dis_price = item.css('div.s-price strong span sapn::text').get()
            dis_percent = item.css('div.s-price em::text').get()

            ### 세부 카테고리별로 css selector가 달라서 아래의 코드에서 오류가 발생하는 것으로 추정된다.
            ### 추후에 시간날 때, 좀 자세히 들어다보고 수정해야 할 듯 싶다. 
            # if org_price == None:
            #     org_price = dis_price
            # org_price = org_price.replace(',', '').replace('원', '')

            # if dis_price == None:
            #     dis_price = org_price
            # dis_price = dis_price.replace(',', '').replace('원', '')

            # if dis_percent == None:
            #     dis_percent = '0'
            # else:
            #     dis_percent = dis_percent.replace('%', '')

            # print(ranking, title, org_price, dis_price, dis_percent)

            doc['main_category_name'] = response.meta['maincategory_name']
            doc['sub_category_name'] = response.meta['subcategory_name']
            doc['ranking'] = ranking
            doc['title'] = title
            doc['org_price'] = org_price
            doc['dis_price'] = dis_price
            doc['dis_percent'] = dis_percent

            yield doc