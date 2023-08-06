import requests as req
import httpx
from stream_unzip import stream_unzip
import json, os


client = httpx.Client()
client.headers = {
        "Cookie": "_csrf=MTY4NTQ2MTYxNnxJazlJYkV3M1oxaDZNbFZHVVdoVmNsVTNZM2RNUjI1RU5uUjZWRzVJYWs1elQzaFJZelZUT1ZGNFkyODlJZ289fFxMWy3YKHUq32Qs5XjuqLNZlr10bNcIoeH1w1vs_6dp; _gid=GA1.2.700596336.1685461772; auth=MTY4NTYyMDUyNHxKd3dBSkdRNFlqSXpNRGM0TFRCa1lqRXRORGd4WlMwNE9URmtMV0k1TUdVMFlqVXlNR014WkE9PXwKjIvkWzkHjtJF0OHBgk_LQjVyTQdox_dSXeQWNWfZGg==; _ga_HKGZG9T96Q=GS1.1.1685616077.2.0.1685616084.0.0.0; _ga=GA1.2.1769749494.1685461772"
        }
OUTDIR = "triage_out"

def chunk_download(sample: str):    
    with client.stream('GET', f"https://tria.ge/samples/{sample}/sample.zip") as r:
        yield from r.iter_bytes(chunk_size=65536)


def triage_download_file(sample: str):
    ZIP_PASSWORD = b"infected"
    for file_name, file_size, unzipped_chunks in stream_unzip(chunk_download(sample), password=ZIP_PASSWORD):
        sample_file = open(f"{OUTDIR}/{sample}.ps1", "wb")
        for chunk in unzipped_chunks:
            sample_file.write(chunk)
        else:
            sample_file.close()


def triage_download_files(data):
    dwn_cache = os.listdir(OUTDIR)
    for sample in data["ps1_files"]:
        if sample["score"] < 7 and sample["kind"] != "file":
            continue

        hash_ = sample["sha256"]
        print(f"Downloading {hash_}.ps1 ...", end="\r")
        if f"{hash_}.ps1" in dwn_cache:
            print(f"File already Downloaded {hash_}.ps1")
            continue
        try:
            triage_download_file(sample=sample["sample"])
            print(f"[+] Downloaded {hash_}.ps1 !!!")
        except Exception as e:
            print(f"Error while downloading {hash_}.ps1")
            cont = input("continue? (y/n)")
            if cont == "y":
                continue
            else:
                raise e


if __name__ == "__main__":
    with open("triage_data.json", "r") as f:
        data = json.load(f)
    print("Starting the download process")
    print(f"{len(data)} samples to download")
    triage_download_files(data)
