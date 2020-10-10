import wifi
import time

BUILD_IN_WLAN = "wlan0"


def search_for_fake_app():
    wifi_networks = list(wifi.Cell.all(BUILD_IN_WLAN))
    wifi_check_result = {}

    for wifi_network in wifi_networks:
        wifi_ssid = wifi_network.ssid

        if not wifi_ssid:
            continue

        prev_result = wifi_check_result.get(wifi_ssid, {})

        counter = prev_result.get('counter', 0)
        counter += 1
        current_result = {
            "counter": counter,
            "openNetwork": prev_result.get('openNetwork')
        }

        if not wifi_network.encrypted:
            current_result['openNetwork'] = True

        wifi_check_result[wifi_ssid] = current_result

    found_fake_ap = False

    for wifi_ssid in wifi_check_result:
        wifi_network_check = wifi_check_result[wifi_ssid]
        wifi_ssid_counter = wifi_network_check.get('counter', 0)
        wifi_is_open_network = wifi_network_check.get('openNetwork', False)

        if wifi_ssid_counter > 1 and wifi_is_open_network:
            print("High risk of evil twin attack!")
            print(f"Do not connect to the open network of: {wifi_ssid}")
            found_fake_ap = True
        elif wifi_ssid_counter > 1:
            print(f"Warning, the network {wifi_ssid} appears more than one time in the scan")
            print("May be risk of evil twin attack or fake AP")
            found_fake_ap = True

    if not found_fake_ap:
        print("Did not find fake AP")


def main():
    while True:
        search_for_fake_app()
        print(80 * "#")
        time.sleep(60)


if __name__ == "__main__":
    main()
