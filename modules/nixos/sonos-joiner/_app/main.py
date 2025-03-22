import soco
import time


def find_master(zones):
    master = None
    for zone in zones:
        if zone.is_soundbar:
            if not (is_playing(zone) and not zone.is_playing_tv):
                continue
        if master is None:
            master = zone
        if is_playing(zone) and not zone.is_playing_tv:
            master = zone
    return master


def is_playing(zone):
    transport_info = zone.get_current_transport_info()
    return transport_info['current_transport_state'] == 'PLAYING'


def join():
    zones = soco.discover()
    master = find_master(zones)
    target_volume = master.volume if is_playing(master) else 10
    for zone in zones:
        try:
            if zone is not master and not is_playing(zone):
                zone.volume = target_volume
                zone.join(master)
        except:
            pass

while True:
    try:
        join()
    except:
        pass
    time.sleep(60)
