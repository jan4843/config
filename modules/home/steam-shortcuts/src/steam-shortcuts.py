import ctypes
import hashlib
import json
import os
import re
import shlex
import sys
import vdf

def sid(seed):
    return int(hashlib.md5(seed.encode()).hexdigest(), 16) % -1000000000

def uid(seed):
    return sid(seed) & 0xffffffff

with open(sys.argv[1]) as f:
    SHORTCUTS = json.load(f)

for steam_dir in [
    d.path
    for d in os.scandir(os.path.expanduser('~/.local/share/Steam/userdata/'))
    if d.is_dir() and d.name != '0'
]:
    grid_dir_path = f'{steam_dir}/config/grid'
    shortcuts_vdf_path = f'{steam_dir}/config/shortcuts.vdf'
    shortcuts_vdf = vdf.binary_loads(open(shortcuts_vdf_path, 'rb').read())

    shortcuts = {}
    managed = {}

    for shortcut in shortcuts_vdf['shortcuts'].values():
        if shortcut.get('FlatpakAppID') == 'managed-by-nix':
            managed[shortcut['appid']] = shortcut
        else:
            shortcuts[str(len(shortcuts))] = shortcut

    for name, shortcut in SHORTCUTS.items():
        defaults = {
            'StartDir': '',
            'LaunchOptions': '%command%',
        }
        current = managed.get(sid(name), {})
        overrides = {
            'appid': sid(name),
            'AppName': name,
            'icon': shortcut['assets']['icon'] or '',
            'Exe': shlex.quote(shortcut['script']),
            'FlatpakAppID': 'managed-by-nix',
        }
        shortcuts[str(len(shortcuts))] = defaults | current | overrides

    with open(shortcuts_vdf_path, 'wb') as f:
        vdf.binary_dump({'shortcuts': shortcuts}, f)

    for f in [
        f.path
        for f in os.scandir(grid_dir_path)
        if f.is_symlink() and os.readlink(f).startswith('/nix/store/')
    ]:
        os.remove(f)

    for name, shortcut in SHORTCUTS.items():
        for suffix, asset in {
            '':      shortcut['assets']['grid']['horizontal'],
            'p':     shortcut['assets']['grid']['vertical'],
            '_hero': shortcut['assets']['hero'],
            '_logo': shortcut['assets']['logo'],
        }.items():
            if asset:
                os.symlink(asset, f'{grid_dir_path}/{uid(name)}{suffix}.png')
