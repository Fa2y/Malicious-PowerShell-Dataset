from chameleon.chameleon import Chameleon
import random, os

WORKDIR = "malicious_samples/"

def get_random_files(percentage, directory):
    file_list = os.listdir(directory)
    num_files = len(file_list)
    num_files_to_select = int(num_files * percentage / 100)

    random_files = random.sample(file_list, num_files_to_select)
    return random_files

def obfuscate_sample(filename):
    config = {
        "strings": True,
        "variables": True,
        "data-types": True,
        "functions": True,
        "comments": True,
        "spaces": True,
        "cases": True,
        "nishang": True,
        "backticks": True,
        "random-backticks": False,
        "backticks-list": False,
        "hex-ip": False,
        "random-type": 'r',
        "decimal": None,
        "base64": True,
        "tfn-values": False,
        "safe": True,
        "verbose": False
    }

    chameleon = Chameleon(filename=f"{WORKDIR}/{filename}", outfile=f"{WORKDIR}{filename[:-4]}-obfuscated.ps1", config=config)
    chameleon.obfuscate()
    chameleon.write_file()
    return True

def obfuscate_all():
    files2obfuscate = get_random_files(20, WORKDIR)
    for file in files2obfuscate:
        print(f"Obfusacting {file}")
        obfuscate_sample(file)

if __name__ == "__main__":
    obfuscate_all()
