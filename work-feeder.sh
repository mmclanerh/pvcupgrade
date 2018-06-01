#!/bin/sh

time for line in $(cat ebs-pvs.txt); do
  oc -n ${project} get pvc --no-headers 2>&1| awk -vp="${project}" '{print p,$0}'
done
