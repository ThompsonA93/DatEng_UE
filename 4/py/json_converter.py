#pip3 install pandas
import os
import pandas as pd

#filename="aau_metadata"
#directory="../aau_refactored/"
directory='../aau_refactored/results/'

for filename in os.listdir(directory):
    f = os.path.join(directory, filename)
    if os.path.isfile(f) and ".json" in f:
        print("Converting " + f + " to .csv")
        with open(f, encoding='utf-8') as inputfile:
            df = pd.read_json(inputfile)
            df.to_csv(f+'.csv', encoding='utf-8', index=False, header=False)


#with open(''+path+filename+'.json', encoding='utf-8') as inputfile:
#    df = pd.read_json(inputfile)
#df.to_csv(''+path+filename+'.csv', encoding='utf-8', index=False)