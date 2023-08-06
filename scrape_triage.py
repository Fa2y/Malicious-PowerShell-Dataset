import requests as req
from datetime import datetime, timedelta
from time import sleep
import json
import urllib.parse
from io import StringIO
import csv

now = datetime.fromisoformat("2022-03-25 21:16:22")

url = 'https://tria.ge/export?q=not+tag%3Alinux+and+not+tag%3Aandroidtag%3Atrojan+and+family%3Ametasploit+OR+family%3Acobaltstrike&offset={0}Z&limit=200'



def parse_ps1_files(ps1_files):
    if len(ps1_files) == 0:
        return False
    with open("triage_data.json", "r") as f:
        data = json.load(f)
    data["ps1_files"].extend(
        [
            {
                "sample":ps1_file[0],
                "created":ps1_file[1],
                "kind":ps1_file[2],
                "filename":ps1_file[3],
                "tags":ps1_file[4],
                "score":int(ps1_file[5]),
                "sha256":ps1_file[6],
            }
            for ps1_file in ps1_files
        ]
    )
    with open("triage_data.json","w") as f:
        json.dump(data, f)
    return True
    

def search_ps1_files(text_data):
    ps1_files = []
    len_lines = len(text_data.split('\n')[1:-1])
    print(f"Got {len_lines} samples")
    f = StringIO(text_data)
    reader = csv.reader(f, delimiter=',')
    for line in reader:
        if line:
            filename = line[3]
            if filename.endswith(".ps1") or filename.endswith(".psm1") or filename.endswith(".psd1"):
                ps1_files.append(line)
                print(f"Found ps1 script num: {filename}")
    else:
        parse_ps1_files(ps1_files)
        return line[1].split(".")[0]
        # return "T".join(text_data.split("\n")[-2].split(",")[1].split(" ")[:2])
    


def scrape_triage():
    global ps1_files
    sess = req.session()
    sess.headers = {
        "Cookie": "_csrf=MTY4NTQ2MTYxNnxJazlJYkV3M1oxaDZNbFZHVVdoVmNsVTNZM2RNUjI1RU5uUjZWRzVJYWs1elQzaFJZelZUT1ZGNFkyODlJZ289fFxMWy3YKHUq32Qs5XjuqLNZlr10bNcIoeH1w1vs_6dp; _gid=GA1.2.700596336.1685461772; auth=MTY4NTYyMDUyNHxKd3dBSkdRNFlqSXpNRGM0TFRCa1lqRXRORGd4WlMwNE9URmtMV0k1TUdVMFlqVXlNR014WkE9PXwKjIvkWzkHjtJF0OHBgk_LQjVyTQdox_dSXeQWNWfZGg==; _ga_HKGZG9T96Q=GS1.1.1685616077.2.0.1685616084.0.0.0; _ga=GA1.2.1769749494.1685461772"
        }
    last_date = now
    while True:
        print(f"Offset: {last_date.isoformat()}")
        resp = sess.get(url.format(urllib.parse.quote_plus(last_date.isoformat())), allow_redirects=False)
        if resp.status_code == 200:
            parse_res = search_ps1_files(resp.text)
            if last_date == datetime.fromisoformat(parse_res):
                last_date = last_date + timedelta(minutes=5)
            else:
                last_date = datetime.fromisoformat(parse_res)
        else:
            print("Error")
            print(f"Status: {resp.status_code}")
            print(resp.text)
        sleep(0.3)

scrape_triage()