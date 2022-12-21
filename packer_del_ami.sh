#!/bin/sh
region=$1
environment=$2
ami_name_prefix=$3
no_of_ami_to_retain='5'

##  AMI info get step
echo "GET AMI NAME for tag IsRelease=true"
echo "${region}"
echo "${ami_name_prefix}"
aws ec2 describe-images --region ${region} --owner self \
--filter "Name=name,Values='${ami_name_prefix}'" "Name=tag:isRelease,Values=true" \
--query 'reverse(sort_by(Images,&CreationDate))[].[ImageId]' --output text| tee ami-name-true.txt

`echo "$(<ami-name-true.txt)" | awk '(NR>'${no_of_ami_to_retain}')' > file1.txt`

echo "GET AMI NAME for tag IsRelease=false"
echo '${region}'
echo '${ami_name_prefix}'
aws ec2 describe-images --region ${region} --owner self \
--filter "Name=name,Values='${ami_name_prefix}'" "Name=tag:isRelease,Values=false" \
--query 'reverse(sort_by(Images,&CreationDate))[].[ImageId]' --output text| tee ami-name-false.txt

`echo "$(<ami-name-false.txt)" | awk '(NR>'${no_of_ami_to_retain}')' > file2.txt`

##  AMI deregister step
for deregister_ami_id in `cat file1.txt`; do
    echo "Below AMIs with isRelease tag true will be unregistered"
    aws ec2 deregister-image --region ${region} --image-id $deregister_ami_id
    echo "AMI ID = $deregister_ami_id has been unregistered."
    sleep 10
done	

##  AMI deregister step
for deregister_ami_id1 in `cat file2.txt`; do
    echo "Below AMIs with isRelease tag false will be unregistered"
    aws ec2 deregister-image --region ${region} --image-id $deregister_ami_id1
    echo "AMI ID = $deregister_ami_id1 has been unregistered."
    sleep 10
done


              sh "chmod +x ../shell/packer_remove_old_ami.sh"
              sh "../shell/packer_remove_old_ami.sh '${AWS_REGION}' '${environment}' 'OFC-${AWS_REGION}-stage-stage-deploy-${environment}-*'"
