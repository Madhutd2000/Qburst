import boto3
import argparse
import datetime
import json
import sys
import csv

filename = 'MONTHLY-BILL-YOUI-PRODUCTION.csv'
parser = argparse.ArgumentParser()
parser.add_argument('--days', type=int, default=30)
args = parser.parse_args()
today = datetime.datetime.now()
start = (today - datetime.timedelta(days=args.days)).strftime('%Y-%m-%d')
startdate = (today - datetime.timedelta(days=args.days)).strftime('%Y-%m')
#dt = datetime.strptime("09/12/16", "%d/%m/%y")
#startdate = dt.strftime("%d-%B")
print(startdate)
end = today.strftime('%Y-%m-%d')
result = []
results = []

client = boto3.client('ce')

response = client.get_cost_and_usage(
    TimePeriod = {
        'Start': start,
        'End': end
    },
    Granularity='MONTHLY',
    Filter={
        'Tags': {
            'Key': 'Billing',
            'Values': [
                'qb-internal',
            ]}
    },
    Metrics = ['UnblendedCost'],
    GroupBy = [{'Type': 'DIMENSION', 'Key': 'SERVICE'}]
)

result += response['ResultsByTime']

for i in result:
    for j in i['Groups']:
       ResourceName = j['Keys']
       print (ResourceName)
       Cost = j['Metrics']['UnblendedCost']['Amount']
       print (Cost)
       results.append([ResourceName,Cost])

fields = ['Monthly Bill for YOUI Production',startdate]
fields1 = ['Resource Name', 'Cost']

# name of csv file
#filename = new+"-IAM-user-audit-"+today+".csv"import csv
# writing to csv file
if   len(result)==0:
    print("No results")
else:
    with open(filename, 'w') as csvfile: 
    # creating a csv writer object 
        csvwriter = csv.writer(csvfile) 

    # writing the fields 
        csvwriter.writerow(fields)

    # writing the fields 
        csvwriter.writerow(fields1) 
        
    # writing the data rows 
        csvwriter.writerows(results)
        #print (new_users)
    
'''
res = json.dumps(response, indent=4, default=str)
print (res)
'''
