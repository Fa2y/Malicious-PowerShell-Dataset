from cryptography.fernet import Fernet


ke = Fernet.generate_key()

Fer = Fernet(ke)

path = r'C:\Users\er\OneDrive\Escritorio\Info_imporante.txt'


with open(path, 'rb') as file:
    x = file.read()
    print(x)


ooutput = Fer.encrypt(x)


with open(path, 'w') as fi:
    fi.write('e')



with open(ooutput, 'wb') as ed:
    ed.write(ooutput)