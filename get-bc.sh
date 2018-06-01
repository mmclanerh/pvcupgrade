#!/bin/sh

for project in $(awk '($1!="NAME") {print $1}' all-projects.txt); do  echo ${project} | egrep -q -- '-che$|-jenkins$|-stage$|-run$' && continue; oc -n ${project} get bc --no-headers 2>&1 | awk -vp="${project}" '{print p,$0}'; done | tee bc.txt
