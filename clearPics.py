#!/usr/bin/env python
import glob
import os
directory='/home/pi/motion'
os.chdir(directory)
fileExt = ('*.avi', '*.jpg')
files_grabbed = []
for files in fileExt:
	files_grabbed.extend(glob.glob(files))
for filename in files_grabbed:
	os.unlink(filename)
