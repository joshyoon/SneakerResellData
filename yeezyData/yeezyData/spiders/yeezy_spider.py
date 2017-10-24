import scrapy
from yeezyData.items import YeezyDataItem

class yeezy_spider(scrapy.Spider):
	name = "yeezy_spider"
	allowed_urls = ['https://stockx.com/']
	start_urls = ["https://stockx.com/"]

	def parse(self, response):
		page_url = ["https://stockx.com/adidas-yeezy-boost-350-v2-cream-white",
		"https://stockx.com/adidas-yeezy-powerphase-calabasas-core-white",
		"https://stockx.com/adidas-yeezy-boost-350-v2-core-black-red-2017",
		"https://stockx.com/adidas-yeezy-boost-350-v2-steeple-grey-beluga-solar-red",
		"https://stockx.com/adidas-yeezy-boost-350-v2-core-black-white",
		"https://stockx.com/adidas-yeezy-boost-350-v2-core-black-red",
		"https://stockx.com/adidas-yeezy-boost-750-chocolate-light-brown-gum",
		"https://stockx.com/adidas-yeezy-boost-350-v2-core-black-copper","https://stockx.com/adidas-yeezy-boost-350-pirate-black-2016","https://stockx.com/adidas-yeezy-boost-350-v2-core-black-green","https://stockx.com/adidas-yeezy-boost-750-light-grey-glow-in-the-dark","https://stockx.com/adidas-yeezy-boost-350-moonrock","https://stockx.com/adidas-yeezy-boost-350-oxford-tan","https://stockx.com/adidas-yeezy-boost-350-pirate-black-2015","https://stockx.com/adidas-yeezy-boost-750-triple-black","https://stockx.com/adidas-yeezy-boost-350-turtledove","https://stockx.com/adidas-yeezy-boost-750-light-brown","https://stockx.com/yeezy-combat-boot-season-4-oil","https://stockx.com/yeezy-season-three-military-boot-rock","https://stockx.com/adidas-yeezy-boost-950-pirate-black","https://stockx.com/yeezy-military-crepe-boot-taupe","https://stockx.com/adidas-yeezy-boost-950-moonrock","https://stockx.com/adidas-yeezy-boost-950-chocolate","https://stockx.com/yeezy-crepe-boot-season-4-oil","https://stockx.com/yeezy-season-three-military-boot-burnt-sienna","https://stockx.com/yeezy-season-three-military-boot-onyx-shade","https://stockx.com/yeezy-crepe-boot-season-4-taupe","https://stockx.com/yeezy-season-three-military-boot-onyx","https://stockx.com/yeezy-military-crepe-boot-oil","https://stockx.com/adidas-yeezy-boost-950-peyote","https://stockx.com/yeezy-combat-boot-season-4-sand"]		

		for url in page_url:
			yield scrapy.Request(url, callback=self.parse_top)

	def parse_top(self, response):
		name = response.xpath('//div[@class="col-md-12"]//h1[@class="name"]/text()').extract_first()
		totals = response.xpath('//div[@class="gauge-value"]/text()').extract_first()


		item = YeezyDataItem()
		item['name'] = name
		item['totals'] = totals

		yield item