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
mqttServer  = host_ip
accessToken = "GMxsuGHOU1GIJKB5iFd9"
dir='/home/pi/motion'
picFiles = 0
client = mqtt.Client()
client.username_pw_set(accessToken)
client.connect (mqttServer, 1883, 60)
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
