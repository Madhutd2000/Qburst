aws ec2 describe-images --region us-east-1 --filters "Name=tag:IsRelease,Values=true" \
--query 'Images[*]' | jq -r ".Name | select(. | startswith(\"tokyo\"))" | tee ami-name.txt

aws ec2 describe-images \
    --query 'Images[*].[ImageId]' \
    --output text
    
aws ec2 describe-images --region us-east-1 --name tokyo-sample 1647349995 \
--filters "Name=tag:IsRelease,Values=true" --query 'Images[*].[Name, ImageId]' | tee ami-name.txt

aws ec2 describe-images --region us-east-1 | jq -r ".Images[]" \
 | jq -r ".Name | select(. | startswith(\"packer\"))" | tee ami-name.txt
 
 aws ec2 describe-images --region us-east-1 --filters "Name=tag:IsRelease,Values=true" --filters "Name=tag:Name,Values=tokyo6" --owner self --query 'Images[*].[ImageId, Name]' | aws ec2 deregister-image
 
 
 aws ec2 describe-images --region us-east-1 --owner self aws ec2 describe-images| \
  jq -r ".Images[] |  select(.CreationDate)" | sort -n |\
  jq -r ".Name | select(. | startswith(\"tokyo"))"  | tee /tmp/ami-name.txt
  
  
       target_ami=(`aws ec2 describe-images --region ${region} --filters "Name=name,Values=$deregister_ami_name" "Name=virtualization-type,Values=hvm" "Name=root-device-type,Values=ebs" --query "Images[].[Name, ImageId]" --output text|sort|tail -n 1`)
    if [ `aws ec2 describe-instances --region ${region} --filters "Name=instance-state-name,Values=running" "Name=image-id,Values=${target_ami[1]}" --output=text | wc -l` -eq 0 ]; then
        aws ec2 deregister-image --region ${region} --image-id ${target_ami[1]}
        echo "AMI ID = ${target_ami[1]} has been unregistered because there is no link to the running instance."
        
        
aws ec2 describe-images --region us-east-1 --owner self | jq -r ".Images[]"  | jq -r ".Name | select(. | startswith(\"packer\"))" | tee ami-name.txt

aws ec2 describe-images --region us-east-1 --owner self --filters "Name=tag:IsRelease,Values=true" --query 'Images[*].[ImageId] | jq -r ".Images[]"  | jq -r ".Name | select(. | startswith(\"packer\"))" | tee ami-name.txt

 aws ec2 describe-images --region us-east-1 --owner self --filters "Name=tag:IsRelease,Values=true" --query "sort_by(Images, &CreationDate)[].Name" | jq -r ".Images[]"  | jq -r ".Name | select(. | startswith(\"tokyo\"))" | tee ami-name-true.txt
 
 aws ec2 describe-images --region ${region} --owner self | \
  jq -r ".Images[] |  select(.CreationDate) | sort" | \
  jq -r ".Name | select(. | startswith(\"tokyo\"))"  | tee /tmp/ami-name.txt
  
aws ec2 describe-images --region us-east-1 --owner self \
--filters "Name=tag:IsRelease,Values=true" | jq -r ".Images[] | \
jq -r ".Name | select(. | startswith(\"tokyo\")) | sort_by(Images, &CreationDate)" | tee ami-name-true.txt 

aws ec2 describe-images --region us-east-1 --owner self | jq -r ".Images[] | select(.CreationDate)" | sort | \
jq -r ".Name | select(. | startswith(\"tokyo\"))" | tee ami-name-true.txt


echo "GET AMI NAME for tag IsRelease=false"
aws ec2 describe-images --region us-east-1 --owner self \
--filters "Name=tag:IsRelease,Values=false" | jq -r ".Images[]" \
 | jq -r ".Name | select(. | startswith(\"tokyo\"))" | tee ami-name-false.txt

`tac ami-name-true.txt | sed '1,3d;' | tac | tee file1.txt`

##  AMI deregister step
for deregister_ami_name in `cat file1.txt`; do
    ## Get AMI ID
    echo "Welcome"
    echo $deregister_ami_name
    target_ami=`aws ec2 describe-images --region ${region} --filters "Name=name,Values=$deregister_ami_name" --query "Images[].[ImageId]" --output text`
    echo ${target_ami[0]}
    aws ec2 deregister-image --region ${region} --image-id ${target_ami[0]}
    echo "AMI ID = ${target_ami[0]} has been unregistered."
    sleep 10
done	

##  AMI deregister step
for deregister_ami_name1 in `cat file2.txt`; do
    ## Get AMI ID
    target_ami1=`aws ec2 describe-images --region ${region} --filters "Name=name,Values=$deregister_ami_name1" --query "Images[].[ImageId]" --output text`
    echo ${target_ami1[0]}
    aws ec2 deregister-image --region ${region} --image-id ${target_ami1[0]}
    echo "AMI ID = ${target_ami1[0]} has been unregistered."
    sleep 10
done




-------------------------------------------------

#!/bin/bash
region="us-east-1"
no_of_ami_to_retain="2"

##  AMI info get step
echo "GET AMI NAME for tag IsRelease=true"
aws ec2 describe-images --region us-east-1 --owner self \
--filter "Name=name,Values=packer*" "Name=tag:IsRelease,Values=true" \
--query 'sort_by(Images, &CreationDate)[].Name' --output text| tee ami-name-true.txt

echo "GET AMI NAME for tag IsRelease=true"
aws ec2 describe-images --region us-east-1 --owner self \
--filter "Name=name,Values=packer*" "Name=tag:IsRelease,Values=true" \
--query 'reverse(sort_by(Images,&CreationDate))[].[ImageId]' --output text| tee ami-name-true.txt

`echo ami-name-true.txt | awk '(NR>$no_of_ami_to_retain)'| tee file1.txt`

echo "GET AMI NAME for tag IsRelease=false"
aws ec2 describe-images --region us-east-1 --owner self \
--filter "Name=name,Values=packer*" "Name=tag:IsRelease,Values=false" \
--query 'sort_by(Images, &CreationDate)[].Name' --output text| tee ami-name-false.txt

`tr "       " "\n" < ami-name-false.txt | sed '1,2d;' | tac | tee file2.txt`

##  AMI deregister step
for deregister_ami_name in `cat file1.txt`; do

    ## Get AMI ID
    echo "Welcome"
    echo $deregister_ami_name
    target_ami=`aws ec2 describe-images --region ${region} --filters "Name=name,Values=$deregister_ami_name" --query "Images[].[ImageId]" --output text`
    echo ${target_ami[0]}
    aws ec2 deregister-image --region ${region} --image-id ${target_ami[0]}
    echo "AMI ID = ${target_ami[0]} has been unregistered."
    sleep 10
done	

##  AMI deregister step
for deregister_ami_name1 in `cat file2.txt`; do
    ## Get AMI ID
    target_ami1=`aws ec2 describe-images --region ${region} --filters "Name=name,Values=$deregister_ami_name1" --query "Images[].[ImageId]" --output text`
    echo ${target_ami1[0]}
    aws ec2 deregister-image --region ${region} --image-id ${target_ami1[0]}
    echo "AMI ID = ${target_ami1[0]} has been unregistered."
    sleep 10
done
