# %%
import pandas as pd
import sqlalchemy

# Function to read sql file containing rfm query
def import_query(path):
    ''''This function read the sql file and retrieve the query as string.'''
    with open(f'{path}.sql', 'r') as open_file:
        return open_file.read()
    

# Creating sqlite engine 
ONLINERETAIL_ENGINE = sqlalchemy.create_engine('sqlite:///../data/raw/onlineretail.db')

# Importing dataframe from excel file
df = pd.read_excel('../data/raw/OnlineRetail.xlsx')
#%%
# Dumping dataframe into onlineretail database 
df.to_sql('online_retail', ONLINERETAIL_ENGINE,if_exists='replace',index=False)

path = '../queries/rfm_table_ready'
query = import_query(path)

df = pd.read_sql(query, ONLINERETAIL_ENGINE)
df.to_csv('../data/processed/rfm_score.csv', index=False)
