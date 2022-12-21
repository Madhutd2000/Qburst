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
client = boto3.client('iam')

'''def check_user(users,username):
    index=-1
    for user in users:
        if (user[0] == username):
            return users.index(user)
    return index
    '''

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
'''response = client.list_users()
for x in response['Users']:
   print (x['UserName'])'''

ProgrammaticAccessUsers = {json.loads(m['CloudTrailEvent']).get('requestParameters').get('userName') for m in getProgrammaticAccess(new).get('Events')}

ConsoleAccessUsers = {json.loads(j['CloudTrailEvent']).get('requestParameters').get('userName') for j in getConsoleAccess(new).get('Events')}

usercreator = {json.loads(i1['CloudTrailEvent']).get('requestParameters').get('userName') : i1.get('Username') for i1 in getCreator(new).get('Events')}

MFAUsers = {n.get('Username') for n in getMFAAuthenticator(90).get('Events')}

iamuser = {l.get('UserName') for l in client.list_users().get('Users')}
#print(iamuser)

for i in getCreator(new).get('Events'):
    user = json.loads(i['CloudTrailEvent']).get('requestParameters').get('userName')
    usercreator = i.get('Username')
    #created_date = datetime.datetime.date(i.get('EventTime'))
    created_date = i.get('EventTime')
    if (user in iamuser) :
       if (user in ProgrammaticAccessUsers) and (user in ConsoleAccessUsers):
          if (user in MFAUsers):
              new_users.append([user,usercreator,created_date,"Both","MFA Enabled"])
          else:
              new_users.append([user,usercreator,created_date,"Both","MFA Disabled"])
       elif (user in ProgrammaticAccessUsers):
          if (user in MFAUsers):
              new_users.append([user,usercreator,created_date,"Programmatic","MFA Enabled"])
          else:
              new_users.append([user,usercreator,created_date,"Programmatic","MFA Disabled"])
       elif (user in ConsoleAccessUsers):
          if (user in MFAUsers):
              new_users.append([user,usercreator,created_date,"Console","MFA Enabled"])
          else:
              new_users.append([user,usercreator,created_date,"Console","MFA Disabled"])

#print(new_users)
#print("Latest Timestamp: ", max(df['new_time']))
fields = ['IAM User', 'Created By', 'Created Date', 'Access Type', 'MFA Authentication']

if len(new_users)==0:
   print("No new IAM users present")
else:
   with open(filename, 'w') as csvfile:
      csvwriter = csv.writer(csvfile)
      csvwriter.writerow(fields)
      csvwriter.writerows(new_users)

# reading the csv file
df = pd.read_csv(filename)
# updating the column value/data
df['Created By'] = df['Created By'].replace({'i-0f2f97986131e868b': 'Kunjappan'})
for n in range(len(df['IAM User'])):
   grouped_df = df.groupby('IAM User')
   maximum = grouped_df.max(df['Created Date'][n])
   df['Created Date'] = maximum.reset_index()
'''
for n in range(num):
    numbers = int(input('Enter number '))
    lst.append(numbers)

df['Created Date'] = max(df['Created Date'])

for n in range(len(df['IAM User'])):
   df['Created Date'][n] = max(df['Created Date'])

for n in user:
    df['Created Date'][n] = max(df['Created Date'][n])

grouped_df = df.groupby("Name")
Group by `"Name"` column

maximums = grouped_df.max()
Get maximum values in each group


maximums = maximums.reset_index()
Reset indices to match format


print(maximums)
'''
#df.drop_duplicates(inplace=True)
# writing into the file 
df.to_csv(filename, index=False)
