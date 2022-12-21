#!/bin/bash
region=$1
#environment=$2
ami_name_prefix=$2
no_of_ami_to_retain='1'

##  AMI info get step
echo "GET AMI NAME for tag IsRelease=true"
aws ec2 describe-images --region ${region} --owner self \
--filter "Name=name,Values='${ami_name_prefix}'" "Name=tag:IsRelease,Values=true" \
--query 'reverse(sort_by(Images,&CreationDate))[].[ImageId]' --output text| tee ami-name-true.txt

`echo "cat ami-name-true.txt" | awk '(NR>'${no_of_ami_to_retain}')' > file1.txt`

echo "GET AMI NAME for tag IsRelease=false"
aws ec2 describe-images --region ${region} --owner self \
--filter "Name=name,Values='${ami_name_prefix}'" "Name=tag:IsRelease,Values=false" \
--query 'reverse(sort_by(Images,&CreationDate))[].[ImageId]' --output text| tee ami-name-false.txt

`echo "$(<ami-name-false.txt)" | awk '(NR>'${no_of_ami_to_retain}')' > file2.txt`

##  AMI deregister step
for deregister_ami_id in `cat file1.txt`; do
    aws ec2 deregister-image --region ${region} --image-id $deregister_ami_id
    echo "AMI ID = $deregister_ami_id has been unregistered."
    sleep 10
done	

##  AMI deregister step
for deregister_ami_id1 in `cat file2.txt`; do
    ## Get AMI ID
    aws ec2 deregister-image --region ${region} --image-id $deregister_ami_id1
    echo "AMI ID = $deregister_ami_id1 has been unregistered."
    sleep 10
done

## Snapshot ID of the unregistered AMIs
#echo "Getting the snapshot IDs for isRelease=true"
#snapshot_id=$(aws ec2 describe-images --image-ids $image_id --region ${region} --query 'Images[*].BlockDeviceMappings[*].Ebs.SnapshotId' --output text)"
#echo $snapshot_id


#echo "Getting the snapshot IDs for isRelease=false"
#for image_id1 in `cat file2.txt`; do
 #   aws ec2 describe-images --image-ids $image_id1 --region ${region} --query 'Images[*].BlockDeviceMappings[*].Ebs.SnapshotId' --output text| tee snap-false.txt"
#done    


## delete the snapshot of unregistered AMIs
for snapshot in $snapshot_id ; do 
    aws ec2 delete-snapshot --snapshot-id $snapshot
    echo "Snapshot $snapshot has been deleted"
done

for snapshot1 in $snapshot_id1 ; do 
    aws ec2 delete-snapshot --snapshot-id $snapshot1
    echo "Snapshot $snapshot1 has been deleted"
done
