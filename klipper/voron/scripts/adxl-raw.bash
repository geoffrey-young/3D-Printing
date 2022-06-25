#!/usr/bin/bash

if compgen -G "/tmp/resonances_x_*.csv" > /dev/null; then
  /home/pi/klipper/scripts/calibrate_shaper.py /tmp/resonances_x_*.csv -o /tmp/shaper_calibrate_x.png > /tmp/shaper_calibrate_x.txt 2>&1
fi

if compgen -G "/tmp/resonances_y_*.csv" > /dev/null; then
  /home/pi/klipper/scripts/calibrate_shaper.py /tmp/resonances_y_*.csv -o /tmp/shaper_calibrate_y.png > /tmp/shaper_calibrate_y.txt 2>&1
fi

if compgen -G "/tmp/raw_data_x*.csv" > /dev/null; then
  /home/pi/klipper/scripts/calibrate_shaper.py /tmp/raw_data_x*.csv -o /tmp/shaper_calibrate_x.png > /tmp/shaper_calibrate_x.txt 2>&1
fi

if compgen -G "/tmp/raw_data_y*.csv" > /dev/null; then
  /home/pi/klipper/scripts/calibrate_shaper.py /tmp/raw_data_y*.csv -o /tmp/shaper_calibrate_y.png > /tmp/shaper_calibrate_y.txt 2>&1
fi

if compgen -G "/tmp/raw_data_axis*.csv" > /dev/null; then
  /home/pi/klipper/scripts/graph_accelerometer.py -c /tmp/raw_data_axis*.csv -o /tmp/belt-resonances.png > /tmp/belt-resonances.txt 2>&1
fi

today=`date +"%Y%m%d"`
now=`date +"%H%M"`

mkdir -p /tmp/${today}/${now}/
cp /tmp/raw_data*.csv /tmp/${today}/${now}/
cp /tmp/resonances*.csv /tmp/${today}/${now}/
cp /tmp/shaper_calibrate* /tmp/${today}/${now}/
cp /tmp/belt-resonances* /tmp/${today}/${now}/
