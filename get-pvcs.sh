#!/bin/sh

time for project in $(awk '($1!="NAME") {print $1}' all-projects.txt); do oc -n ${project} get pvc --no-headers 2>&1| awk -vp="${project}" '{print p,$0}'; done | tee all-pvcs.txt
