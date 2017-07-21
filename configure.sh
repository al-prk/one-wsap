#!/bin/bash
webinst=$(ls /opt/1C/*/*/webinst)
for f in /descriptors/*.vrd
do
  echo "Processing $f"
  instance=$(basename ${f%.vrd})
  dir=/pub/$instance
  mkdir -p $dir
  vrd_path=$dir/default.vrd
  $webinst -publish -apache24 -wsdir $instance -descriptor $f  -confpath $descriptors_config -dir $dir
  while [ ! -f $vrd_path ]
  do
    sleep 1
  done
  chmod 755 $vrd_path
done
