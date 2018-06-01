Gather list of projects and parse one at a time
Verify tenant is not in or is likely not in skip list, if so -- skip and log
Check for running pods, if so? Log and follow up later.
Determine space type (for quota apply/revert):
*-che
*-jenkins
*-stage
*-run
If doesn’t match any above and there is a $project_name-che or $project_name-jenkins, this is likely the tenant’s build space (buildconfigs appear here, and some other objects)
Check for ebs volume(s) in the project and process each volume

For each ebs volume:
- Copy old to tmp:
Apply quota increase to namespace (allows for additional PVCs)
Create tmp PVC
Deploy copyold POD (via create DC)
Wait for copyold POD to become active
Rsync old content to tmp PVC
Validate content copy success - look for an expected output + status string 
If ok, Delete copyold POD (via delete DC)
Delete old PVC
Verify old PVC gone
- Copy tmp to new
Apply quota increase to namespace (ensures we allow for additional PVCs)
Create new PVC using old PVC name
Create copynew pod (via create DC)
Wait for copynewPOD to become active
Rsync tmp content to new PVC
Validate content copy success -- look for an expected output + status string
If ok, Delete copynew POD (via delete DC)
Delete tmp PVC
Verify old PVC gone
Restore original quota


Additional considerations:
- Max time to wait for pod to come up? 10 minutes. (3 minutes for EBS PVC release)	
- On failure, we should ship errors to Sentry
- Run this from n14, using support client binary
- We can parallelize by project type (che vs jenkins)

