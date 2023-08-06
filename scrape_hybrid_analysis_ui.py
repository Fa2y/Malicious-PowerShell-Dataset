import requests as req
from bs4 import BeautifulSoup 
import json


URL = "https://hybrid-analysis.com/advanced-search-results?terms%5Bfiletype%5D=ps&terms%5Bverdict%5D=threatlevel-2&sort=timestamp&sort_order=desc&page={0}"
HEADERS = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; WOW64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.5666.197 Safari/537.36",
    "Cookie":"id=56ihomk14m6njua8rbs32nm3js",
}
BASE_URL = "https://hybrid-analysis.com/"
def parse_html(html):
    data = {}
    soup = BeautifulSoup(html, 'html.parser')
    a_tags = soup.find_all('a', class_="sampledl")
    for a_tag in a_tags:
        data[a_tag.attrs["href"].split('/')[-1]] = a_tag.attrs["href"]
    print(f"Data Parsed! {len(a_tags)} samples found")
    return data

def get_html(page):
    print(f"Fetching page {page}")
    resp = req.get(URL.format(page), headers=HEADERS)
    if(resp.status_code == 200):
        print(f"Parsing page {page}")
        return parse_html(resp.text)
    else:
        print(f"Error fetching page {page}, status {resp.status_code}")
        print(resp.text)
        exit()
        return False
def scrape():
    page = 1
    while True:
        prased_data = get_html(page)
        if prased_data:
            with open("hybrid_analysis_data.json", "r+") as f:
                all_data = json.load(f)
                all_data = {**all_data, **prased_data}
                f.seek(0)
                json.dump(all_data, f)
        page += 1
        
if __name__ == "__main__":
    print("Started Scraping")
    scrape()