"""Spider to get basic data bout Arduino projects"""
from scrapy import Spider, Request
from arduinoScrape.items import ArduinoscrapeItem

class ArduinoSpider(Spider):
    """Spider class"""
    name = "ard_spider"
    allowed_urls = ['https://create.arduino.cc/']
    start_urls = ['https://create.arduino.cc/projecthub?page=1&sort=respected']

    def parse(self, response):
        #get number of pages to scrape
        number_of_pages_list = response.xpath('//*[@class="pagination"]/ul/li/a/text()').extract()
        #throw out non-numbers
        number_of_pages_list = [num for num in number_of_pages_list if str.isdigit(num)]
        #convert remaining to ints
        number_of_pages_list = map(int, number_of_pages_list)
        #select number of last page, which is total number of pages
        num_pages = max(number_of_pages_list)

        #urls of all pages of projects
        page_urls = ['https://create.arduino.cc/projecthub?page={}&sort=respected'.format(x)
                     for x in range(1, num_pages + 1)]

        for url in page_urls:
            yield Request(url=url, callback=self.parse_page)


    def parse_page(self, response):
        #get project urls
        projs = response.xpath('//*[@class="project-link-with-ref"]/@href')
        proj_urls = map(lambda x: 'https://create.arduino.cc/' + x, projs.extract())

        for url in proj_urls:
            yield Request(url=url, callback=self.parse_detail)


    def parse_detail(self, response):
        #get information on detail page
        #start with item to be returned
        item = ArduinoscrapeItem()

        Title = response.xpath('//*[@class="project-title"]/text()').extract_first()

        Description = response.xpath('//*[@class="project-one-liner"]/text()').extract_first()

        #A function generates stat numbers. Take the first stats listed in the function since those
        #appear to be the most recent.
        VCR_stat_list = response.xpath('//*[@class="list-inline project-stats"]/li/span/text()').extract()[0:3]

        Topics = ','.join(response.xpath('//*[@class="list-inline tags"]/li/a/text()').extract())

        Date = response.xpath('//*[@class="section-thumbs"]/text()').extract_first()

        Creator = response.xpath('//*[@class="wide-thumb-body"]/h5/a/text()').extract_first()

        PF_stat_list = response.xpath('//*[@class="project-stats list-inline"]/li/strong/text()').extract()

        print(Title)
        print('=' * 50)

        item['Title'] = Title
        item['Views'] = VCR_stat_list[0]
        item['CommentsNum'] = VCR_stat_list[1]
        item['Respects'] = VCR_stat_list[2]
        item['Topics'] = Topics
        item['Date'] = Date
        item['Creator'] = Creator
        item['Projects'] = PF_stat_list[0]
        item['Followers'] = PF_stat_list[1]
        item['Description'] = Description

        yield item
