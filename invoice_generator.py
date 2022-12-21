import boto3
import csv
import datetime
from datetime import date, timedelta
import argparse
import math
from currency_converter import CurrencyConverter
import pandas as pd

parser = argparse.ArgumentParser()
parser.add_argument('--filename', type=str, default = 'Invoicereport.csv', help="Name of the report file")
parser.add_argument('--projectname', type=str, default = 'YOUI-Production', help='Name of the Project')
parser.add_argument('--billing_tag', type=str, default = 'youi-production', help="tags")
parser.add_argument('--region', type=str, default = 'ap-northeast-1', help="region")
parser.add_argument('--currency', type=str, default = 'JPY', help="Currency of the Cost in the Report")
args = parser.parse_args()
result = []
results = []

today = datetime.datetime.now()

def convert(amount, _from, _to):
    c = CurrencyConverter()
    return(c.convert(amount, _from, _to))

last_day_of_prev_month = date.today().replace(day=1) - timedelta(days=1)
start_day_of_prev_month = date.today().replace(day=1) - timedelta(days=last_day_of_prev_month.day)

client = boto3.client('ce',args.region)

def getCost(name,value):
   response = client.get_cost_and_usage(
       TimePeriod = {
           'Start': start_day_of_prev_month.strftime('%Y-%m-%d'),
           'End': last_day_of_prev_month.strftime('%Y-%m-%d')
       },
       Granularity='MONTHLY',
       Filter={
           'Tags': {
               'Key': name,
               'Values': [
                   value,
               ]}
       },
       Metrics = ['UnblendedCost'],
       GroupBy = [{'Type': 'DIMENSION', 'Key': 'SERVICE'}]
   )
   return response

result = getCost('Billing',args.billing_tag)['ResultsByTime']
totalcost = 0
for i in result:
    for j in i['Groups']:
        ResourceName = j['Keys'][0]
        Cost = j['Metrics']['UnblendedCost']['Amount']
        Cost1 = convert(Cost,'USD',args.currency)
        results.append([ResourceName, math.ceil (Cost1)])
        totalcost += math.ceil(Cost1)

#print (totalcost)

pt = [['',''],['',''],["TotalCost", totalcost ]]

fields = [args.projectname +' '+ start_day_of_prev_month.strftime('%Y-%m')]

fields1 = ['Resource Name', 'Cost in '+args.currency ]

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

    # writing the fields 
        csvwriter.writerows(pt)
