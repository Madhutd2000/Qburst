import boto3
import csv
import datetime
from datetime import date, timedelta
import argparse

parser = argparse.ArgumentParser()
parser.add_argument('date_arg', type=int, help="Argument to specify the month of the billing report")
parser.add_argument('filename', type=str, help="Name of the report file")
parser.add_argument('tag', type=str, help="tags")
parser.add_argument('--tag1', type=str, help="Additional tags")
parser.add_argument('reg', type=str, help="region")
args = parser.parse_args()
result = []
results = []

today = datetime.datetime.now()
end1 = date.today().replace(day=1)
enddate1 = (date.today().replace(day=1)).strftime('%Y-%m-%d')
start1 = (date.today().replace(day=1) - timedelta(days=(date.today().replace(day=1) - timedelta(days=1)).day))
startdate1 = (date.today().replace(day=1) - timedelta(days=(date.today().replace(day=1) - timedelta(days=1)).day)).strftime('%Y-%m-%d')
start2 = (start1.replace(day=1) - timedelta(days=(start1.replace(day=1) - timedelta(days=1)).day))
startdate2 = (start1.replace(day=1) - timedelta(days=(start1.replace(day=1) - timedelta(days=1)).day)).strftime('%Y-%m-%d')
start3 = (start2.replace(day=1) - timedelta(days=(start2.replace(day=1) - timedelta(days=1)).day))
startdate3 = (start2.replace(day=1) - timedelta(days=(start2.replace(day=1) - timedelta(days=1)).day)).strftime('%Y-%m-%d')

client = boto3.client('ce',args.reg)

def CostAndUsage1_addtag():
   response = client.get_cost_and_usage(
       TimePeriod = {
           'Start': startdate1,
           'End': enddate1
       },
       Granularity='MONTHLY',
       Filter={
           'Tags': {
               'Key': 'Billing',
               'Values': [
                   args.tag,args.tag1
               ]}
       },
       Metrics = ['UnblendedCost'],
       GroupBy = [{'Type': 'DIMENSION', 'Key': 'SERVICE'}]
   )
   return response

def CostAndUsage1():
   response = client.get_cost_and_usage(
       TimePeriod = {
           'Start': startdate1,
           'End': enddate1
       },
       Granularity='MONTHLY',
       Filter={
           'Tags': {
               'Key': 'Billing',
               'Values': [
                   args.tag,
               ]}
       },
       Metrics = ['UnblendedCost'],
       GroupBy = [{'Type': 'DIMENSION', 'Key': 'SERVICE'}]
   )
   return response

def CostAndUsage2_addtag():
   response = client.get_cost_and_usage(
       TimePeriod = {
           'Start': startdate2,
           'End': enddate1
       },
       Granularity='MONTHLY',
       Filter = {
           'Tags': {
               'Key': 'Billing',
               'Values': [
                   args.tag,args.tag1
               ]},
       },

       Metrics = ['UnblendedCost'],
       GroupBy = [{'Type': 'DIMENSION', 'Key': 'SERVICE'}]
   )
   return response

def CostAndUsage2():
   response = client.get_cost_and_usage(
       TimePeriod = {
           'Start': startdate2,
           'End': enddate1
       },
       Granularity='MONTHLY',
       Filter = {
           'Tags': {
               'Key': 'Billing',
               'Values': [
                   args.tag,
               ]},
       },

       Metrics = ['UnblendedCost'],
       GroupBy = [{'Type': 'DIMENSION', 'Key': 'SERVICE'}]
   )
   return response

def CostAndUsage3_addtag():
   response = client.get_cost_and_usage(
       TimePeriod = {
           'Start': startdate3,
           'End': enddate1
       },
       Granularity='MONTHLY',
       Filter={
           'Tags': {
               'Key': 'Billing',
               'Values': [
                   args.tag,args.tag1
               ]}
       },
       Metrics = ['UnblendedCost'],
       GroupBy = [{'Type': 'DIMENSION', 'Key': 'SERVICE'}]
   )
   return response

def CostAndUsage3():
   response = client.get_cost_and_usage(
       TimePeriod = {
           'Start': startdate3,
           'End': enddate1
       },
       Granularity='MONTHLY',
       Filter={
           'Tags': {
               'Key': 'Billing',
               'Values': [
                   args.tag,
               ]}
       },
       Metrics = ['UnblendedCost'],
       GroupBy = [{'Type': 'DIMENSION', 'Key': 'SERVICE'}]
   )
   return response

if args.date_arg == 1 and (args.tag1):
   result += CostAndUsage1_addtag()['ResultsByTime']
   for i in result:
       for j in i['Groups']:
          ResourceName = j['Keys'][0]
          Cost = j['Metrics']['UnblendedCost']['Amount']
          results.append([ResourceName,Cost])
   fields = ['Monthly Bill for YOUI Production',start1.strftime('%Y-%m')]
elif args.date_arg == 1 and args.tag1 == None:
   result += CostAndUsage1()['ResultsByTime']
   for i in result:
       for j in i['Groups']:
          ResourceName = j['Keys'][0]
          Cost = j['Metrics']['UnblendedCost']['Amount']
          results.append([ResourceName,Cost])
   fields = ['Monthly Bill for YOUI Production',start1.strftime('%Y-%m')]   
elif args.date_arg == 2 and (args.tag1):
   result += CostAndUsage2_addtag()['ResultsByTime']
   for i in result:
       for j in i['Groups']:
          ResourceName = j['Keys'][0]
          Cost = j['Metrics']['UnblendedCost']['Amount']
          results.append([ResourceName,Cost])
   fields = ['Monthly Bill for YOUI Production',start2.strftime('%Y-%m')]
elif args.date_arg == 2 and args.tag1 == None:
   result += CostAndUsage2()['ResultsByTime']
   for i in result:
       for j in i['Groups']:
          ResourceName = j['Keys'][0]
          Cost = j['Metrics']['UnblendedCost']['Amount']
          results.append([ResourceName,Cost])
   fields = ['Monthly Bill for YOUI Production',start2.strftime('%Y-%m')]
elif args.date_arg == 3 and (args.tag1):
   result += CostAndUsage3_addtag()['ResultsByTime']
   for i in result:
       for j in i['Groups']:
          ResourceName = j['Keys'][0]
          Cost = j['Metrics']['UnblendedCost']['Amount']
          results.append([ResourceName,Cost])
   fields = ['Monthly Bill for YOUI Production',start3.strftime('%Y-%m')]
elif args.date_arg == 3 and args.tag1 == None:
   result += CostAndUsage3()['ResultsByTime']
   for i in result:
       for j in i['Groups']:
          ResourceName = j['Keys'][0]
          Cost = j['Metrics']['UnblendedCost']['Amount']
          results.append([ResourceName,Cost])
   fields = ['Monthly Bill for YOUI Production', (start3.strftime('%Y-%m'))]
else:
    print ('Enter a valid argument to specify the time range - "1" or "2 or 3')

fields1 = ['Resource Name', 'Cost(in USD)']

# name of csv file
#filename = new+"-IAM-user-audit-"+today+".csv"import csv
# writing to csv file
if   len(result)==0:
    print("No results")
else:
    with open(args.filename, 'w') as csvfile: 
    # creating a csv writer object 
        csvwriter = csv.writer(csvfile) 

    # writing the fields 
        csvwriter.writerow(fields)

    # writing the fields 
        csvwriter.writerow(fields1) 
        
    # writing the data rows 
        csvwriter.writerows(results)
        #print (new_users)
    
