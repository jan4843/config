import glob
import json
import os
import re
import time
import urllib.request
import vdf

APPLIST_URL = 'http://api.steampowered.com/ISteamApps/GetAppList/v2'
APPLIST_CACHE = os.path.expanduser('~/.cache/steamapplist.json')
APPLIST_MAX_AGE_DAYS = 7

def applist_is_stale():
    try:
        age = time.time() - os.path.getmtime(APPLIST_CACHE)
        return age > APPLIST_MAX_AGE_DAYS * 86400
    except FileNotFoundError:
        return True

if applist_is_stale():
    urllib.request.urlretrieve(APPLIST_URL, APPLIST_CACHE)
with open(APPLIST_CACHE, 'r') as f:
    APPS = json.load(f)['applist']['apps']

def appid_by_name(name):
    def normalize(s):
        return s.encode('ascii', errors='ignore').decode()
    name = normalize(name)
    for app in APPS:
        if normalize(app['name']) == name:
            return app['appid']

def download(url, dest):
    if os.path.exists(dest):
        return
    try:
        print(f'Download {url} to {dest}...')
        urllib.request.urlretrieve(url, dest)
    except urllib.error.HTTPError:
        pass

for steam_dir in [
    d.path
    for d in os.scandir(os.path.expanduser('~/.local/share/Steam/userdata/'))
    if d.is_dir() and d.name != '0'
]:
    grid_dir_path = f'{steam_dir}/config/grid'
    shortcuts_vdf_path = f'{steam_dir}/config/shortcuts.vdf'
    shortcuts_vdf = vdf.binary_loads(open(shortcuts_vdf_path, 'rb').read())

    for shortcut in shortcuts_vdf['shortcuts'].values():
        uid = int(shortcut['appid']) & 0xffffffff
        name = shortcut['AppName']
        appid = appid_by_name(name)
        print(f'{uid} {name} ({appid})')
        if not appid:
            continue
        if glob.glob(f'{grid_dir_path}/{uid}*'):
            continue

        horizontal = [
            'header.jpg',
            'capsule_616x353.jpg',
            'capsule_231x87.jpg',
        ]
        vertical = [
            'library_600x900.jpg',
            'library_600x900_2x.jpg',
            'hero_capsule.jpg',
        ]
        hero = [
            'library_hero.jpg',
        ]
        logo = [
            'logo.png',
        ]

        for suffix, urls in {
            '':      horizontal + vertical,
            'p':     vertical + horizontal,
            '_hero': hero,
            '_logo': logo,
        }.items():
            for url in urls:
                cdns = [
                    'https://cdn.cloudflare.steamstatic.com',
                    'https://steamcdn-a.akamaihd.net',
                ]
                for cdn in cdns:
                    download(f'{cdn}/steam/apps/{appid}/{url}', f'{grid_dir_path}/{uid}{suffix}.jpg')

    uids = set()
    for shortcut in shortcuts_vdf['shortcuts'].values():
        uid = int(shortcut['appid']) & 0xffffffff
        uids.add(uid)
    for f in os.listdir(grid_dir_path):
        n = re.split(r'[^0-9]', f)
        try:
            n = int(n[0])
        except ValueError:
            continue
        
        if n not in uids:
            path = f'{grid_dir_path}/{f}'
            print(f'Cleanup {path}')
            os.remove(path)
