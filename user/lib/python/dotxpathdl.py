import os
import lxml.html
import requests
from urllib.parse import urljoin

# Download elements from a sequence of webpages. Navigate to `start_url`,
# retrieve file URLs with `elem_xpath` and download them, go to the next page
# selected with `next_xpath`, repeat until there is no next page. HTTP header
# fields can be specified by passing a dict to `headers`.
#
# Example: Muted
# Downloader(
#     start_url  = 'https://www.webtoons.com/en/supernatural/muted/episode-1/viewer?title_no=1566&episode_no=1',
#     elem_xpath = '//div[@id="_imageList"]/img/@data-url',
#     next_xpath = '//a[contains(@class, "pg_next _nextEpisode")]/@href',
#     headers    = { 'referer': 'https://www.webtoons.com/' },
# ).start()
class Downloader:
    def __init__(self, start_url, elem_xpath, next_xpath=None, headers={}):
        self.start_url  = start_url
        self.elem_xpath = elem_xpath
        self.next_xpath = next_xpath
        self.headers = { 'user-agent': 'Mozilla/5.0', **headers }

    def start(self):
        for i, j, elem_url in self.iterate():
            self.download(
                url      = elem_url,
                filename = f"{i:03}_{j:03}_{os.path.basename(elem_url)}",
            )

    def request(self, url):
        return requests.get(url=url, headers=self.headers)

    def download(self, url, filename):
        print(url)
        with open(filename, "wb") as file:
            elem = self.request(url).content
            file.write(elem)

    def iterate(self):
        next_url = self.start_url
        i = 0
        while next_url:
            html = self.request(next_url).content
            tree = lxml.html.fromstring(html)

            next_url = tree.xpath(self.next_xpath) if self.next_xpath \
                  else None
            next_url = urljoin(self.start_url, next_url[0]) if next_url \
                  else None

            elem_urls = tree.xpath(self.elem_xpath)
            for j, elem_url in enumerate(elem_urls): yield i, j, elem_url
            i += 1
