#!/bin/bash
#unset AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN
region=$1
environment=$2
ami_name_prefix=$3
no_of_ami_to_retain='1'

#debug
#cred=$(aws sts assume-role --role-arn arn:aws:iam::293238230166:role/switch-role-Administrator --role-session-name AWSCLI-Session)

#AWS_ACCESS_KEY_ID=$(echo $cred | jq -r .Credentials.AccessKeyId)
#AWS_SECRET_ACCESS_KEY=$(echo $cred | jq -r .Credentials.SecretAccessKey)
#AWS_SESSION_TOKEN=$(echo $cred | jq -r .Credentials.SessionToken)

#export AWS_ACCESS_KEY_ID
#export AWS_SECRET_ACCESS_KEY
#export AWS_SESSION_TOKEN


##  Get AMI IDs for isRelease flag true
echo "GET AMI NAME for tag IsRelease=true"
aws ec2 describe-images --region ${region} --owner self \
--filter "Name=name,Values='${ami_name_prefix}'" "Name=tag:isRelease,Values=true" \
--query 'reverse(sort_by(Images,&CreationDate))[].[ImageId]' --output text| tee ami-name-true.txt

`echo "$(<ami-name-true.txt)" | awk '(NR>'${no_of_ami_to_retain}')' > file1.txt`

##  Get AMI IDs for isRelease flag false
echo "GET AMI NAME for tag IsRelease=false"
aws ec2 describe-images --region ${region} --owner self \
--filter "Name=name,Values='${ami_name_prefix}'" "Name=tag:isRelease,Values=false" \
--query 'reverse(sort_by(Images,&CreationDate))[].[ImageId]' --output text| tee ami-name-false.txt

`echo "$(<ami-name-false.txt)" | awk '(NR>'${no_of_ami_to_retain}')' > file2.txt`

##  AMI deregister step
for deregister_ami_id in `cat file1.txt`; do
    snapshot_id=$(aws ec2 describe-images --image-ids $deregister_ami_id --region ${region} --query 'Images[*].BlockDeviceMappings[*].Ebs.SnapshotId' --output text)
    echo "Below snapshot IDs with tag isRelease=true will be deleted"
    echo $snapshot_id
    aws ec2 deregister-image --region ${region} --image-id $deregister_ami_id
    echo "AMI ID = $deregister_ami_id has been unregistered."
    aws ec2 delete-snapshot --snapshot-id $snapshot_id
    echo "Snapshot $snapshot_id has been deleted"
    sleep 10
done

##  AMI deregister step
for deregister_ami_id1 in `cat file2.txt`; do
    snapshot_id1=$(aws ec2 describe-images --image-ids $deregister_ami_id1 --region ${region} --query 'Images[*].BlockDeviceMappings[*].Ebs.SnapshotId' --output text)
    echo "Below snapshot IDs with tag isRelease=false will be deleted"
    echo $snapshot_id1
    aws ec2 deregister-image --region ${region} --image-id $deregister_ami_id1
    echo "AMI ID = $deregister_ami_id1 has been unregistered."
    aws ec2 delete-snapshot --snapshot-id $snapshot_id1
    echo "Snapshot $snapshot_id1 has been deleted"
    sleep 10
done
