import sys
import requests
from requests import RequestException, HTTPError
import random
import string


def _gen_rnd_str(length):
    return ''.join(random.choice(string.ascii_lowercase + string.digits) for _ in range(length))


def _generate_anon_user():
    return 'anonym-%s-%s-%s' % (_gen_rnd_str(8), _gen_rnd_str(4), _gen_rnd_str(2))


def authenticate():
    header = {'Channel': 'inet'}
    try:
        res = requests.get('https://tickets.oebb.at/api/domain/v3/init',
                           headers=header,
                           params={'userId': _generate_anon_user()})

    except RequestException or HTTPError:  # retry on error
        res = requests.get('https://tickets.oebb.at/api/domain/v3/init',
                           headers=header,
                           params={'userId': _generate_anon_user()})
    res.raise_for_status()
    auth = res.json()

    header.update({'AccessToken': auth['accessToken'], 'SessionId': auth['sessionId'], 'x-ts-supportid': auth['supportId']})
    return header


def get_stations(header, station_name):
    try:
        res = requests.get('https://tickets.oebb.at/api/hafas/v1/stations',
                           headers=header,
                           params={
                               "count": 25,
                               "name": station_name
                           })

    except RequestException or HTTPError:  # retry on error
        res = requests.get('https://tickets.oebb.at/api/hafas/v1/stations',
                           headers=header,
                           params={
                               "count": 25,
                               "name": station_name
                           })
    res.raise_for_status()
    return res.json()


def main():
    if len(sys.argv) != 2:
        error_msg = "Unexpected number of parameters." \
                    "\nUsage:" \
                    "\n\tpython3 %s STATION_NAME" % sys.argv[0].split("/")[-1]
        raise ValueError(error_msg)

    print("Search ÖBB Station ID for \"%s\"..." % sys.argv[1])

    stations = get_stations(authenticate(), sys.argv[1])
    print("%d entries found!" % len(stations))
    for station in stations:
        print("")
        print("station: %s" % station['name'])
        print("id: %s" % station['number'])
        print("longitude: %s" % station['longitude'])
        print("latitude: %s" % station['latitude'])
        if 'meta' in station and station['meta'] is not "":
            print("zip-code: %s" % station['meta'])


if __name__ == "__main__":
    main()
