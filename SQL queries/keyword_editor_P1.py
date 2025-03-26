import csv 
import ast

with open('keywords.csv','r', encoding='utf-8') as csv_file:
    csv_reader = csv.DictReader(csv_file)
    data = [row for row in csv_reader]
   
    with open('hasKeywords.csv','w', encoding='utf-8') as new_file:
        headernames = ['movie_id','keywords']
        csv_writer= csv.DictWriter(new_file,fieldnames=headernames)
        csv_writer.writeheader()
        unq_rows = set()

        for line in data:
            jsonString=line['keywords']
            jsonData = ast.literal_eval(jsonString)
            
            for i in jsonData:
                if ((line['movie_id'], i['id']) not in unq_rows):
                    unq_rows.add((line['movie_id'],i['id']))
                    csv_writer.writerow({'movie_id':line['movie_id'],'keywords':i['id']})
    new_file.close()
    with open('keyword.csv','w', encoding='utf-8') as new_file:
        headernames = ['id','name']
        csv_writer= csv.DictWriter(new_file,fieldnames=headernames)
        csv_writer.writeheader()
        unq_rows = set()

        for line in data:
            jsonString=line['keywords']
            jsonData = ast.literal_eval(jsonString)
            
            for i in jsonData:
                if ((i['id'], i['name']) not in unq_rows):
                    unq_rows.add((i['id'],i['name']))
                    csv_writer.writerow({'id':i['id'],'name':i['name']})
    new_file.close()   
    csv_file.close()