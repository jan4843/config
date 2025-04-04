import soco
import time

def is_playing(zone):
    transport_info = zone.get_current_transport_info()
    return transport_info['current_transport_state'] == 'PLAYING'

def find_master(zones):
    for zone in zones:
        if zone.is_soundbar:
            continue
        if is_playing(zone):
            return zone

def join():
    zones = soco.discover()
    master = find_master(zones)
    if not master:
        return
    target_volume = master.volume if is_playing(master) else 10
    for zone in zones:
        if zone is master:
            continue
        if is_playing(zone):
            continue
        zone.volume = target_volume
        zone.join(master)

while True:
    try:
        join()
    except:
        pass
    time.sleep(60)
