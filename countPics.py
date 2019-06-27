#!/usr/bin/env python
import os
import time
import sys
import glob
import paho.mqtt.client as mqtt
import json
import socket

host_name = socket.gethostname()
host_ip = socket.gethostbyname(host_name) 

data = {'picFiles': 0}

THINGSBOARD_SERVER  = host_ip
DEVICE_TOKEN  		= "24984B"

dir='/home/pi/motion'
picFiles = 0

client = mqtt.Client()
client.username_pw_set(DEVICE_TOKEN)
client.connect (THINGSBOARD_SERVER, 1883, 60)
client.loop_start()

while True:
    try:
        list = os.listdir(dir)
        picFiles = len(list)
        print(picFiles)
        data['picFiles'] = picFiles
        client.publish('v1/devices/me/telemetry', json.dumps(data), 1)
        time.sleep(1)
    except KeyboardInterrupt:
        client.disconnect()
        sys.exit()
