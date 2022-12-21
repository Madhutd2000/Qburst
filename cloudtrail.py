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
    return response

def getConsoleAccess(maxresults):
    response = creator.lookup_events(
        LookupAttributes=[
            {
                'AttributeKey': 'EventName',
                'AttributeValue': 'CreateLoginProfile'
            },
        ],
        MaxResults=maxresults,
    )
    return response

def getProgrammaticAccess(maxresults):
    response = creator.lookup_events(
        LookupAttributes=[
            {
                'AttributeKey': 'EventName',
                'AttributeValue': 'CreateAccessKey'
            },
        ],
        MaxResults=maxresults,
    )
    return response

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

ProgrammaticAccessUsers = {json.loads(m['CloudTrailEvent']).get('requestParameters').get('userName') for m in getProgrammaticAccess(new).get('Events')}

#print (ProgrammaticAccessUsers)

ConsoleAccessUsers = {json.loads(j['CloudTrailEvent']).get('requestParameters').get('userName') for j in getConsoleAccess(new).get('Events')}

#print (ConsoleAccessUsers)

usercreator = {json.loads(i1['CloudTrailEvent']).get('requestParameters').get('userName') : i1.get('Username') for i1 in getCreator(new).get('Events')}

#print (usercreator)

MFAUsers = {n.get('Username') for n in getMFAAuthenticator(90).get('Events')}
#print(MFAUsers)

for i in getCreator(new).get('Events'):
    username = json.loads(i['CloudTrailEvent']).get('requestParameters').get('userName')
    usercreator = i.get('Username')
    #user = {json.loads(i['CloudTrailEvent']).get('requestParameters').get('userName') : i.get('Username')}
    created_date = i.get('EventTime')
    index=check_user(new_users,username)
    if (username in ProgrammaticAccessUsers) and (username in ConsoleAccessUsers):
        new_users.append([username,usercreator,datetime.datetime.date(created_date),"Both"])
        if (username in MFAUsers):
            new_users.append([username,usercreator,datetime.datetime.date(created_date),"Both","MFA Enabled"])
        else:
            new_users.append([username,usercreator,datetime.datetime.date(created_date),"Both","MFA Disabled"])
    elif (username in ProgrammaticAccessUsers) and (index == -1):
        del new_users[index]
        new_users.append([username,usercreator,datetime.datetime.date(created_date),"Programmatic"])
        if (username in MFAUsers):
            new_users.append([username,usercreator,datetime.datetime.date(created_date),"Both","MFA Enabled"])
        else:
            new_users.append([username,usercreator,datetime.datetime.date(created_date),"Both","MFA Disabled"])
    elif (username in ConsoleAccessUsers):
        #del new_users[index]
        new_users.append([username,usercreator,datetime.datetime.date(created_date),"Console"])
        if (username in MFAUsers):
            new_users.append([username,usercreator,datetime.datetime.date(created_date),"Both","MFA Enabled"])
        else:
            new_users.append([username,usercreator,datetime.datetime.date(created_date),"Both","MFA Disabled"])
#print(new_users)

fields = ['IAM User', 'Created By', 'Created Date', 'Access Type', 'MFA Authentication']

if len(new_users)==0:
   print("No new IAM users present")
else:
    with open(filename, 'w') as csvfile: 
    # creating a csv writer object 
        csvwriter = csv.writer(csvfile) 
        
    # writing the fields 
        csvwriter.writerow(fields) 
        
    # writing the data rows 
        csvwriter.writerows(new_users)
        #print (new_users)
        #csvwriter = ''.join([i for i in csvwriter]).replace("i-0f2f97986131e868b", "Kunjappan")
        #csvwriter.writerows(new_users)
    #Reading the CSV file
#file = pd.read_csv(filename)
        #file.replace(to_replace ="i-0f2f97986131e868b", value = "Kunjappan", inplace = True)
    #Replacing the 'instance ID' to 'Kunjappan'
#file['IAM User'] = file['IAM User'].replace({"i-0f2f97986131e868b":"Kunjappan"})

    # writing into the file
#file.to_csv(filename, index=False)
'''
text = open("input.csv", "r")
text = ''.join([i for i in text]).replace("3", "e")
x = open("output.csv","w")
x.writelines(text)
x.close()
'''

# reading the csv file
df = pd.read_csv(filename)

# updating the column value/data
df['Created By'] = df['Created By'].replace({'i-0f2f97986131e868b': 'Kunjappan'})

# writing into the file
df.to_csv(filename, index=False)

print(df)
