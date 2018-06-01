#!/bin/sh

# all-pvcs.txt has a snapshot of all the current pvs, this takes about an hour to produce
#   we filter out of that, anything with an ebs class to ebs-pvcs.txt
#   then for each project listed in skip.txt (high touch customers), we remove those from ebs-pvcs.txt
# we are left with a current list of project+claim names to process in ebs-pvcs.txt
# 
echo "$(date -u) It takes slightly over an hour (78m) to process all projects on the cluster, printing out pvc volumes -- which is why we build a cache of the data vs processing a long-running for loop"
totalprojects=$(egrep -c Active all-projects.txt)
latestproject=$(tail -n1 all-pvcs.txt | awk '{print $1}')
echo "$(date -u) PVC list is updated as of project $(awk '/^'${latestproject}'\ / {print FNR}' all-projects.txt) out of ${totalprojects} so far"
awk '($7=="ebs") {print $1,$2}' all-pvcs.txt > ebs-pvcs.txt
echo "$(date -u) Found $(wc -l ebs-pvcs.txt) ebs volumes"
for project in $(awk '($NF=="Active") {print $1}' skip.txt); do
  sed -i -c -e "/^${project}\ /d" ebs-pvcs.txt
done
echo "$(date -u) Excluding high-touch projects, we still need to process $(wc -l ebs-pvcs.txt) ebs volumes"
