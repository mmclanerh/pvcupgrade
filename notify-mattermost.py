#!/usr/bin/env python3

import argparse
import json
import requests
import sys

BOT_USERNAME = 'pvcupgrade'
BOT_ICON_URL = 'https://cdn.zapier.com/storage/developer/43b918a367ce303f0394b292e3fa8f96.128x128.png'
WEBHOOK_URL = 'https://things'

def main():
    parser = argparse.ArgumentParser(description='Post messages to Mattermost')
    parser.add_argument('-d', '--debug', action='store_true',
                        help='enable debugging')
    parser.add_argument('channel', type=str,
                        help='the channel to post message to')
    parser.add_argument('text', type=str,
                        help='the text to post')
    args, _ = parser.parse_known_args()

    payload = {}
    payload['username'] = BOT_USERNAME
    payload['icon_url'] = BOT_ICON_URL
    payload['channel'] = args.channel
    payload['text'] = args.text

    res = requests.post(WEBHOOK_URL, json=payload)

    if res.status_code != 200:
        print(res.text, file=sys.stderr)
        sys.exit(1)

    print(res.text)


if __name__ == '__main__':
    main()
