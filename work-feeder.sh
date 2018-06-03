#!/bin/sh

time for project in $(awk '{print $1}' ebs-pvcs.txt); do
  vol=$(oc -n ${project} get pvc --no-headers | awk '($6=="ebs") {print $1}'|head -n1)
  echo "## ${project}:pvc/${vol}"
  if [ -z "${vol}" ]; then
    echo "skipping, ebs vol not found"
    continue
  fi
  ./pvcmove ${project} ${vol} gluster-subvol
done
