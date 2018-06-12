#!/bin/sh

NOTIFYSCRIPT="./notify-mattermost.py"
CHANNEL="openshiftio-alerts"

time for project in $(awk '{print $1}' ebs-pvcs.txt); do
  vol=$(oc -n ${project} get pvc --no-headers | awk '($6=="ebs") {print $1}'|head -n1)
  echo "## ${project}:pvc/${vol}"
  if [ -z "${vol}" ]; then
    echo "skipping, ebs vol not found"
    continue
  fi
  ./pvcmove ${project} ${vol} gluster-subvol
  ERR=$?
  if [ ${ERR} -ne 0 ]; then
    echo "Error: copy did not return success (${ERR})"
    MSG="Problem with ${project}:pvc/${vol}. See https://errortracking.prod-preview.openshift.io/openshift_io/ebs2gluster/ for debug log."
    ${NOTIFYSCRIPT} ${CHANNEL} "${MSG}"
    exit ${ERR}
 fi
done
