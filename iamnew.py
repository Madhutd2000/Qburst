'''  To run the script - python3 <script file name> <no. of days for which the report should be generated> <fielname.csv> "python3 IAMusers.py 30 new.csv" '''
import csv
import boto3
import datetime
import sys
import json
from dateutil.tz import tzlocal
#import ast
import pandas as pd

today = datetime.datetime.now()
new_users=[]
new=sys.argv[1]
filename=sys.argv[2]
new=int(new)

resource = boto3.resource('iam')
iam = boto3.client('iam')
userResponse = iam.list_users()
creator = boto3.client('cloudtrail')

def check_user(users,username):
    index=-1
    for user in users:
        if (user[0] == username):
            return users.index(user)
    return index

def getCreator(maxresults):
    response = creator.lookup_events(
        LookupAttributes=[
            {
                'AttributeKey': 'EventName',
                'AttributeValue': 'CreateUser'
            },
        ],
        MaxResults=maxresults,
    )
    usercreator = {json.loads(i1['CloudTrailEvent']).get('requestParameters').get('userName') : i1.get('Username') for i1 in response.get('Events')}
    return usercreator

def getMFAAuthenticator(maxresults):
    response = creator.lookup_events(
        LookupAttributes=[
            {
                'AttributeKey': 'EventName',
                'AttributeValue': 'EnableMFADevice'
            },
        ],
        MaxResults=maxresults,
    )
    return response

user_creator = getCreator(new)
MFAUsers = {n.get('Username') for n in getMFAAuthenticator(90).get('Events')}

print("[INFO] Fetching new IAM users with console access")
for u in userResponse['Users']:
    user_created_date=u['CreateDate']
    users_name=u['UserName']
    new_user_list=(today-user_created_date.replace(tzinfo=None)).days
    if new_user_list < new:
        if (users_name in MFAUsers):
           #print("nothing",user_created_date,users_name)
           new_users.append([users_name, datetime.datetime.date(user_created_date), "CONSOLE", user_creator[users_name],"MFA Enabled"])
        else:
           new_users.append([users_name, datetime.datetime.date(user_created_date), "CONSOLE", user_creator[users_name],"MFA Disabled"]) 

        
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
                    if (user.user_name in MFAUsers):
                       new_users.append([user.user_name,datetime.datetime.date(created_date),"PROGRAMMATIC", user_creator[user.user_name],"MFA Enabled"])
                    else:
                       new_users.append([user.user_name,datetime.datetime.date(created_date),"PROGRAMMATIC", user_creator[user.user_name],"MFA Disabled"])
                 else:
                    del new_users[index]
                    if (user.user_name in MFAUsers):
                       new_users.append([user.user_name,datetime.datetime.date(created_date),"BOTH", user_creator[user.user_name],"MFA Enabled"])
                    else:
                       new_users.append([user.user_name,datetime.datetime.date(created_date),"BOTH", user_creator[user.user_name],"MFA Disabled"])


fields = ['IAM User', 'Created Date', 'Access Type', 'Created By','MFA Authentication'] 

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
    
#Reading the CSV file
df = pd.read_csv(filename)
    
#Replacing the 'instance ID' to 'Kunjappan'
df['Created By'] = df['Created By'].replace({'i-0f2f97986131e868b': 'Kunjappan'})

# writing into the file
df.to_csv(filename, index=False)
