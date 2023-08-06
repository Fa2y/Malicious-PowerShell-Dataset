from malwarebazaar import Bazaar
from stream_unzip import stream_unzip
import httpx
from typing import List
import json
import os

mb = Bazaar(api_key="38aa4b499daac80716779b5959ece261")
OUTDIR = "bazaar_out"

def chunk_download(hash: str):
    data = {
            'query': 'get_file',
            'sha256_hash': hash,
    }
    client = httpx.AsyncClient()
    client.headers = mb.session.headers
    with httpx.stream('POST', mb.url, data=data) as r:
        yield from r.iter_bytes(chunk_size=65536)

def bazaar_download_file(hash: str):
    ZIP_PASSWORD = b"infected"
    data = {
        'query': 'get_file',
        'sha256_hash': hash,
    }
    for file_name, file_size, unzipped_chunks in stream_unzip(chunk_download(hash), password=ZIP_PASSWORD):
        sample_file = open(f"{OUTDIR}/{file_name.decode()}", "wb")
        for chunk in unzipped_chunks:
            sample_file.write(chunk)
        else:
            sample_file.close()

def bazaar_download_files(data):
    samples_info = []
    dwn_cache = os.listdir(OUTDIR)
    for sample in data:
        hash = sample["sha256_hash"]
        print(f"Downloading {hash}.ps1 ...", end="\r")
        if f"{hash}.ps1" in dwn_cache:
            print(f"File already Downloaded {hash}.ps1")
            continue
        try:
            bazaar_download_file(hash=hash)
            samples_info.append(
                {
                    "hash":sample["sha256_hash"],
                    "orig_file_name":sample["file_name"],
                    "clamav_rules":sample["intelligence"]["clamav"]
                }
                )
            print(f"[+] Downloaded {hash}.ps1 !!!")
        except Exception as e:
            print(f"Error while downloading {hash}.ps1")
            cont = input("continue? (y/n)")
            if cont == "y":
                continue
            else:
                raise e
    else:
        with open(f"{OUTDIR}/sample_info.json", "w") as f:
            json.dump({"info":samples_info}, f)


if __name__ == "__main__":
    qry_cache = open(f"{OUTDIR}/bazaar_query_cache", "r+")
    if len(qry_cache.read()):
        qry_cache.seek(0)
        resp = json.load(qry_cache)
    else:
        resp = mb.bazaar_query(type_="file_type", query="ps1",limit = 1000)
        json.dump(resp, qry_cache)
    if resp.get("data", False):
        print(f"Queried {len(resp['data'])} sample")
        print("Starting the download process")
        bazaar_download_files(resp["data"])
    else:
        print("Error querying data, printing response:")
        print(resp)