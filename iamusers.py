import csv
import boto3
import datetime
import sys
import json
from dateutil.tz import tzlocal

today = datetime.datetime.now()
new_users=[]
new=sys.argv[1]
filename=sys.argv[2]
new=int(new)

def check_user(users,username):
    index=-1
    for user in users:
        if (user[0] == username):
            return users.index(user)
    return index

resource = boto3.resource('iam')
iam = boto3.client('iam')
userResponse = iam.list_users()
creator = boto3.client('cloudtrail')

print("[INFO] Fetching new IAM users with console access")
for u in userResponse['Users']:
    user_created_date=u['CreateDate']
    users_name=u['UserName']
    new_user_list=(today-user_created_date.replace(tzinfo=None)).days
    if new_user_list < new:
        #print("nothing",user_created_date,users_name)
        new_users.append([users_name, str(user_created_date), "CONSOLE"])
        #print (new_users.append([users_name, str(user_created_date), "CONSOLE"]))
        
print("[INFO] Fetching new IAM users with programmatic access")
for user in resource.users.all():
    Metadata = iam.list_access_keys(UserName=user.user_name)
    if Metadata['AccessKeyMetadata'] :   
        for key in user.access_keys.all():
                AccessId = key.access_key_id
                Status = key.status
                created_date=key.create_date
                if (Status == "Active"):
                    new_key_user=(today-created_date.replace(tzinfo=None)).days
                    if new_key_user < new:
                        index=check_user(new_users,user.user_name)
                        if ( index == -1):
                            new_users.append([user.user_name,str(created_date),"PROGRAMMATIC"])
                        else:
                            del new_users[index]
                            new_users.append([user.user_name,str(created_date),"BOTH"])
                           # print (new_users)

def cloudtrail_func():
    response = creator.lookup_events(
        LookupAttributes=[
            {
                'AttributeKey': 'EventName',
                'AttributeValue': 'CreateUser'
            },
        ],
        MaxResults = 44,
    )
    return response

#print (response)
usercreator = { json.loads(i1['CloudTrailEvent']).get('requestParameters').get('userName') : i1.get('Username') for i1 in cloudtrail_func().get('Events')}
#print (usercreator)
print("[INFO] Fetching the IAM user creators")

for j in new_users:
    username = j[0]
    j.append(usercreator[username])

fields = ['IAM User', 'Created Date', 'Access Type', 'Created By'] 

# name of csv file
 
#filename = new+"-IAM-user-audit-"+today+".csv"import csv

# writing to csv file
if   len(new_users)==0:
    print("No new IAM user presents")
else:
    with open(filename, 'w') as csvfile: 
    # creating a csv writer object 
        csvwriter = csv.writer(csvfile) 
        
    # writing the fields 
        csvwriter.writerow(fields) 
        
    # writing the data rows 
        csvwriter.writerows(new_users)
        #print (new_users)
